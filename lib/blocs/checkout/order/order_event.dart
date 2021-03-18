import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';

class CreateOrderEvent extends Equatable {
  final String recommendationId;
  final String customerId;
  final String cartId;
  final CartType cartType;
  final List<String> addOnSkus;
  final SubscriptionType selectedSubscriptionType;
  final int subscriptionId;
  final String phone;
  final String recurlyToken;

  CreateOrderEvent(
    this.recommendationId,
    this.customerId,
    this.cartId,
    this.cartType,
    this.addOnSkus,
    this.selectedSubscriptionType,
    this.phone,
    this.recurlyToken,
    this.subscriptionId,
  );

  @override
  List<Object> get props => [
        recommendationId,
        customerId,
        cartId,
        cartType,
        addOnSkus,
        selectedSubscriptionType,
        phone,
        recurlyToken,
        subscriptionId,
      ];
}
