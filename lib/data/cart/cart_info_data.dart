import 'package:equatable/equatable.dart';

import 'cart_item_data.dart';

class CartInfo extends Equatable {
  final List<CartItemData> cartItems;

  CartInfo.fromJson(Map<String, dynamic> map)
      : cartItems = List<CartItemData>.from(
          map['items']?.map(
                (x) => CartItemData.fromJson(x),
              ) ??
              [],
        );

  @override
  List<Object> get props => [cartItems];
}
