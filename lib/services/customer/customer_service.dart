import 'dart:convert';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/customer/customer_service_excpetion.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/scotts_api_client.dart';

class CustomerServiceImpl extends CustomerService {
  final ScottsApiClient _apiClient;

  CustomerServiceImpl() : _apiClient = registry<ScottsApiClient>();

  @override
  Future<CustomerServiceResponse> login(String email) async {
    try {
      final response = await _apiClient.post('/customers/v1/customer/login',
          body: CustomerLoginRequest(email).toJson());

      final customerRegisterResponse = CustomerServiceResponse.fromJson(
          jsonDecode(response.body), response.statusCode);

      if (response.statusCode == 404) {
        /** If a user is registered with Gigya but not Scott's we will receive a 404 Account Not Found.
         * Attempt to re-register them, if that fails then show error.
         **/
        return customerRegisterResponse;
      }

      if (response.statusCode != 201) {
        throw getRESTException(response.statusCode);
      }

      return customerRegisterResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CustomerServiceResponse> register(
      String email, String gigyaId, String gigyaIdToken) async {
    try {
      final response = await _apiClient.post('/customers/v1/customer/register',
          body: CustomerRegisterRequest.create(email, gigyaId).toJson(),
          headers: {
            'origin': 'https://develop.scottsprogram.com',
          });

      final customerRegisterResponse = CustomerServiceResponse.fromJson(
          jsonDecode(response.body), response.statusCode);

      if (response.statusCode != 201) {
        throw getRESTException(response.statusCode);
      }

      return customerRegisterResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getCustomer(String customerId) async {
    try {
      final response = await _apiClient.get(
        '/customers/v1/customer/$customerId',
      );

      if (response.statusCode != 200) {
        throw getRESTException(response.statusCode);
      }

      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateCustomer(String customerId, User user) async {
    try {
      final response = await _apiClient.put(
        '/customers/v1/customer/$customerId',
        body: user.toJsonForUpdate(),
      );

      if (response.statusCode != 200) {
        throw getRESTException(response.statusCode);
      }

      final map = jsonDecode(response.body);
      return map['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> subscribeNewsLetter(String customerId) async {
    try {
      final response = await _apiClient.put(
        '/customers/v1/customer/newsletter/subscribe',
        body: {
          'customerId': customerId,
          'subscriptionType': 'MyLawn',
        },
      );

      if (response.statusCode != 200) {
        throw getRESTException(response.statusCode);
      }

      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBillingInfo(
    String customerId,
    AddressData billingAddress,
    String recurlyToken,
  ) async {
    try {
      final requestBody = CustomerBillingInfoUpdate(
        customerId: customerId,
        billingAddress: billingAddress,
        recurlyToken: recurlyToken,
      ).toJson();

      final response = await _apiClient.post(
        '/customers/v1/customer/updateAddresses',
        body: requestBody,
      );

      if (response.statusCode != 201) {
        throw UpdateBillingInfoException('Unable to update Billing Info');
      }
      return;
    } catch (e) {
      rethrow;
    }
  }
}
