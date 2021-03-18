import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

extension CompareAddressData on AddressData {
  String _normalize(String string) => string?.toUpperCase() ?? '';

  /// Compares two `AddressData`, ignoring the letter case of compared fields.
  bool caseInsensitiveEquals(AddressData other) =>
      other != null &&
      _normalize(firstName) == _normalize(other.firstName) &&
      _normalize(lastName) == _normalize(other.lastName) &&
      _normalize(address1) == _normalize(other.address1) &&
      _normalize(address2) == _normalize(other.address2) &&
      _normalize(city) == _normalize(other.city) &&
      _normalize(state) == _normalize(other.state) &&
      _normalize(zip) == _normalize(other.zip) &&
      _normalize(country) == _normalize(other.country) &&
      _normalize(phone) == _normalize(other.phone);
}

extension VerifyAddressData on AddressData {
  Future<AddressData> verify() async {
    final url =
        'https://kenhommel-eval-test.apigee.net/addresses/v1/addresses/';

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    final transId = Uuid().v4();
    final sourceService = 'LS';

    final payload = json.encode({
      'transId': transId,
      'sourceService': sourceService,
      'address': address1 ?? '',
      'apartment': address2 ?? '',
      'city': city ?? '',
      'state': state ?? '',
      'postcode': zip ?? '',
    });

    final response = await http.post(
      url,
      headers: headers,
      body: payload,
    );

    final responseJson = json.decode(response.body);

    // TODO: Do this properly: do not just pick the first available address.
    AddressData verifiedAddressData;
    try {
      if (responseJson['transId'] == transId &&
          responseJson['sourceService'] == sourceService &&
          responseJson['isValid'] == true) {
        final responseAddress =
            responseJson['result'][0]['AddressResults'][0]['EffectiveAddress'];

        final address1 = responseAddress['StreetLines'][0];
        final address2 = (responseAddress['StreetLines'] as List).length > 1
            ? responseAddress['StreetLines'][1]
            : '';
        final city = responseAddress['City'];
        final state = responseAddress['StateOrProvinceCode'];
        final zip = (responseAddress['PostalCode'] as String).substring(0, 5);

        verifiedAddressData = AddressData(
          firstName: firstName,
          lastName: lastName,
          address1: address1,
          address2: address2,
          city: city,
          state: state,
          zip: zip,
          country: country,
          phone: phone,
        );
      }
    } catch (e) {
      registry<Logger>().d('verifyAddress: $e');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return verifiedAddressData;
  }
}

extension GetFormattedAddressData on AddressData {
  String getFormattedAddressForLawnProfile() {
    var address = '';

    if (city != null) {
      address += city + ', ';
    }

    if (state != null) {
      address += state + ' ';
    }

    if (zip != null) {
      address += zip;
    }

    return address;
  }
}
