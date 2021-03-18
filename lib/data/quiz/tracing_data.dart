import 'package:data/data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TracingData extends Data {
  final Map<int, List<Marker>> markersMap;
  final Map<int, List<Polyline>> polylinesMap;
  final Map<int, Polygon> polygonsMap;
  final List<Marker> deleteMarkers;
  final Map<int, double> lawnAreaMap;

  TracingData({
    this.markersMap,
    this.polylinesMap,
    this.polygonsMap,
    this.deleteMarkers,
    this.lawnAreaMap,
  });

  TracingData.empty()
      : this(
          markersMap: {},
          polylinesMap: {},
          polygonsMap: {},
          deleteMarkers: [],
          lawnAreaMap: {},
        );

  Set<Marker> get markers => Set.of(
      markersMap.values.expand((marker) => marker).toList() + deleteMarkers);

  Set<Polyline> get polylines =>
      Set.of(polylinesMap.values.expand((polyline) => polyline).toList());

  Set<Polygon> get polygons =>
      polygonsMap.values.where((polygon) => polygon != null).toSet();

  double get totalArea => lawnAreaMap.values.fold(
        0.0,
        (double previous, double current) => previous + current,
      );

  @override
  List<Object> get props => [
        markersMap,
        polylinesMap,
        polygonsMap,
        deleteMarkers,
        lawnAreaMap,
      ];
}
