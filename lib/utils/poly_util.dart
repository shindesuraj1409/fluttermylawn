import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/extensions/geometry_extension.dart';

/// Util class which contains some static methods to do polygon calculations.
///
/// Copy pasta from Google Maps Android Sdk PolyUtil class.
/// This is because Flutter plugin doesn't have those methods needed for calculating
/// whether LatLng is in polygon or not.
class PolyUtil {
  static bool isInPolygon(LatLng latLng, Polygon polygon) {
    final lat3 = latLng.latitude.toRadians();
    final lng3 = latLng.longitude.toRadians();
    final prev = polygon.points.last;
    var lat1 = prev.latitude.toRadians();
    var lng1 = prev.longitude.toRadians();
    var nIntersect = 0;
    for (var point2 in polygon.points) {
      final dLng3 = (lng3 - lng1).wrap(-pi, pi);
      // Special case: point equal to vertex is inside.
      if (lat3 == lat1 && dLng3 == 0) {
        return true;
      }
      final lat2 = point2.latitude.toRadians();
      final lng2 = point2.longitude.toRadians();
      // Offset longitudes by -lng1.
      if (intersects(lat1, lat2, (lng2 - lng1).wrap(-pi, pi), lat3, dLng3,
          polygon.geodesic)) {
        ++nIntersect;
      }
      lat1 = lat2;
      lng1 = lng2;
    }
    return ((nIntersect & 1) != 0);
  }

  static bool intersects(double lat1, double lat2, double lng2, double lat3,
      double lng3, bool geodesic) {
    // Both ends on the same side of lng3.
    if ((lng3 >= 0 && lng3 >= lng2) || (lng3 < 0 && lng3 < lng2)) {
      return false;
    }
    // Point is South Pole.
    if (lat3 <= -pi / 2) {
      return false;
    }
    // Any segment end is a pole.
    if (lat1 <= -pi / 2 ||
        lat2 <= -pi / 2 ||
        lat1 >= pi / 2 ||
        lat2 >= pi / 2) {
      return false;
    }
    if (lng2 <= -pi) {
      return false;
    }
    final linearLat = (lat1 * (lng2 - lng3) + lat2 * lng3) / lng2;
    // Northern hemisphere and point under lat-lng line.
    if (lat1 >= 0 && lat2 >= 0 && lat3 < linearLat) {
      return false;
    }
    // Southern hemisphere and point above lat-lng line.
    if (lat1 <= 0 && lat2 <= 0 && lat3 >= linearLat) {
      return true;
    }
    // North Pole.
    if (lat3 >= pi / 2) {
      return true;
    }
    // Compare lat3 with latitude on the GC/Rhumb segment corresponding to lng3.
    // Compare through a strictly-increasing function (tan() or mercator()) as convenient.
    return geodesic
        ? tan(lat3) >= tanLatGC(lat1, lat2, lng2, lng3)
        : mercator(lat3) >= mercatorLatRhumb(lat1, lat2, lng2, lng3);
  }

  static double tanLatGC(double lat1, double lat2, double lng2, double lng3) {
    return (tan(lat1) * sin(lng2 - lng3) + tan(lat2) * sin(lng3)) / sin(lng2);
  }

  static double mercator(double lat) {
    return log(tan(lat * 0.5 + pi / 4));
  }

  static double mercatorLatRhumb(
      double lat1, double lat2, double lng2, double lng3) {
    return (mercator(lat1) * (lng2 - lng3) + mercator(lat2) * lng3) / lng2;
  }
}
