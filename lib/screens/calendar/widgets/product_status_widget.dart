import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/order_data.dart';
import 'package:my_lawn/data/subscription_data.dart';

class ProductStatusWidget extends StatefulWidget {
  const ProductStatusWidget({
    @required this.product,
    Key key,
  }) : super(key: key);

  final ActivityData product;

  @override
  _ProductStatusWidgetState createState() => _ProductStatusWidgetState();
}

class _ProductStatusWidgetState extends State<ProductStatusWidget> {
  SubscriptionShipment shipmentStatus;
  OrderData orderData;

  @override
  void initState() {
    super.initState();
    if (registry<SubscriptionBloc>().state.status !=
            SubscriptionStatus.active ||
        registry<SubscriptionBloc>().state.status !=
            SubscriptionStatus.loading) {
      final _user = registry<AuthenticationBloc>().state.user;
      registry<SubscriptionBloc>().add(FindSubscription(_user.customerId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      cubit: registry<SubscriptionBloc>(),
      listener: (context, state) {
        if (state.status == SubscriptionStatus.active) {
          final shipments = state.data.last.shipments
              .where((element) => element.products
                  .map((e) => widget.product.childProducts
                      .map((e) => e.sku)
                      .contains(e.sku))
                  .reduce((value, element) => value || element))
              .toList();
          if (shipments.isNotEmpty) {
            shipmentStatus = shipments.first;
          } else {
            shipmentStatus = null;
          }
        }
      },
      builder: (context, subscriptionState) =>
          BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
              cubit: registry<OrderDetailsBloc>(),
              listener: (context, state) {
                if (state is OrderDetailsSuccess) {
                  if (shipmentStatus != null) {
                    return orderData = state.orders.firstWhere(
                        (element) => element.orderId == shipmentStatus.orderId,
                        orElse: () => null);
                  }
                }
              },
              builder: (context, state) => Row(
                    children: [
                      if (_getImagePath(orderData) != null)
                        Image.asset(
                          _getImagePath(orderData),
                          width: 16,
                          height: 16,
                        ),
                      if (_getImagePath(orderData) != null)
                        const SizedBox(width: 6),
                      if (_getText(orderData) != null)
                        Text(
                          _getText(orderData),
                          key: Key('added_by_me'),
                          style: const TextStyle(
                            color: Styleguide.color_gray_9,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  )),
    );
  }

  String _getImagePath(OrderData orderData) {
    if (widget.product.applied) {
      return 'assets/icons/completed.png';
    } else if (widget.product.skipped) {
      return 'assets/icons/skipped.png';
    } else if (widget.product.activityType == ActivityType.userAddedProduct) {
      return 'assets/icons/added_by_me.png';
    } else if (orderData != null &&
        (orderData.isSkipped || orderData.isCanceled)) {
      return 'assets/icons/shipment_skipped.png';
    } else if (widget.product.applicationWindow.endDate != null &&
        widget.product.applicationWindow.endDate.isBefore(DateTime.now())) {
      return 'assets/icons/overdue.png';
    } else {
      return null;
    }
  }

  String _getText(OrderData orderData) {
    if (widget.product.applied) {
      return 'Applied';
    } else if (widget.product.skipped) {
      return 'Skipped';
    } else if (widget.product.activityType == ActivityType.userAddedProduct) {
      return 'Added by Me';
    } else if (orderData != null &&
        (orderData.isSkipped || orderData.isCanceled)) {
      return 'Shipment Skipped';
    } else if (widget.product.applicationWindow.endDate != null &&
        widget.product.applicationWindow.endDate.isBefore(DateTime.now())) {
      return 'Overdue';
    } else {
      return null;
    }
  }
}
