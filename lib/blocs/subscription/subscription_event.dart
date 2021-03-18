part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
}

class SubscriptionUpdated extends SubscriptionEvent {
  final List<SubscriptionData> data;

  const SubscriptionUpdated(this.data);

  @override
  List<Object> get props => [data];
}

class SubscriptionModificationPreview extends SubscriptionEvent {
  final String recommendationId;

  const SubscriptionModificationPreview(this.recommendationId);

  @override
  List<Object> get props => [recommendationId];
}

class FindSubscription extends SubscriptionEvent {
  final String customerId;

  const FindSubscription(this.customerId);

  @override
  List<Object> get props => [customerId];
}
