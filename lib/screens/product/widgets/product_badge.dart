import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/widgets/badge_widget.dart';

class ProductBadge extends StatelessWidget {
  const ProductBadge({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    var subscriptionText;
    if (product.isSubscribed) subscriptionText = 'SUBSCRIBED';
    if (product.isAddedByMe) subscriptionText = 'ADDED BY ME';
    if (product.isSubscribed && product.isAddOn) {
      subscriptionText = 'SUBSCRIPTION ADD-ON';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (product.isSubscribed == true ||
            product.isAddedByMe == true ||
            (product.isSubscribed && product.isAddOn))
          Badge(
            text: subscriptionText,
            color: product.isAddedByMe && !product.isSubscribed
                ? Styleguide.color_gray_5
                : Styleguide.color_green_4,
            margin: EdgeInsets.only(right: 16),
            size: BadgeSize.Small,
          ),
      ],
    );
  }
}
