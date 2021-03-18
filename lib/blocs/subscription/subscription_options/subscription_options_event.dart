part of 'subscription_options_bloc.dart';

@immutable
abstract class SubscriptionOptionsEvent {
  const SubscriptionOptionsEvent();
}

class FetchRecommendationEvent extends SubscriptionOptionsEvent {
  final String recommendationId;
  FetchRecommendationEvent(this.recommendationId);
}

class RegenerateRecommendationEvent extends SubscriptionOptionsEvent{
  final String recommendationId;
  RegenerateRecommendationEvent(this.recommendationId);
}