// Address
import 'package:my_lawn/data/subscription_data.dart';

class ShippingAddressRequest {
  final String firstname;
  final String lastname;
  final String telephone;
  final String city;
  final String region;
  final String country_id;
  final String street;
  final String other;
  final bool isBilling;
  final String postcode;
  final ShippingAddress billingAddress;

  ShippingAddressRequest(
    this.firstname,
    this.lastname,
    this.telephone,
    this.city,
    this.region,
    this.country_id,
    this.street,
    this.other,
    this.isBilling,
    this.postcode,
    this.billingAddress,
  );

  Map<String, dynamic> toJson() {
    return {
      'addressInformation': AddressInformation(
        'freeshipping',
        'freeshipping',
        firstname,
        lastname,
        telephone,
        city,
        region,
        country_id,
        street,
        other,
        isBilling,
        postcode,
        billingAddress,
      ).toJson()
    };
  }
}

class AddressInformation {
  final String shipping_method_code;
  final String shipping_carrier_code;
  final String firstname;
  final String lastname;
  final String telephone;
  final String city;
  final String region;
  final String country_id;
  final String street;
  final String other;
  final bool isBilling;
  final String postcode;
  final ShippingAddress billingAddress;

  AddressInformation(
    this.shipping_method_code,
    this.shipping_carrier_code,
    this.firstname,
    this.lastname,
    this.telephone,
    this.city,
    this.region,
    this.country_id,
    this.street,
    this.other,
    this.isBilling,
    this.postcode,
    this.billingAddress,
  );

  Map<String, dynamic> toJson() {
    final address_json = ShippingAddress(
      firstname,
      lastname,
      telephone,
      city,
      region,
      country_id,
      street,
      other,
      postcode,
    ).toJson();
    if (isBilling) {
      return {
        'shipping_method_code': shipping_method_code,
        'shipping_carrier_code': shipping_carrier_code,
        'shipping_address': address_json,
        'billing_address': billingAddress.toJson(),
      };
    } else {
      return {
        'shipping_method_code': shipping_method_code,
        'shipping_carrier_code': shipping_carrier_code,
        'shipping_address': address_json,
      };
    }
  }
}

class ShippingAddress {
  final String firstname;
  final String lastname;
  final String telephone;
  final String city;
  final String region;
  final String country_id;
  final String street;
  final String other;
  final String postcode;

  ShippingAddress(
    this.firstname,
    this.lastname,
    this.telephone,
    this.city,
    this.region,
    this.country_id,
    this.street,
    this.other,
    this.postcode,
  );

  Map<String, dynamic> toJson() {
    final streetList = <String>[];
    streetList.add(street);
    if (other != null && other.isNotEmpty) streetList.add(other);
    return {
      'firstname': firstname,
      'lastname': lastname,
      'telephone': telephone,
      'city': city,
      'region_code': region,
      'country_id': country_id,
      'street': streetList,
      'postcode': postcode,
    };
  }

  Map<String, dynamic> toOrderJson() {
    final streetList = <String>[];
    streetList.add(street);
    if (other != null && other.isNotEmpty) streetList.add(other);
    return {
      'street1': street,
      'street2': other,
      'city': city,
      'region': region,
      'country': country_id,
      'postalCode': postcode,
    };
  }
}

class CreateOrderRequest {
  final String orderType;
  final String cartType;
  final int subscriptionId;
  final SubscriptionType subType;
  final String customerId;
  final String recommendationId;
  final String cartId;
  final String recurlyToken;
  final String phone;
  final String websiteUrl;
  final List<String> addOnSkus;

  CreateOrderRequest({
    this.orderType = 'LS',
    this.cartType = 'M2',
    this.subType,
    this.customerId,
    this.recommendationId,
    this.subscriptionId,
    this.cartId,
    this.recurlyToken,
    this.phone,
    this.websiteUrl = 'PROGRAM.SCOTTS.COM',
    this.addOnSkus,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'cartType': cartType,
      'subscriptionId': subscriptionId,
      'subType': subType.planName,
      'customerId': customerId,
      'recommendationId': recommendationId,
      'cartId': cartId,
      'recurlyToken': recurlyToken,
      'phone': phone,
      'websiteUrl': websiteUrl,
      'addOnSkus': addOnSkus
    };
  }

  Map<String, dynamic> toAddonJson() {
    return {
      'cartId': cartId,
    };
  }
}
