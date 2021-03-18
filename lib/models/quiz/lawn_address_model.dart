import 'dart:async';

import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';
import 'package:my_lawn/data/quiz/location_data.dart';
import 'package:my_lawn/services/geo/geo_service_exceptions.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_exception.dart';
import 'package:pedantic/pedantic.dart';

import 'package:rxdart/rxdart.dart';

class LawnAddressModel with Bus {
  final PlacesService placesService;
  final GeoService geoService;
  final searchSubject = BehaviorSubject<String>();

  LawnAddressModel()
      : placesService = registry<PlacesService>(),
        geoService = registry<GeoService>();

  @override
  void onInit() {
    super.onInit();
    publish(data: LawnAddressData.initial());
    publish(data: LawnZoneState.initial);

    searchSubject
        .debounceTime(Duration(milliseconds: 300))
        .where((address) => address.isNotEmpty)
        .doOnEach((_) {
          publish(data: LawnAddressData.loading());
        })
        .switchMap((address) => Stream.fromFuture(_searchByAddress(address)))
        .takeWhile((_) => isInitialized)
        .listen(
          (addresses) {
            publish(
              data: LawnAddressData.success(predictions: addresses),
            );
          },
          onError: (error) {
            publish(
              data: LawnAddressData.error(
                  LawnAddressState.placesAutoCompleteError),
            );
          },
        );
  }

  void onAddressChange(String inputAddress) {
    searchSubject.add(inputAddress);
  }

  Future<List<PlacePrediction>> _searchByAddress(String addressInput) =>
      placesService.findAddresses(addressInput);

  void searchByLocation() async {
    try {
      publish(data: LawnAddressData.loading());
      final isPermissionGranted =
          await placesService.checkIfPermissionIsGranted();
      if (!isPermissionGranted) {
        publish(data: LawnAddressData.error(LawnAddressState.permissionError));
        return;
      }

      final locationData = await placesService.findLocation();
      publish(
        data: LawnAddressData.success(locationData: locationData),
      );
    } on LocationInfoNotFoundException catch (e) {
      log.warning(e.reason);
      publish(
        data: LawnAddressData.error(LawnAddressState.locationFetchError),
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Future<LocationData> fetchPlaceDetails(String address) async {
    try {
      publish(data: LawnAddressData.loading());
      final locationData =
          await placesService.getLocationDataFromAddress(address);
      publish(data: LawnAddressData.success(locationData: locationData));
      return locationData;
    } on LocationInfoNotFoundException catch (e) {
      log.warning(e.reason);
      publish(
        data: LawnAddressData.error(LawnAddressState.locationFetchError),
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      return null;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      return null;
    }
  }

  void clearSearch() {
    publish(data: LawnAddressData.initial());
  }

  Future<String> getLawnZone(String zipCode) async {
    publish(data: LawnZoneState.loading);
    try {
      final zipCodePrefix = zipCode.substring(0, 3);
      final result = await geoService.getLawnZone(zipCodePrefix);
      publish(data: LawnZoneState.success);
      return result;
    } on InvalidZipException {
      publish(data: LawnZoneState.invalidZipCodeError);
      rethrow;
    } catch (e) {
      publish(data: LawnZoneState.error);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      rethrow;
    }
  }

  @override
  List<Channel> get channels => [
        Channel(LawnAddressData),
        Channel(LawnZoneState),
      ];
}

enum LawnAddressState {
  initial,
  loading,
  placesAutoCompleteError,
  locationFetchError,
  permissionError,
  success,
}

class LawnAddressData extends Data {
  final LocationData locationData;
  final List<PlacePrediction> predictions;
  final LawnAddressState state;

  LawnAddressData({
    this.locationData,
    this.predictions,
    this.state,
  });

  LawnAddressData.initial()
      : predictions = [],
        locationData = null,
        state = LawnAddressState.initial;

  LawnAddressData.loading()
      : predictions = [],
        locationData = null,
        state = LawnAddressState.loading;

  LawnAddressData.success({
    List<PlacePrediction> predictions = const [],
    LocationData locationData,
  })  : predictions = predictions,
        locationData = locationData,
        state = LawnAddressState.success;

  LawnAddressData.error(LawnAddressState state)
      : predictions = [],
        locationData = null,
        state = state;

  @override
  List<Object> get props => [locationData, predictions, state];
}

enum LawnZoneState {
  initial,
  loading,
  error,
  invalidZipCodeError,
  success,
}
