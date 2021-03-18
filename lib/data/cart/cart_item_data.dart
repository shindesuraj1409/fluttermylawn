import 'package:equatable/equatable.dart';

class CartItemData extends Equatable {
  final int id;

  final String cartId;
  final String sku;
  final int qty;
  final double price;
  final double rowTotal;

  final String name;
  final String product_type;

  CartItemData({
    this.id,
    this.cartId,
    this.sku,
    this.qty,
    this.price,
    this.rowTotal,
    this.name,
    this.product_type,
  });

  Map<String, dynamic> toCartItemJson() {
    return {
      'cartItem': {
        'sku': sku,
        'quoteId': cartId,
        'qty': qty,
      },
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'sku': sku,
      'qty': qty,
      'price': price,
      'name': name,
      'product_type': product_type,
    };
  }

  CartItemData.fromJson(Map<String, dynamic> map)
      : id = map['item_id'] as int,
        cartId = map['quote_id'] as String,
        sku = map['sku'] != null
            ? map['sku'] as String
            : map['extension_attributes'] != null
                ? map['extension_attributes']['sku'] as String
                : null,
        qty = map['qty'] as int,
        price = map['price'] is String
            ? double.parse(map['price'])
            : map['price'] as double,
        rowTotal = map['row_total'] as double,
        name = map['name'] as String,
        product_type = map['product_type'] as String;

  @override
  List<Object> get props => [id, cartId, name, sku];
}
