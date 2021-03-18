import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/user_data.dart';

abstract class CustomerService {
  Future<CustomerServiceResponse> register(
      String email, String gigyaUID, String gigyaIdToken);

  Future<CustomerServiceResponse> login(String email);

  Future<User> getCustomer(String customerId);

  Future<String> updateCustomer(String customerId, User user);

  Future<User> subscribeNewsLetter(String customerId);

  Future<void> updateBillingInfo(
    String customerId,
    AddressData billingAddress,
    String recurlyToken,
  );
}

class CustomerRegisterRequest {
  String email;
  String gigyaUID;

  CustomerRegisterRequest.create(String email, String gigyaId)
      : email = email,
        gigyaUID = gigyaId;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'gigyaId': gigyaUID,
      'isGuest': true,
    };
  }
}

class CustomerLoginRequest {
  String email;

  CustomerLoginRequest(String email) : email = email;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class CustomerServiceResponse {
  String id;
  String email;
  bool isEmailVerified;
  String firstName;
  String lastName;
  int status;

  CustomerServiceResponse(
      {this.id,
      this.email,
      this.isEmailVerified,
      this.firstName,
      this.lastName,
      this.status});

  CustomerServiceResponse.fromJson(Map<String, dynamic> map, int status)
      : id = map['id'],
        email = map['email'],
        isEmailVerified = map['isEmailVerified'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        status = status;
}

class CustomerBillingInfoUpdate {
  final String customerId;
  final AddressData billingAddress;
  final String recurlyToken;

  CustomerBillingInfoUpdate({
    this.customerId,
    this.billingAddress,
    this.recurlyToken,
  });

  Map<String, dynamic> toJson() {
    final billingInfo = {
      'firstName': billingAddress.firstName,
      'lastName': billingAddress.lastName,
      'street1': billingAddress.address1,
      'street2': billingAddress?.address2,
      'postalCode': billingAddress.zip,
      'city': billingAddress.city,
      'state': billingAddress.state,
      'country': billingAddress.country,
      'type': 'billing',
      'active': true,
      'recurlyToken': recurlyToken,
    };

    return {
      'customerId': customerId,
      'addresses': [billingInfo],
    };
  }
}
