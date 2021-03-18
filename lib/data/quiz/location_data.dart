import 'package:data/data.dart';
import 'package:my_lawn/data/scotts_latlng.dart';

class LocationData extends Data {
  final String address;
  final String city;
  final String state;
  final ScottsLatLng latLng;
  final String zipCode;

  LocationData({
    this.address,
    this.city,
    this.state,
    this.latLng,
    this.zipCode,
  });

  @override
  List<Object> get props => [address, latLng, zipCode];

  LocationData copyWith({
    String address,
    String city,
    String state,
    ScottsLatLng latLng,
    String zipCode,
  }) {
    return LocationData(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      latLng: latLng ?? this.latLng,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}
