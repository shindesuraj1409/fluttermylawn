import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/screens/cart/cart_screen.dart';
import 'package:my_lawn/widgets/overlay_with_child_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class StickyBottom extends StatelessWidget {
  const StickyBottom(this.text, this.subscriptionType, this.customerId,
      this.plan, this.recommendationId,
      {Key key})
      : super(key: key);

  final Plan plan;
  final String customerId;
  final String recommendationId;
  final String text;
  final SubscriptionType subscriptionType;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 148,
      decoration: BoxDecoration(
        color: Styleguide.color_gray_0,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 52,
            margin: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: RaisedButton(
                child: Text(text.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return OverlayWithChild(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24, bottom: 10),
                                  child: Image.asset(
                                    'assets/icons/completed_outline.png',
                                    height: 64,
                                    width: 64,
                                  ),
                                ),
                                Text(
                                  text == 'Update Subscription'
                                      ? 'Subscription Updated!'
                                      : 'Recommendations Updated!',
                                  style: theme.textTheme.bodyText2.copyWith(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            delayedFunction: () {
                              if (subscriptionType.isAnnual) {
                                unawaited(registry<Navigation>().push(
                                  '/cart',
                                  arguments: CartScreenArguments(
                                    recommendationId: recommendationId,
                                    plan: plan,
                                    selectedSubscriptionType: subscriptionType,
                                    customerId: customerId,
                                  ),
                                ));
                              }
                            });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 52,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: FlatButton(
              onPressed: () => registry<Navigation>().popTo('/profile'),
              child: Text('CANCEL'),
            ),
          ),
        ],
      ),
    );
  }
}
