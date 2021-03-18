import 'package:equatable/equatable.dart';

// A data class used to represent a single suggestion received from Places AutoComplete api
class PlacePrediction extends Equatable {
  final String description;
  final String placeId;
  PlacePrediction({
    this.description,
    this.placeId,
  });

  PlacePrediction.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String,
        placeId = json['place_id'] as String;

  @override
  List<Object> get props => [description];
}
