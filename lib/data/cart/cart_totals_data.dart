import 'package:equatable/equatable.dart';

import 'package:my_lawn/data/cart/cart_item_data.dart';

class CartTotals extends Equatable {
  final double grand_total;
  final double base_grand_total;
  final double subtotal;
  final double subtotalWithDiscount;
  final double shippingAmount;
  final double taxAmount;
  final double discountAmount;
  final List<CartItemData> cartItems;

  CartTotals({
    this.grand_total,
    this.base_grand_total,
    this.subtotal,
    this.subtotalWithDiscount,
    this.shippingAmount,
    this.taxAmount,
    this.discountAmount,
    this.cartItems,
  });

  @override
  List<Object> get props => [
        grand_total,
        subtotal,
        subtotalWithDiscount,
        shippingAmount,
        taxAmount,
        cartItems,
      ];

  CartTotals.fromJson(Map<String, dynamic> map)
      : grand_total = (map['grand_total'] as num).toDouble(),
        base_grand_total = (map['base_grand_total'] as num).toDouble(),
        subtotal = (map['subtotal'] as num).toDouble(),
        subtotalWithDiscount =
            (map['subtotal_with_discount'] as num).toDouble(),
        shippingAmount = (map['shipping_amount'] as num).toDouble(),
        taxAmount = (map['tax_amount'] as num).toDouble(),
        discountAmount = (map['discount_amount'] as num).toDouble(),
        cartItems = List<CartItemData>.from(
          map['items']?.map(
                (x) => CartItemData.fromJson(x),
              ) ??
              [],
        );

  CartTotals copyWith({
    double base_grand_total,
    double grand_total,
    double subtotal,
    double subtotalWithDiscount,
    double shippingAmount,
    double taxAmount,
    double discountAmount,
    List<CartItemData> cartItems,
  }) {
    return CartTotals(
      base_grand_total: base_grand_total ?? this.base_grand_total,
      grand_total: grand_total ?? this.grand_total,
      subtotal: subtotal ?? this.subtotal,
      subtotalWithDiscount: subtotalWithDiscount ?? this.subtotalWithDiscount,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
