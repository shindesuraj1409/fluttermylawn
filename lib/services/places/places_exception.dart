class PlacesAutoCompleteException implements Exception {
  final String reason;
  PlacesAutoCompleteException(this.reason);
}

class LocationInfoNotFoundException implements Exception {
  final String reason;
  LocationInfoNotFoundException(this.reason);
}

class PlaceDetailsException implements Exception {
  final String reason;
  PlaceDetailsException(this.reason);
}
