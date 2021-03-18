import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/grass_type_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/services/geo/geo_service_exceptions.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:pedantic/pedantic.dart';

class GrassTypeModel with Bus {
  final GeoService _geoService;
  GrassTypeModel() : _geoService = registry<GeoService>();

  Future<void> getGrassTypes(String zipCode) async {
    publish(data: GrassTypeData.loading());
    try {
      final zipCodePrefix = zipCode.substring(0, 3);
      final grassTypes = await _geoService.getGrassTypes(zipCodePrefix);
      final options = _convertToOptions(grassTypes);
      publish(data: GrassTypeData.success(options));
    } on InvalidZipException catch (e) {
      publish(
          data: GrassTypeData.error(
        e.errorMessage,
        state: GrassTypeState.invalid_zip_prefix,
      ));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      publish(
          data: GrassTypeData.error(
              'Something went wrong when getting grass types based on your zip code.'));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  List<Option> _convertToOptions(List<GrassType> grassTypes) {
    // Filter out 'Unknown' grass type from GeoService's grass type results
    // and then create a separate option object for 'Unknown' grass type
    // and insert it at zeroth index in options list because it needs to be
    // shown first in UI.

    final options = grassTypes
        .where((grassType) => grassType.type != LawnData.unknownGrassType)
        .map(
          (grassType) => Option(
            label: grassType.name,
            value: grassType.type,
            imageUrl: grassType.imageUrl,
          ),
        )
        .toList();

    final unknownGrassTypeOption = Option(
      label: "I don't know my grass type",
      value: LawnData.unknownGrassType,
      imageUrl:
          'https://storage.googleapis.com/smg-product-images/icons_grass.png',
    );
    options.insert(0, unknownGrassTypeOption);

    return options;
  }

  @override
  List<Channel> get channels => [Channel(GrassTypeData)];
}

class GrassTypeData extends Data {
  final List<Option> grassTypeOptions;
  final String errorMessage;
  final GrassTypeState state;

  GrassTypeData({
    this.grassTypeOptions,
    this.errorMessage,
    this.state,
  });

  GrassTypeData.loading()
      : grassTypeOptions = [],
        errorMessage = null,
        state = GrassTypeState.loading;

  GrassTypeData.success(List<Option> grassTypeOptions)
      : grassTypeOptions = grassTypeOptions,
        errorMessage = null,
        state = GrassTypeState.success;

  GrassTypeData.error(
    String errorMessage, {
    GrassTypeState state = GrassTypeState.error,
  })  : grassTypeOptions = [],
        errorMessage = errorMessage,
        state = state;

  @override
  List<Object> get props => [grassTypeOptions, state];
}

enum GrassTypeState {
  loading,
  error,
  success,
  invalid_zip_prefix,
}
