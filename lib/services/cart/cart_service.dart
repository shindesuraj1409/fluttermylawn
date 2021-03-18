import 'dart:convert';

import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/cart/cart_info_data.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/services/cart/cart_api_exceptions.dart';
import 'package:my_lawn/services/cart/cart_request_bodies.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/order/order_request_bodies.dart';
import 'package:my_lawn/services/order/order_responses.dart';
import 'package:my_lawn/services/scotts_api_client.dart';

class CartServiceImpl implements CartService {
  final ScottsApiClient _apiClient;
  final String _basePath;

  CartServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = '/carts/rest/default/V1/guest-carts';

  @override
  Future<String> createCart(
    String customerId,
    String recommendationId,
    CartType cartType,
  ) async {
    try {
      final requestBody = CreateCartRequest(
        customerId: customerId,
        recommendationId: recommendationId,
        cartType: cartType,
      ).toJson();

      final response = await _apiClient.post(
        _basePath,
        body: requestBody,
      );

      if (response.statusCode != 201) {
        throw CreateCartException(
            'Sorry, unable to create cart at the moment.');
      }

      final cartId = response.body;
      return cartId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartItemData> addToCart(CartItemData cartItem) async {
    try {
      final requestBody = CartItemData(
        sku: cartItem.sku,
        cartId: cartItem.cartId,
        qty: cartItem.qty,
      ).toCartItemJson();

      final response = await _apiClient.post(
        '$_basePath/${cartItem.cartId}/items',
        body: requestBody,
      );

      if (response.statusCode != 200) {
        throw AddToCartException(
          message: 'Unabled to add product to the Cart',
          sku: cartItem.sku,
        );
      }

      final cartItemData = CartItemData.fromJson(json.decode(response.body));
      return cartItemData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> removeFromCart(String cartId, int cartItemId) async {
    try {
      final response =
          await _apiClient.delete('$_basePath/$cartId/items/$cartItemId');
      if (response.statusCode == 200) {
        return true;
      }

      throw RemoveFromCartException(
        message: 'Unable to remove product from the Cart',
        itemId: cartItemId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartTotals> getCartTotals(String cartId) async {
    try {
      final response = await _apiClient.get('$_basePath/$cartId/totals');
      if (response.statusCode != 200) {
        throw GetCartTotalsException('Unable to get Order Summary');
      }

      final cartTotals = CartTotals.fromJson(json.decode(response.body));
      return cartTotals;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItemData>> getCartInfo(String cartId) async {
    try {
      final response = await _apiClient.get('$_basePath/$cartId');
      if (response.statusCode != 200) {
        throw GetCartInfoException('Error! Cannot get cart info');
      }
      final cartInfo = CartInfo.fromJson(json.decode(response.body));
      return cartInfo.cartItems;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ShippingAddressResponse> setBillingAddress(
    AddressData shippingData,
    AddressData billingData,
    String cartId,
  ) async {
    try {
      final billingAddress = ShippingAddress(
        billingData.firstName,
        billingData.lastName,
        billingData.phone,
        billingData.city,
        billingData.state,
        'US',
        billingData.address1,
        billingData.address2,
        billingData.zip,
      );

      final addressShippingRequest = ShippingAddressRequest(
        shippingData.firstName,
        shippingData.lastName,
        shippingData.phone,
        shippingData.city,
        shippingData.state,
        'US',
        shippingData.address1,
        shippingData.address2,
        true,
        shippingData.zip,
        billingAddress,
      );

      final response = await _apiClient.post(
        '/carts/rest/default/V1/guest-carts/' +
            cartId +
            '/shipping-information',
        body: addressShippingRequest.toJson(),
      );

      if (response.statusCode != 201) {
        final map = json.decode(
          response.body,
        );
        throw BillingAddressException(map['message']);
      }

      final addressResponse = ShippingAddressResponse.fromJson(json.decode(
        response.body,
      ));
      return addressResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ShippingAddressResponse> setShippingAddress(
      AddressData addressData, String cartId) async {
    try {
      final addressShippingRequest = ShippingAddressRequest(
        addressData.firstName,
        addressData.lastName,
        addressData.phone,
        addressData.city,
        addressData.state,
        'US',
        addressData.address1,
        addressData.address2,
        false,
        addressData.zip,
        null,
      );

      final response = await _apiClient.post(
        '/carts/rest/default/V1/guest-carts/' +
            cartId +
            '/shipping-information',
        body: addressShippingRequest.toJson(),
      );

      if (response.statusCode != 201) {
        final map = json.decode(
          response.body,
        );
        throw ShippingAddressException(map['message']);
      }

      final addressResponse = ShippingAddressResponse.fromJson(json.decode(
        response.body,
      ));
      return addressResponse;
    } catch (e) {
      rethrow;
    }
  }
}
