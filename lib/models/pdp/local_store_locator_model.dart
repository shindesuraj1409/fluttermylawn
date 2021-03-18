import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PDP_screen/state.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_exception.dart';

import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:my_lawn/services/store_locator/store_locator_service.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class LocalStoreLocatorModel with Bus {
  final StoreLocatorService _locatorService;
  final PlacesService _placesService;
  String productId;

  final _searchSubject = BehaviorSubject<String>();

  LocalStoreLocatorModel()
      : _locatorService = registry<StoreLocatorService>(),
        _placesService = registry<PlacesService>();

  void sendAdobeAnalytic(String zipCode) {
    registry<AdobeRepository>().trackAppState(
      StoreLocatorScreenAdobeState(zipCode: zipCode),
    );
  }

  @override
  void onInit() {
    super.onInit();
    publish(data: LocalStoresData.initial());

    _searchSubject
        .debounceTime(Duration(milliseconds: 300))
        .distinct()
        .where((zipcode) => zipcode.isNotEmpty)
        .doOnEach((_) {
          publish(data: LocalStoresData.loading());
        })
        .flatMap(
          (zipcode)  {
            sendAdobeAnalytic(zipcode);

            return Stream.fromFuture(
              _placesService.findAddresses(zipcode, types: '(regions)'),
            );
          }
        )
        .doOnData(
          (addresses) {
            if (addresses == null || addresses.isEmpty) {
              throw PlacesAutoCompleteException(
                  'No address found for entered zipcode');
            }
          },
        )
        .where((addresses) => addresses != null && addresses.isNotEmpty)
        .flatMap(
          (address) => Stream.fromFuture(
            _placesService.getLocationDataFromAddress(address[0].description),
          ),
        )
        .switchMap(
          (address) => Stream.fromFuture(
            _findLocalStores(
              productId,
              address.latLng.latitude,
              address.latLng.longitude,
            ),
          ),
        )
        .map(
          (stores) => stores
            ..sort(
              (store1, store2) =>
                  store1.distanceMi.compareTo(store2.distanceMi),
            ),
        )
        .takeWhile((_) => isInitialized)
        .listen(
          (stores) {
            publish(
              data: LocalStoresData.success(stores),
            );
          },
          onError: (error) {
            _handleError(error);
          },
        );
  }

  void onZipCodeChanged(String zipCode) {
    _searchSubject.add(zipCode);
  }

  void searchByLocation() async {
    try {
      publish(data: LocalStoresData.loading());
      final isPermissionGranted =
          await _placesService.checkIfPermissionIsGranted();
      if (!isPermissionGranted) {
        publish(data: LocalStoresData.error(LocalStoreState.permissionError));
        return;
      }

      final locationData = await _placesService.findLocation();
      publish(name: 'currentLocationZipCode', data: locationData.zipCode);

      final stores = await _findLocalStores(
        productId,
        locationData.latLng.latitude,
        locationData.latLng.longitude,
      );

      publish(
        data: LocalStoresData.success(stores),
      );
    } on StoreLocatorException catch (e) {
      log.warning(e.reason);
      publish(data: LocalStoresData.error(LocalStoreState.storeLocatorError));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      log.warning(e.toString());
      publish(data: LocalStoresData.error(LocalStoreState.unknownError));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Future<List<Store>> _findLocalStores(
          String productId, double latitude, double longitude) =>
      _locatorService.getLocalStores(productId, latitude, longitude);

  void _handleError(Exception error) {
    if (error is LocationInfoNotFoundException) {
      publish(
          data: LocalStoresData.error(LocalStoreState.locationNotFoundError));
    } else if (error is PlacesAutoCompleteException) {
      publish(data: LocalStoresData.error(LocalStoreState.placesApiError));
    } else if (error is StoreLocatorException) {
      publish(data: LocalStoresData.error(LocalStoreState.storeLocatorError));
    } else {
      publish(data: LocalStoresData.error(LocalStoreState.unknownError));
    }
  }

  @override
  List<Channel> get channels => [
        Channel(LocalStoresData),
        Channel(String, name: 'currentLocationZipCode'),
      ];
}

class LocalStoresData extends Data {
  final List<Store> stores;
  final LocalStoreState state;

  LocalStoresData({this.stores, this.state});

  LocalStoresData.initial()
      : stores = null,
        state = LocalStoreState.initial;

  LocalStoresData.loading()
      : stores = null,
        state = LocalStoreState.loading;

  LocalStoresData.error(LocalStoreState state)
      : stores = null,
        state = state;

  LocalStoresData.success(List<Store> stores)
      : stores = stores,
        state = LocalStoreState.success;

  @override
  List<Object> get props => [stores, state];
}

enum LocalStoreState {
  initial,
  loading,
  permissionError,
  placesApiError,
  locationNotFoundError,
  storeLocatorError,
  unknownError,
  success,
}

extension ErrorState on LocalStoreState {
  String get errorMessage {
    switch (this) {
      case LocalStoreState.locationNotFoundError:
        return 'Location not found. Please try again';
      case LocalStoreState.placesApiError:
        return 'Unable to search stores for entered zip code. Please try again with a valid zip code';
      case LocalStoreState.storeLocatorError:
        return 'Unable to find any stores. Please try again';
      case LocalStoreState.permissionError:
        return "To use this feature please allow this app access to the location by changing it in the device's settings.";
      case LocalStoreState.unknownError:
        return 'Something went wrong. Please try again';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}
