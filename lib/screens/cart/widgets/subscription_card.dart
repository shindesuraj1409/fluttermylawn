import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/models/subscription_cart_model.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final SubscriptionCartData _subscriptionCartData;
  final List<Widget> createProductImages;

  const SubscriptionCardWidget(
    this._subscriptionCartData,
    this.createProductImages, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 189,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
          padding: EdgeInsets.only(top: 15, bottom: 10, left: 16, right: 13),
          decoration: BoxDecoration(
            border: Border.all(color: Styleguide.color_green_4, width: 1),
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              SubscriptionPriceRow(subscriptionCartData: _subscriptionCartData),
              Row(
                children: [
                  Text(
                    _subscriptionCartData.subscriptionType ==
                            SubscriptionType.annual
                        ? 'You will be charged today'
                        : 'You will be charged [before each shipment]',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(height: 1.5),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: createProductImages,
                ),
              ),
            ],
          ),
        ),
        Positioned(
            left: 16,
            top: 12,
            child: Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              color: Colors.white,
              child: Text(
                _subscriptionCartData.subscriptionType ==
                        SubscriptionType.annual
                    ? 'Annual Subscription'
                    : 'Seasonal Subscription',
                style: Theme.of(context).textTheme.headline5,
              ),
            )),
      ],
    );
  }
}

class SubscriptionPriceRow extends StatelessWidget {
  const SubscriptionPriceRow({
    Key key,
    @required SubscriptionCartData subscriptionCartData,
  })  : _subscriptionCartData = subscriptionCartData,
        super(key: key);

  final SubscriptionCartData _subscriptionCartData;

  @override
  Widget build(BuildContext context) {
    final finalPriceStyle = Theme.of(context).textTheme.subtitle2.copyWith(
        color: Styleguide.color_green_4,
        fontWeight: FontWeight.w600,
        height: 1.43);

    if (_subscriptionCartData.subscriptionType == SubscriptionType.annual) {
      return Row(
        children: [
          Text(_subscriptionCartData.price,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  decoration: TextDecoration.lineThrough, height: 1.43)),
          SizedBox(width: 8),
          Text(_subscriptionCartData.discountedPrice, style: finalPriceStyle),
        ],
      );
    }
    return Row(
      children: [
        Text(_subscriptionCartData.price, style: finalPriceStyle),
        SizedBox(width: 8),
        Text('First shipment',
            style: Theme.of(context).textTheme.headline6.copyWith(
                color: Styleguide.color_gray_9,
                fontWeight: FontWeight.w600,
                height: 1.43)),
      ],
    );
  }
}
