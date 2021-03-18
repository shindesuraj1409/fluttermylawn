import 'package:equatable/equatable.dart';

import 'package:my_lawn/data/subscription_data.dart';

class OrderSummaryEvent extends Equatable {
  final String cartId;
  final SubscriptionType selectedSubscriptionType;
  final List<String> addOnSkus;

  OrderSummaryEvent(
    this.cartId,
    this.selectedSubscriptionType,
    this.addOnSkus,
  );

  @override
  List<Object> get props => [
        cartId,
        selectedSubscriptionType,
        addOnSkus,
      ];
}
