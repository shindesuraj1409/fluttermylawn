import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/places/address_component_data.dart';

// A data class used to represent PlaceDetails for particular placeId
// received from Place Details api
class PlaceDetails extends Equatable {
  final List<AddressComponent> addressComponents;
  final String formattedAddress;

  PlaceDetails.fromJson(Map json)
      : addressComponents = List<AddressComponent>.from(
          json['address_components']?.map(
                (prediction) => AddressComponent.fromJson(prediction),
              ) ??
              [],
        ),
        formattedAddress = json['formatted_address'] as String;

  @override
  List<Object> get props => [addressComponents, formattedAddress];
}
