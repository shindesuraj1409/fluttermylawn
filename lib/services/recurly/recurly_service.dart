import 'dart:convert';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/recurly/i_recurly_api_client.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';

class RecurlyServiceImpl implements RecurlyService {
  final RecurlyApiClient _apiClient;

  RecurlyServiceImpl() : _apiClient = registry<RecurlyApiClient>();

  @override
  Future<String> getToken(
      AddressData billingAddress, CreditCardData creditCardData) async {
    try {
      final requestBody = <String, dynamic>{
        'version': '4.12.0',
        'first_name': billingAddress.firstName,
        'last_name': billingAddress.lastName,
        'number': creditCardData.number,
        'month': creditCardData.expiration.substring(0, 2),
        'year': creditCardData.expiration.substring(2, 4),
        'cvv': creditCardData.cvv,
        'address1': billingAddress.address1,
        'country': 'US',
        'city': billingAddress.city,
        'state': billingAddress.state,
        'postal_code': billingAddress.zip,
      };

      final response = await _apiClient.post(
        '/js/v1/token',
        body: requestBody,
      );

      final responseJson = json.decode(response.body);
      if (responseJson['error'] != null) {
        throw RecurlyException(responseJson['error']['message']);
      }

      return responseJson['id'];
    } catch (e) {
      rethrow;
    }
  }
}
