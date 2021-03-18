import 'package:flutter/material.dart';

import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';
import 'package:my_lawn/screens/profile/subscription/shipment_card_widget.dart';

class SubscriptionItemsListViewWidget extends StatelessWidget {
  const SubscriptionItemsListViewWidget({
    Key key,
    @required this.skippingReasons,
    @required this.selectedSkippingReasons,
    this.state,
    this.formatDate,
    this.orderDetailsBloc,
    this.updateOrderDetails,
  }) : super(key: key);

  final List<SkippingReasons> skippingReasons;
  final List<SkippingReasons> selectedSkippingReasons;
  final SubscriptionState state;
  final Function formatDate;
  final OrderDetailsBloc orderDetailsBloc;
  final Function updateOrderDetails;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: Key('products_list_view'),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: state.data.last.shipments.length + 2,
      itemBuilder: (context, index) {
        return index == 0 || index == state.data.last.shipments.length + 1
            ? Container(width: index == 0 ? 24 : 12)
            : SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                height: 160,
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.fromLTRB(0, 2, 12, 2),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ShipmentCardWidget(
                      key: Key('subscription_card_el_'+index.toString()),
                      subscription: state.data.last,
                      shipment: state.data.last.shipments[index - 1],
                      skippingReasons: skippingReasons,
                      selectedSkippingReasons: selectedSkippingReasons,
                      formatDate: formatDate,
                      orderDetailsBloc: orderDetailsBloc,
                      index: index - 1,
                      updateOrderDetails: updateOrderDetails,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
