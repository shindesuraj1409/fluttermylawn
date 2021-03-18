import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/widgets/addons_carousel.dart';

class AddonsSection extends StatelessWidget {
  final List<CartItemData> addOnCartItems;
  final List<Product> addOnProducts;
  final SubscriptionType selectedSubscriptionType;
  final CartBloc cartBloc;

  AddonsSection({
    @required this.addOnCartItems,
    @required this.addOnProducts,
    @required this.selectedSubscriptionType,
    @required this.cartBloc,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartItemSkus =
        addOnCartItems.map((cartItem) => cartItem.sku).toList();
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'One Time Add-ons',
                  style: theme.textTheme.headline3,
                ),
                Text(
                  '${addOnProducts.length} items',
                  style: theme.textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              selectedSubscriptionType == SubscriptionType.annual
                  ? 'You will be charged today'
                  : 'You will be charged at the time of the first shipment',
              style: theme.textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ),
          AddonsCarousel(
            cartItemSkus: cartItemSkus,
            addOnProducts: addOnProducts,
            bloc: cartBloc,
          ),
        ],
      ),
    );
  }
}
