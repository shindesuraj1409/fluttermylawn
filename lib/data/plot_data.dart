import 'dart:convert';

import 'package:data/data.dart';

class PlotData extends Data {
  final String id;
  final String customerId;
  final int zipCode;
  final double latitude;
  final double longitude;
  final String soilType;
  final int slope;
  final String plantType;
  final String emitter;
  final int receivesRainfall;
  final String name;
  final double goal;
  final String nozzleType;
  final DateTime createdAt;

  PlotData({
    this.id,
    this.customerId,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.soilType,
    this.slope,
    this.plantType,
    this.emitter,
    this.receivesRainfall,
    this.name,
    this.goal,
    this.nozzleType,
    this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        customerId,
        zipCode,
        latitude,
        longitude,
        soilType,
        slope,
        plantType,
        emitter,
        receivesRainfall,
        name,
        goal,
        nozzleType,
        createdAt
      ];

  PlotData copyWith({
    String id,
    int zipCode,
    double latitude,
    double longitude,
    String soilType,
    int slope,
    String plantType,
    String emitter,
    int receivesRainfall,
    String name,
    double goal,
    String nozzleType,
    DateTime createdAt,
  }) {
    return PlotData(
      id: id ?? this.id,
      customerId: customerId,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      soilType: soilType ?? this.soilType,
      slope: slope ?? this.slope,
      plantType: plantType ?? this.plantType,
      emitter: emitter ?? this.emitter,
      receivesRainfall: receivesRainfall ?? this.receivesRainfall,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      nozzleType: nozzleType ?? this.nozzleType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'soilType': soilType,
      'slope': slope,
      'plantType': plantType,
      'emitter': emitter,
      'receivesRainfall': receivesRainfall,
      'name': name,
      'goal': goal,
      'nozzleType': nozzleType,
      'createdAt': createdAt.toString()
    };
  }

  factory PlotData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlotData(
      id: map['id'],
      customerId: map['customerId'],
      zipCode: map['zipCode'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      soilType: map['soilType'],
      slope: map['slope'],
      plantType: map['plantType'],
      emitter: map['emitter'],
      receivesRainfall: map['receivesRainfall'],
      name: map['name'],
      goal: map['goal'] + .0,
      nozzleType: map['nozzleType'],
      // Temporary fix, because MR888/DMP-1357 was merged before
      // the backend part, CORE-2442, had made it to RC.
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime(0).toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlotData.fromJson(String source) =>
      PlotData.fromMap(json.decode(source));
}
