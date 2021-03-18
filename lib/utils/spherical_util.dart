import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/extensions/geometry_extension.dart';

const double EARTH_RADIUS = 6371009;

/// Util class which contains some static methods to do area and size calculations related to Map.
///
/// Copy pasta from Google Maps Android Sdk SphericalUtil class.
/// This is because Flutter plugin doesn't have those methods needed for calculating
/// area and other math things.
class SphericalUtil {
  static double computeArea(List<LatLng> path) {
    return _computeSignedArea(path, EARTH_RADIUS).abs();
  }

  /// Returns the signed area of a closed path on a sphere of given radius.
  /// The computed area uses the same units as the radius squared.
  static double _computeSignedArea(List<LatLng> path, double radius) {
    final size = path.length;
    if (size < 3) {
      return 0;
    }
    // ignore: omit_local_variable_types
    double total = 0;
    final prev = path[size - 1];
    var prevTanLat = tan((pi / 2 - prev.latitude.toRadians()) / 2);
    var prevLng = prev.longitude.toRadians();
    // For each edge, accumulate the signed area of the triangle formed by the North Pole
    // and that edge ("polar triangle").
    for (var point in path) {
      final tanLat = tan((pi / 2 - point.latitude.toRadians()) / 2);
      final lng = point.longitude.toRadians();
      total += _polarTriangleArea(tanLat, lng, prevTanLat, prevLng);
      prevTanLat = tanLat;
      prevLng = lng;
    }
    return total * (radius * radius);
  }

  static double _polarTriangleArea(
      double tan1, double lng1, double tan2, double lng2) {
    final deltaLng = lng1 - lng2;
    final t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
  }

  static LatLng midPoint(final LatLng min, final LatLng max) {
    final dLon = (max.longitude - min.longitude).toRadians();

    //convert to radians
    final lat1 = min.latitude.toRadians();
    final lat2 = max.latitude.toRadians();
    final lon1 = min.longitude.toRadians();

    final Bx = cos(lat2) * cos(dLon);
    final By = cos(lat2) * sin(dLon);
    final lat3 = atan2(sin(lat1) + sin(lat2),
        sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By));
    final lon3 = lon1 + atan2(By, cos(lat1) + Bx);

    return LatLng(lat3.toDegrees(), lon3.toDegrees());
  }
}
