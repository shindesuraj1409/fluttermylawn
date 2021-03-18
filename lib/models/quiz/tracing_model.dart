import 'dart:math';
import 'dart:ui';

import 'package:bus/bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/quiz/tracing_data.dart';
import 'package:my_lawn/utils/poly_util.dart';
import 'package:my_lawn/utils/spherical_util.dart';
import 'package:uuid/uuid.dart';

class TracingModel with Bus {
  GoogleMapController _controller;
  BitmapDescriptor _markerIcon;
  BitmapDescriptor _deleteMarkerIcon;

  TracingData tracingData;
  int currentLawnIndex;

  static const SQ_MT_TO_FT_RATIO = 10.7639;
  @override
  List<Channel> get channels => [Channel(TracingData)];

  TracingModel() {
    tracingData = TracingData.empty();
    currentLawnIndex = 0;
    publish(data: tracingData);
  }

  void clearTrace() {
    tracingData = TracingData.empty();
    publish(data: tracingData);
  }

  void setMarkerIcon(BitmapDescriptor markerIcon) {
    _markerIcon = markerIcon;
  }

  void setDeleteMarkerIcon(BitmapDescriptor deleteMarkerIcon) {
    _deleteMarkerIcon = deleteMarkerIcon;
  }

  void onMapReady(GoogleMapController controller, LatLng latLng) {
    _controller = controller;
    _controller.moveCamera(CameraUpdate.newLatLngZoom(latLng, 19));
  }

  void onMapClicked(LatLng latLng) {
    // Check if delete markers exists and clear them first.
    _clearDeleteMarkersIfPresent();

    // Check if point selected by user is in existing lawn traced already
    // If no, we continue to add marker in the current lawn we're tracing
    // If yes, we add delete marker in center of that Lawn.
    final overlappingLawn = _findOverlappingLawn(latLng);
    if (overlappingLawn == null) {
      _addMarker(latLng);
      final markers = tracingData.markersMap;
      final currentLawnMarkers = markers[currentLawnIndex];
      if (currentLawnMarkers.length > 1) {
        // If there are more than 1 markers in current lawn traced
        // we need to draw line between those markers(between last and current marker added).
        _drawLine(
          currentLawnMarkers[currentLawnMarkers.length - 2].position,
          latLng,
        );
      }
    } else {
      _addDeleteMarker(overlappingLawn);
    }

    publish(data: tracingData);
  }

  void undo() {
    final markers = tracingData.markersMap[currentLawnIndex];
    final polylines = tracingData.polylinesMap[currentLawnIndex];
    final deleteMarkers = tracingData.deleteMarkers;
    final polygons = tracingData.polygonsMap;
    final lawnArea = tracingData.lawnAreaMap;

    // If markers are empty in current lawn traced
    // and there are more than 1 lawns traced it means
    // we need to now go to previous lawn and start doing
    // undo actions on it.
    if (markers.isEmpty && currentLawnIndex >= 0) {
      currentLawnIndex -= 1;
      undo();
    }

    // If user has completed tracing lawn and wants to undo it
    // we need to remove polygon, reset lawnarea and remove last line
    // which completed that polyogon.
    if (polygons[currentLawnIndex] != null && polylines.isNotEmpty) {
      polygons[currentLawnIndex] = null;
      lawnArea[currentLawnIndex] = 0;
      deleteMarkers.clear();
      polylines.removeLast();
      publish(data: tracingData);

      return;
    }

    // Undo markers and polylines.
    if (markers.isNotEmpty) {
      markers.removeLast();
    }
    if (polylines != null && polylines.isNotEmpty) {
      polylines.removeLast();
    }
    publish(data: tracingData);
  }

  void _onMarkerClicked(Marker marker) {
    final markers = tracingData.markersMap;
    final currentLawnMarkers = markers[currentLawnIndex];

    // Checks if there at least more than 2 markers to create polygon
    // and first marker and marker clicked are same indicating user is
    // trying to complete lawn tracing.
    if (currentLawnMarkers.length > 2 && currentLawnMarkers[0] == marker) {
      final lastMarker = currentLawnMarkers.last;
      _drawLine(lastMarker.position, marker.position);
      _drawPolygon(currentLawnMarkers);
      _computeArea();
    }
    publish(data: tracingData);
  }

