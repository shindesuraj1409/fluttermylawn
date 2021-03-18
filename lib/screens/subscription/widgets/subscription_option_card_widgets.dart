import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/screens/subscription/widgets/seasonal_shipment_list_widget.dart';
import 'package:my_lawn/widgets/bullet_list_widget.dart';

typedef onSubscriptionOptionSelected = void Function(
    SubscriptionType optionSelected);

class AnnualSubscriptionCard extends StatelessWidget {
  final double annualPlanPrice;
  final double annualPlanDiscountedPrice;
  final SubscriptionType selectedSubscriptionOption;
  final onSubscriptionOptionSelected onSelected;

  final _bulletPoints = [
    'Full amount charged now',
    'Products are delivered when it is time to apply',
    'Subscription automatically renews for each shipment and then starts again the following year until canceled. Cancel anytime.',
    'Free shipping',
  ];

  AnnualSubscriptionCard({
    this.annualPlanPrice,
    this.annualPlanDiscountedPrice,
    this.selectedSubscriptionOption,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SubscriptionOptionRadioButtonCard(
      subscriptionType: SubscriptionType.annual,
      onSelected: onSelected,
      selectedSubscriptionType: selectedSubscriptionOption,
      subscriptionTitle: 'Annual Subscription',
      badge: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          'BEST VALUE',
          style: theme.textTheme.caption.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Save 10% off MSRP',
            style: theme.textTheme.subtitle2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: '\$${annualPlanPrice.toStringAsFixed(2)}',
              style: theme.textTheme.subtitle2.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '   \$${annualPlanDiscountedPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.subtitle2.copyWith(
                    color: Styleguide.color_green_4,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 16, 16),
          child: BulletList(
            _bulletPoints,
            bulletMargin: EdgeInsets.fromLTRB(0, 8, 20, 0),
            style: theme.textTheme.bodyText2.copyWith(height: 1.66),
          ),
        ),
      ],
    );
  }
}

class SeasonalSubscriptionCard extends StatelessWidget {
  final List<Product> products;
  final SubscriptionType selectedSubscriptionOption;
  final onSubscriptionOptionSelected onSelected;

  final _bulletPoints = [
    'Make multiple payments throughout the year',
    'Products are delivered when it is time to apply',
    'Subscription automatically renews for each shipment and then starts again the following year until canceled. Cancel anytime.',
    'Free shipping',
  ];

  SeasonalSubscriptionCard({
    this.products,
    this.selectedSubscriptionOption,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SubscriptionOptionRadioButtonCard(
      subscriptionType: SubscriptionType.seasonal,
      onSelected: onSelected,
      selectedSubscriptionType: selectedSubscriptionOption,
      subscriptionTitle: 'Seasonal Subscription',
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 4),
          child: Text(
            'Pay Per Shipment',
            style: theme.textTheme.subtitle2,
          ),
        ),
        SeasonalShipmentList(products),
        Container(
          margin: EdgeInsets.fromLTRB(0, 4, 16, 16),
          child: BulletList(
            _bulletPoints,
            bulletMargin: EdgeInsets.fromLTRB(0, 8, 20, 0),
            style: theme.textTheme.bodyText2.copyWith(height: 1.66),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionOptionRadioButtonCard extends StatelessWidget {
  final SubscriptionType subscriptionType;
  final SubscriptionType selectedSubscriptionType;
  final String subscriptionTitle;

  final Widget badge;
  final List<Widget> children;

  final onSubscriptionOptionSelected onSelected;

  _SubscriptionOptionRadioButtonCard({
    this.subscriptionType,
    this.selectedSubscriptionType,
    this.subscriptionTitle,
    this.badge,
    this.children,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _radioDecoration = BoxDecoration(
      color: theme.colorScheme.background,
      border: subscriptionType == selectedSubscriptionType
          ? Border.all(
              color: Styleguide.color_green_4,
              width: 2,
            )
          : Border.all(
              color: Colors.transparent,
              width: 2,
            ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: subscriptionType == selectedSubscriptionType
          ? const [
              BoxShadow(
                color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
                blurRadius: 5.0,
                spreadRadius: -3.0,
                offset: Offset(
                  0.0,
                  5.0,
                ),
              ),
              BoxShadow(
                color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
                blurRadius: 14.0,
                spreadRadius: 2.0,
                offset: Offset(
                  0.0,
                  3.0,
                ),
              ),
              BoxShadow(
                color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(
                  0.0,
                  8.0,
                ),
              ),
            ]
          : const [
              BoxShadow(
                color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                offset: Offset(
                  0.0,
                  1.0,
                ),
              ),
              BoxShadow(
                color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
                blurRadius: 1.0,
                spreadRadius: -1.0,
                offset: Offset(
                  0.0,
                  2.0,
                ),
              ),
              BoxShadow(
                color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: Offset(
                  0.0,
                  1.0,
                ),
              ),
            ],
    );

    return GestureDetector(
      onTap: () => onSelected(subscriptionType),
      child: Container(
        decoration: _radioDecoration,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio(
              value: subscriptionType,
              groupValue: selectedSubscriptionType,
              onChanged: onSelected,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          subscriptionTitle,
                          style: theme.textTheme.headline5,
                        ),
                        badge ?? SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
