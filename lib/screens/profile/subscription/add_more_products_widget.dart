import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/screens/profile/subscription/add_product/add_product_screen.dart';
import 'package:my_lawn/services/analytic/actions/localytics/subscription_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';

class AddMoreProductsWidget extends StatelessWidget {
  const AddMoreProductsWidget({
    Key key,
    this.addons,
    this.subscriptionData,
    this.widgetHeight,
    this.addToCart,
  }) : super(key: key);
  final List<Product> addons;
  final SubscriptionData subscriptionData;
  final ValueNotifier<double> widgetHeight;
  final Function addToCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text('Add more products to your subscription?')),
          OutlineButton(
            key: Key('add_button'),
            visualDensity: VisualDensity.compact,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text('ADD'),
                  ),
                  Icon(Icons.add_circle),
                ],
              ),
            ),
            onPressed: () {
              registry<LocalyticsService>().tagEvent(AddOnEvent());
              showBottomSheetDialog(
                context: context,
                isFullScreen: true,
                hasDivider: false,
                color: Styleguide.color_green_4,
                title: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text(
                    'Select Add-on Products',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(height: 0, color: Styleguide.color_gray_0),
                  ),
                ),
                trailingPositioned: Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    child: Image.asset('assets/icons/cancel.png',
                        key: Key('cancel_icon'),
                        height: 24,
                        width: 24,
                        color: Styleguide.color_gray_0),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: AddProductScreen(
                    addons: addons,
                    subscriptionData: subscriptionData,
                    widgetHeight: widgetHeight,
                    addToCart: addToCart,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
