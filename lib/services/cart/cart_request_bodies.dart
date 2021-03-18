import 'package:flutter/foundation.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';

class CreateCartRequest {
  final String customerId;
  final String recommendationId;
  final CartType cartType;

  CreateCartRequest({
    @required this.customerId,
    @required this.recommendationId,
    @required this.cartType,
  });

  Map<String, dynamic> toJson() {
    if (cartType == CartType.addOn) {
      return {
        'customerId': customerId,
      };
    }
    return {
      'customerId': customerId,
      'recommendationId': recommendationId,
      'cartType': cartType.string,
      'cartEngine': 'LawnSub',
    };
  }
}

class AddToCartRequest {
  final CartItemData cartItem;

  AddToCartRequest(this.cartItem);

  Map<String, dynamic> toJson() {
    return {
      'cartItem': cartItem.toJson(),
    };
  }
}