  void _onDeleteMarkerClicked(Polygon polygon) {
    final markers = tracingData.markersMap;
    final deleteMarkers = tracingData.deleteMarkers;

    final polylines = tracingData.polylinesMap;
    final polygons = tracingData.polygonsMap;

    final lawnArea = tracingData.lawnAreaMap;

    final index = polygons.keys.firstWhere(
      (key) => polygons[key] == polygon,
      orElse: () => -1,
    );

    if (index != -1) {
      polygons[index] = null;
      lawnArea[index] = 0;
      polylines[index].clear();
      markers[index].clear();
      deleteMarkers.clear();
    }
    publish(data: tracingData);
  }

  void _addMarker(LatLng latLng) {
    final markers = tracingData.markersMap;
    final polylines = tracingData.polylinesMap;

    if (markers[currentLawnIndex] != null &&
        polylines[currentLawnIndex] != null &&
        markers[currentLawnIndex].isNotEmpty &&
        polylines[currentLawnIndex].isNotEmpty &&
        markers[currentLawnIndex].length ==
            polylines[currentLawnIndex].length) {
      currentLawnIndex += 1;
    }

    if (markers[currentLawnIndex] == null) {
      markers[currentLawnIndex] = [];
    }

    final markerIndex = markers[currentLawnIndex].isEmpty
        ? 0
        : markers[currentLawnIndex].length;

    final marker = Marker(
        markerId: MarkerId(Uuid().v4()),
        consumeTapEvents: true,
        position: latLng,
        icon: _markerIcon,
        anchor: Offset(0.5, 0.5),
        draggable: false,
        onTap: () {
          _onMarkerClicked(markers[currentLawnIndex][markerIndex]);
        });

    final currentLawnMarkers = markers[currentLawnIndex];
    currentLawnMarkers.add(marker);
  }

  void _addDeleteMarker(Polygon polygon) {
    final deleteMarkers = tracingData.deleteMarkers;
    final latitudes = polygon.points.map((points) => points.latitude).toList();
    final longitudes =
        polygon.points.map((points) => points.longitude).toList();

    final maxLat = latitudes.reduce((value1, value2) => max(value1, value2));
    final maxLong = longitudes.reduce((value1, value2) => max(value1, value2));

    final minLat = latitudes.reduce((value1, value2) => min(value1, value2));
    final minLong = longitudes.reduce((value1, value2) => min(value1, value2));
    final latLng = SphericalUtil.midPoint(
      LatLng(minLat, minLong),
      LatLng(maxLat, maxLong),
    );

    final deleteMarker = Marker(
        markerId: MarkerId((Uuid().v4())),
        consumeTapEvents: true,
        position: latLng,
        draggable: false,
        icon: _deleteMarkerIcon,
        onTap: () {
          _onDeleteMarkerClicked(polygon);
        });

    deleteMarkers.add(deleteMarker);
  }

  void _drawLine(LatLng prevLatLng, LatLng currentLatLng) {
    final polylines = tracingData.polylinesMap;

    final polyline = Polyline(
      polylineId: PolylineId(Uuid().v4()),
      color: Styleguide.color_gray_0,
      width: 2,
      points: [prevLatLng, currentLatLng],
    );

    if (polylines[currentLawnIndex] == null) {
      polylines[currentLawnIndex] = [];
    }
    polylines[currentLawnIndex].add(polyline);
  }

  void _drawPolygon(List<Marker> markers) {
    final polygons = tracingData.polygonsMap;

    final polygon = Polygon(
      polygonId: PolygonId(Uuid().v4()),
      fillColor: Styleguide.color_green_1,
      strokeWidth: 0,
      points: markers.map((marker) => marker.position).toList(),
    );

    polygons[currentLawnIndex] = polygon;
  }

  void _computeArea() {
    final polygons = tracingData.polygonsMap;
    final lawnArea = tracingData.lawnAreaMap;
    final path = polygons[currentLawnIndex].points;
    final areaInSqMeters = SphericalUtil.computeArea(path);
    final area = areaInSqMeters * SQ_MT_TO_FT_RATIO; // convert sq.m to sq.ft

    lawnArea[currentLawnIndex] = area;
  }

  void _clearDeleteMarkersIfPresent() {
    final deleteMarkers = tracingData.deleteMarkers;
    if (deleteMarkers.isNotEmpty) {
      deleteMarkers.clear();
    }
  }

  Polygon _findOverlappingLawn(LatLng latLng) {
    final polygons = tracingData.polygonsMap;

    final filteredPolygons = polygons.values
        .where((polygon) =>
            polygon != null && PolyUtil.isInPolygon(latLng, polygon))
        .toList();

    if (filteredPolygons.isEmpty) {
      return null;
    } else {
      return filteredPolygons.first;
    }
  }
}
