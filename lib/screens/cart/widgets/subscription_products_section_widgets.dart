import 'package:flutter/material.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/widgets/product_image.dart';

class SubscriptionProductBundle extends StatelessWidget {
  final Plan plan;
  final SubscriptionType selectedSubscriptionType;

  SubscriptionProductBundle({
    @required this.plan,
    @required this.selectedSubscriptionType,
    Key key,
  }) : super(key: key);

  List<Widget> _buildProductImages() {
    final productImages = <Widget>[];
    final products = plan.products;

    for (var i = 0; i < products.length; i++) {
      final opacity =
          selectedSubscriptionType == SubscriptionType.seasonal && i != 0;
      productImages.add(
        Flexible(
          flex: 1,
          child: Padding(
            padding: i == 0
                ? const EdgeInsets.only(left: 0)
                : const EdgeInsets.only(left: 8),
            child: Opacity(
              opacity: opacity ? 0.3 : 1.0,
              child: ProductImage(
                productImageUrl: products[i].childProducts.first.imageUrl,
                width: 72,
                height: 104,
              ),
            ),
          ),
          key: Key('subscription_bundle_product_image_$i'),
        ),
      );
    }

    return productImages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubscriptionPrice(
                annualPlanPrice: plan.prices.annualPrice,
                annualPlanDiscountedPrice: plan.prices.annualDiscountedPrice,
                seasonalPlanPrice: plan.prices.seasonalPrice,
                selectedSubscriptionType: selectedSubscriptionType,
              ),
              Text(
                selectedSubscriptionType == SubscriptionType.annual
                    ? 'You will be charged today'
                    : 'You will be charged [before each shipment]',
                style: theme.textTheme.bodyText2.copyWith(height: 1.5),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _buildProductImages(),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          top: 12,
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            color: theme.colorScheme.background,
            child: Text(
              selectedSubscriptionType == SubscriptionType.annual
                  ? 'Annual Subscription'
                  : 'Seasonal Subscription',
              style: theme.textTheme.headline5,
              key: Key('subscription_type_label'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionPrice extends StatelessWidget {
  final double annualPlanPrice;
  final double annualPlanDiscountedPrice;
  final double seasonalPlanPrice;
  final SubscriptionType selectedSubscriptionType;

  _SubscriptionPrice({
    @required this.annualPlanPrice,
    @required this.annualPlanDiscountedPrice,
    @required this.seasonalPlanPrice,
    @required this.selectedSubscriptionType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalPriceTextStyle = theme.textTheme.subtitle2.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w600,
      height: 1.43,
    );

    if (selectedSubscriptionType == SubscriptionType.annual) {
      return Row(
        children: [
          Text(
            '\$${annualPlanPrice.toStringAsFixed(2)}',
            style: theme.textTheme.subtitle2.copyWith(
              decoration: TextDecoration.lineThrough,
              height: 1.43,
            ),
            key: Key('subscription_products_price'),
          ),
          SizedBox(width: 8),
          Text(
            annualPlanDiscountedPrice.toStringAsFixed(2),
            style: finalPriceTextStyle,
            key: Key('subscription_products_discounted_price'),
          ),
        ],
      );
    }

    return Row(
      children: [
        Text(seasonalPlanPrice.toStringAsFixed(2), style: finalPriceTextStyle),
        SizedBox(width: 8),
        Text(
          'First shipment',
          style: theme.textTheme.subtitle2.copyWith(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}
