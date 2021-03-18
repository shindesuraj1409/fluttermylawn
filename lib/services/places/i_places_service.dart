import 'package:my_lawn/data/places/place_details_data.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';
import 'package:my_lawn/data/quiz/location_data.dart';

abstract class PlacesService {
  // Places AutoComplete Api
  Future<List<PlacePrediction>> findAddresses(String input, {String types});

  // Place Details Api
  Future<PlaceDetails> getPlaceDetails(String placeId);

  // Geocoding/Reverse-Geocoding
  Future<LocationData> findLocation();
  Future<LocationData> getLocationDataFromAddress(String address);

  // Location permission check
  Future<bool> checkIfPermissionIsGranted();

  Future<void> checkLocationPermissionState({
    Function onGranted,
    Function onDenied,
    Function onDeniedForever,
    Function onDefault,
  });
}
