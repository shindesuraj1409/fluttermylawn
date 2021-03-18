import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/services/order/order_responses.dart';

abstract class CartService {
  Future<String> createCart(
    String customerId,
    String recommendationId,
    CartType cartType,
  );

  Future<CartItemData> addToCart(CartItemData cartItem);

  Future<bool> removeFromCart(String cartId, int cartItemId);

  Future<CartTotals> getCartTotals(String cartId);

  Future<List<CartItemData>> getCartInfo(String cartId);

  Future<ShippingAddressResponse> setShippingAddress(
      AddressData addressData, String cartId);

  Future<ShippingAddressResponse> setBillingAddress(
      AddressData shippingData, AddressData billingData, String cartId);
}
