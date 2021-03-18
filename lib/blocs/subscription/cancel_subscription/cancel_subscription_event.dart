part of 'cancel_subscription_bloc.dart';

abstract class CancelEvent extends Equatable {
  const CancelEvent();
}

class CancelSubscriptionEvent extends CancelEvent {
  final String orderId;
  const CancelSubscriptionEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class PreviewSubscriptionRefundEvent extends CancelEvent {
  final String orderId;
  const PreviewSubscriptionRefundEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}
