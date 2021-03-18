class ShippingAddressResponse {
  final AddressInformationResponse addressInformation;
  final AddressResponse validAddress;

  ShippingAddressResponse.fromJson(Map<String, dynamic> map)
      : addressInformation =
            AddressInformationResponse.fromJson(map['addressInformation']),
        validAddress = map['extension_attributes'] != null
            ? AddressResponse.fromJson(
                map['extension_attributes']['valid_address'])
            : null;
}

class AddressInformationResponse {
  final AddressResponse shipping_address;
  final AddressResponse billing_address;

  AddressInformationResponse({
    this.shipping_address,
    this.billing_address,
  });

  AddressInformationResponse.fromJson(Map<String, dynamic> map)
      : shipping_address = map['shipping_address'] != null
            ? AddressResponse.fromJson(map['shipping_address'])
            : null,
        billing_address = map['billing_address'] != null
            ? AddressResponse.fromJson(map['billing_address'])
            : null;
}

class AddressResponse {
  final String region;
  final String region_code;
  final String country_id;
  final List street;
  final String telephone;
  final String postcode;
  final String city;
  final String firstname;
  final String lastname;
  final String email;

  AddressResponse({
    this.region,
    this.region_code,
    this.country_id,
    this.street,
    this.telephone,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.email,
  });

  AddressResponse.fromJson(Map<String, dynamic> map)
      : region = map['region'] as String,
        region_code = map['region_code'] as String,
        country_id = map['country_id'] as String,
        street = (map['street'] as List)?.map((e) => e as String)?.toList(),
        telephone = map['telephone'] as String,
        postcode = map['postcode'] as String,
        city = map['city'] as String,
        firstname = map['firstname'] as String,
        lastname = map['lastname'] as String,
        email = null;
}
