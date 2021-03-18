import 'dart:convert';
import 'package:data/data.dart';

class AddressData extends Data {
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String phone;

  AddressData({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.phone,
  });

  Map<String, dynamic> toJsonCustom() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'phone': phone,
    };
  }

  AddressData.fromJsonCustom(Map<String, dynamic> map)
      : firstName = map['firstName'],
        lastName = map['lastName'],
        address1 = map['address1'],
        address2 = map['address2'],
        city = map['city'],
        state = map['state'],
        zip = map['zip'],
        country = map['country'],
        phone = map['phone'];

  AddressData copyWith({
    AddressData addressData,
    String firstName,
    String lastName,
    String address1,
    String address2,
    String city,
    String state,
    String zip,
    String country,
    String phone,
  }) =>
      AddressData(
        firstName: addressData?.firstName ?? firstName ?? this.firstName,
        lastName: addressData?.lastName ?? lastName ?? this.lastName,
        address1: addressData?.address1 ?? address1 ?? this.address1,
        address2: addressData?.address2 ?? address2 ?? this.address2,
        city: addressData?.city ?? city ?? this.city,
        state: addressData?.state ?? state ?? this.state,
        zip: addressData?.zip ?? zip ?? this.zip,
        country: addressData?.country ?? country ?? this.country,
        phone: addressData?.phone ?? phone ?? this.phone,
      );

  AddressData copyNewData(AddressData addressData) => AddressData(
        firstName: addressData.firstName,
        lastName: addressData.lastName,
        address1: addressData.address1,
        address2: addressData.address2,
        city: addressData.city,
        state: addressData.state,
        zip: addressData.zip,
        country: addressData.country,
        phone: addressData.phone,
      );

  @override
  List<Object> get props => [
        firstName,
        lastName,
        address1,
        address2,
        city,
        state,
        zip,
        country,
        phone,
      ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'phone': phone,
    };
  }

  factory AddressData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AddressData(
      firstName: map['firstName'],
      lastName: map['lastName'],
      address1: map['street1'],
      address2: map['street2'],
      city: map['city'],
      state: map['region'],
      zip: map['postalCode'],
      country: map['country'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressData.fromJson(String source) =>
      AddressData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressData(firstName: $firstName, lastName: $lastName, address1: $address1, address2: $address2, city: $city, state: $state, zip: $zip, country: $country, phone: $phone)';
  }
}
