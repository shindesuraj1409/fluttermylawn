import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_acpplaces/flutter_acpplaces.dart';
import 'package:flutter_acpplaces/src/flutter_acpplaces_objects.dart';
import 'package:my_lawn/data/scotts_latlng.dart';
import 'package:pedantic/pedantic.dart';

abstract class AdobePlacesService {
  Future<String> getSdkVersion();

  Future<void> clearPlaces();

  Future<String> currentPointsOfInterest();

  Future<String> lastKnownLocation();

  Future<String> getNearbyPointsOfInterest({ScottsLatLng latLng, int limit});

  Future<void> processGeofence(Map<String, dynamic> data);

  Future<void> setAuthorizationStatus(PlacesAuthStatus authStatus);

  ACPPlacesAuthorizationStatus getACPPlacesAuthorizationStatus(
    PlacesAuthStatus authStatus,
  );
}

class AdobePlacesServiceImpl implements AdobePlacesService {
  static const String TAG = 'AdobePlacesService';

  @override
  Future<String> getSdkVersion() async {
    final version = await FlutterACPPlaces.extensionVersion;

    return version;
  }

  ///Clear client side Places plugin data
  @override
  Future<void> clearPlaces() async {
    try {
      await FlutterACPPlaces.clear;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Get the current POI's that the device is currently known to be within
  @override
  Future<String> currentPointsOfInterest() async {
    String result;

    try {
      result = await FlutterACPPlaces.currentPointsOfInterest;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
    return result;
  }

  ///Get the last latitude and longitude stored in the Places plugin
  @override
  Future<String> lastKnownLocation() async {
    String result;

    try {
      result = await FlutterACPPlaces.lastKnownLocation;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
    return result;
  }

  ///Get a list of nearby POI's
  @override
  Future<String> getNearbyPointsOfInterest(
      {ScottsLatLng latLng, int limit}) async {
    String result;

    try {
      final location = {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude
      };
      result =
          await FlutterACPPlaces.getNearbyPointsOfInterest(location, limit);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
    return result;
  }

  ///Pass a Geofence and transition type to be processed by the Places plugin [data]should be formed like this =>
  /// {
  ///   'requestId':'d4e72ade-0400-4280-9bfe-8ba7553a6444',
  ///   'latitude':37.3309422,
  ///   'longitude': -121.8939077,
  ///   'radius': 1000,
  ///   'expirationDuration':-1
  ///}
  @override
  Future<void> processGeofence(Map<String, dynamic> data) async {
    final geofence = Geofence(data);
    await FlutterACPPlaces.processGeofence(
        geofence, ACPPlacesRegionEventType.ENTRY);
  }

  ///Set the authorization status
  @override
  Future<void> setAuthorizationStatus(PlacesAuthStatus authStatus) async {
    final acpPlacesAuthorizationStatus =
        getACPPlacesAuthorizationStatus(authStatus ?? PlacesAuthStatus.ALWAYS);

    await FlutterACPPlaces.setAuthorizationStatus(acpPlacesAuthorizationStatus);
  }

  ///Converting enum value of [PlacesAuthStatus] to [ACPPlacesAuthorizationStatus]
  @override
  ACPPlacesAuthorizationStatus getACPPlacesAuthorizationStatus(
    PlacesAuthStatus authStatus,
  ) {
    ACPPlacesAuthorizationStatus acpPlacesAuthorizationStatus;
    switch (authStatus) {
      case PlacesAuthStatus.DENIED:
        acpPlacesAuthorizationStatus = ACPPlacesAuthorizationStatus.DENIED;
        break;
      case PlacesAuthStatus.ALWAYS:
        acpPlacesAuthorizationStatus = ACPPlacesAuthorizationStatus.ALWAYS;
        break;
      case PlacesAuthStatus.UNKNOWN:
        acpPlacesAuthorizationStatus = ACPPlacesAuthorizationStatus.UNKNOWN;
        break;
      case PlacesAuthStatus.RESTRICTED:
        acpPlacesAuthorizationStatus = ACPPlacesAuthorizationStatus.RESTRICTED;
        break;
      case PlacesAuthStatus.WHENINUSE:
        acpPlacesAuthorizationStatus = ACPPlacesAuthorizationStatus.WHENINUSE;
        break;
    }

    return acpPlacesAuthorizationStatus;
  }
}

enum PlacesAuthStatus {
  DENIED,
  ALWAYS,
  UNKNOWN,
  RESTRICTED,
  WHENINUSE,
}
