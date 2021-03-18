import 'dart:io';

import 'package:my_lawn/services/places/adobe_places_monitor.dart';
import 'package:my_lawn/services/places/adobe_places_service.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_enum.dart';

abstract class AdobePlacesRepository {
  void stopMonitoringLocation();

  void startMonitoringLocation();

  Future<String> checkLastKnownLocation();

  void checkPermissionWithReaction({
    Function onGranted,
    Function onDenied,
    Function onDeniedForever,
    Function onDefault,
  });
}

class AdobePlacesRepositoryImpl implements AdobePlacesRepository {
  static const String TAG = 'AdobePlacesRepository';

  final AdobePlacesService _adobePlacesService;
  final AdobeMonitorPlacesService _adobeMonitorPlacesService;
  final PlacesService _placesService;

  AdobePlacesRepositoryImpl(
    this._adobePlacesService,
    this._adobeMonitorPlacesService,
    this._placesService,
  );

  @override
  void stopMonitoringLocation() async {
    _adobeMonitorPlacesService.stopMonitoring();
  }

  @override
  void startMonitoringLocation() async {
    // Starts places monitor
    _adobeMonitorPlacesService.startMonitoring();

    // Gets and update immediate location
    _adobeMonitorPlacesService.updateLocation();

    // Set location monitoring mode
    if (Platform.isIOS) {
      _adobeMonitorPlacesService.setPlacesMonitorMode(_adobeMonitorPlacesService
          .getPlacesMonitorModeEnum(PlacesMonitorModes.SIGNIFICANT_CHANGES));
    }
  }

  @override
  Future<String> checkLastKnownLocation() async {
    final location = await _adobePlacesService.lastKnownLocation();
    return location;
  }

  @override
  void checkPermissionWithReaction({
    Function onGranted,
    Function onDenied,
    Function onDeniedForever,
    Function onDefault,
  }) {
     _placesService.checkLocationPermissionState(
      onGranted: onGranted,
      onDenied: onDenied,
      onDeniedForever: onDeniedForever,
      onDefault: onDefault,
    );
  }
}
