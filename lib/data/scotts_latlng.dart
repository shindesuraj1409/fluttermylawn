

class ScottsLatLng {
  const ScottsLatLng(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        latitude =
        (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  /// Converts this object to something serializable in JSON.
  dynamic toJson() {
    return <double>[latitude, longitude];
  }

  /// Initialize a LatLng from an \[lat, lng\] array.
  static ScottsLatLng fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return ScottsLatLng(json[0], json[1]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is ScottsLatLng && o.latitude == latitude && o.longitude == longitude;
  }
}
