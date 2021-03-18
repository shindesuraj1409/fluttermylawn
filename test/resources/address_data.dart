// ignore_for_file: prefer_single_quotes

import 'package:my_lawn/data/address_data.dart';

// Taken from postman
final validAddress = AddressData(
  firstName: 'Test',
  lastName: 'Test',
  address1: '159 EDMONDS DR',
  address2: '',
  city: 'COMMERCIAL POINT',
  country: 'US',
  state: 'OH',
  zip: '43116-9740',
);

final inValidAddress = AddressData(
  firstName: 'Test',
  lastName: 'Test',
  address1: 'Invalid street',
  address2: '',
  city: 'COMMERCIAL POINT',
  country: 'US',
  state: 'OH',
  zip: '92612',
);

final vaildAddressResponse = {
  "statusCode": 201,
  "addressInformation": {
    "shipping_method_code": "freeshipping",
    "shipping_carrier_code": "freeshipping",
    "shipping_address": {
      "firstname": "Test",
      "lastname": "Test",
      "street": ["159 EDMONDS DR"],
      "city": "COMMERCIAL POINT",
      "region_code": "OH",
      "country_id": "US",
      "postcode": "43116-9740"
    },
  },
  "extension_attributes": {
    "valid_address": {
      "firstname": "Test",
      "lastname": "Test",
      "street": ["159 EDMONDS DR"],
      "city": "COMMERCIAL POINT",
      "region_code": "OH",
      "country_id": "US",
      "postcode": "43116-9740"
    }
  }
};

final vaildBillingAddressResponse = {
  "statusCode": 201,
  "addressInformation": {
    "shipping_method_code": "freeshipping",
    "shipping_carrier_code": "freeshipping",
    "shipping_address": {
      "firstname": "Test",
      "lastname": "Test",
      "street": ["159 EDMONDS DR"],
      "city": "COMMERCIAL POINT",
      "region_code": "OH",
      "country_id": "US",
      "postcode": "43116-9740"
    },
    "billing_address": {
      "firstname": "Test",
      "lastname": "Test",
      "street": ["159 EDMONDS DR"],
      "city": "COMMERCIAL POINT",
      "region_code": "OH",
      "country_id": "US",
      "postcode": "43116-9740"
    }
  }
};

final inValidAddressResponse = {
  "statusCode": 400,
  "message": "The shipping address failed validation.",
  "isValid": false
};
