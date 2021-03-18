import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_lawn/data/scotts_latlng.dart';
import 'package:my_lawn/data/places/place_details_data.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';
import 'package:my_lawn/data/quiz/location_data.dart' as lawncalc;
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_api_client.dart';
import 'package:my_lawn/services/places/places_response.dart';
import 'package:my_lawn/services/places/places_exception.dart';
import 'package:uuid/uuid.dart';

/// A Service class to do geocoding/reverse-geocoding using "flutter-geolocator" plugin and fetch places data using "Places API".
class PlacesServiceImpl implements PlacesService {
  final Location location;
  final Geolocator geolocator;
  final PlacesApiClient apiClient;

  final String placesAutoCompletePath = 'maps/api/place/autocomplete/json';
  final String placeDetailsPath = 'maps/api/place/details/json';

  // It is needed to group Place API search queries under one session for billing purposes
  // If it is not provided when using Places API, each request is treated as a separate req and charged accordingly.
  // More info : https://developers.google.com/places/web-service/session-tokens
  String sessionToken;

  PlacesServiceImpl(
    PlacesApiClient apiClient,
    Location location,
    Geolocator geolocator,
  )   : apiClient = apiClient,
        location = location,
        geolocator = geolocator,
        sessionToken = Uuid().v4();

  @override
  Future<List<PlacePrediction>> findAddresses(
    String input, {
    String types = 'address',
  }) async {
    final components = 'country:us';

    try {
      final queryParameters = {
        'sessionToken': sessionToken,
        'types': types,
        'components': components,
        'input': input,
      };

      final response = await apiClient.get(
        placesAutoCompletePath,
        queryParameters: queryParameters,
      );

      final placesResponse =
          PlacesAutoCompleteResponse.fromJson(json.decode(response.body));
      if (placesResponse.isOkay && placesResponse.errorMessage == null) {
        return placesResponse.predictions;
      } else {
        throw PlacesAutoCompleteException(placesResponse.errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    try {
      final queryParameters = {
        'sessionToken': sessionToken,
        'place_id': placeId,
      };

      final response = await apiClient.get(
        placeDetailsPath,
        queryParameters: queryParameters,
      );

      final placeDetailsResponse =
          PlaceDetailsResponse.fromJson(json.decode(response.body));
      if (placeDetailsResponse.isOkay &&
          placeDetailsResponse.errorMessage == null) {
        return placeDetailsResponse.placeDetails;
      } else {
        throw PlaceDetailsException(placeDetailsResponse.errorMessage);
      }
    } catch (e) {
      throw PlaceDetailsException('Unable to fetch place details for $placeId');
    }
  }

  @override
  Future<lawncalc.LocationData> findLocation() async {
    try {
      // Note : We're using `location` package over here despite having method in
      // `flutter-geolocator` plugin - `geolocator.getCurrentPosition()` which does same thing as
      // `location.getLocation` method in `location` package.

      // This is because native implementation of `flutter-geolocator` plugin is not entirely correct.
      // It doesn't uses some of the APIs in Android from FusedLocationProvider which makes this process
      // seamless for user which `location` package handles it quite well.
      // So, we're fetching location using `location` package and once obtained we use `flutter-geolocator`
      // plugin which does reverse-geocoding using Location data obtained from `location` package.
      final _location = await location.getLocation();

      final locationData = await _getLocationDataFromCoordinates(
        LatLng(
          _location.latitude,
          _location.longitude,
        ),
      );
      return locationData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<lawncalc.LocationData> getLocationDataFromAddress(
    String address,
  ) async {
    try {
      final placemarks = await geolocator.placemarkFromAddress(address);
      final locationData = await _convertPlacemarkToLocationData(placemarks);
      return locationData;
    } catch (e) {
      throw LocationInfoNotFoundException(
          'Error fetching place details from address: $address');
    }
  }

  @override
  Future<bool> checkIfPermissionIsGranted() async {
    var serviceEnabled;
    var permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.DENIED) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.GRANTED) {
        return false;
      }
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<lawncalc.LocationData> _getLocationDataFromCoordinates(
    LatLng location,
  ) async {
    try {
      final placemarks = await geolocator.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      final locationData = _convertPlacemarkToLocationData(placemarks);

      return locationData;
    } catch (e) {
      throw LocationInfoNotFoundException(
          'Error fetching place details from Locaton: $location');
    }
  }

  lawncalc.LocationData _convertPlacemarkToLocationData(
      List<Placemark> placemarks) {
    if (placemarks != null && placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final locationData = lawncalc.LocationData(
        city: '${placemark.locality}',
        state: '${placemark.administrativeArea}',
        address:
            '${placemark.name}, ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.administrativeArea}',
        latLng: ScottsLatLng(
            placemark.position.latitude, placemark.position.longitude),
        zipCode: placemark.postalCode,
      );

      return locationData;
    }

    return null;
  }

  @override
  Future<void> checkLocationPermissionState({
    Function onGranted,
    Function onDenied,
    Function onDeniedForever,
    Function onDefault,
  }) async {
    final permissionStatus = await location.requestPermission();
    var callback;

    switch (permissionStatus) {
      case PermissionStatus.GRANTED:
        callback = onGranted;
        break;
      case PermissionStatus.DENIED:
        callback = onDenied;
        break;
      case PermissionStatus.DENIED_FOREVER:
        callback = onDeniedForever;
        break;

      default:
        callback = onDefault;
    }

    if (callback != null) {
      callback();
    }
  }
}
