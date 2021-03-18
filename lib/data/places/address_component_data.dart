import 'package:equatable/equatable.dart';

// A Data class to parse PlaceDetails we receive
// and used to get details like street, city, state, etc.
class AddressComponent extends Equatable {
  final List<String> types;
  final String longName;
  final String shortName;

  AddressComponent.fromJson(Map<String, dynamic> json)
      : types = List<String>.from(json['types']?.map((type) => type) ?? []),
        longName = json['long_name'] as String,
        shortName = json['short_name'] as String;

  @override
  List<Object> get props => [types, longName, shortName];
}
