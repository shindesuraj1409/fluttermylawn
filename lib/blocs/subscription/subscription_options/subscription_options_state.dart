part of 'subscription_options_bloc.dart';

enum SubscriptionOptionsStatus {
  initial,
  fetchingRecommendation,
  fetchRecommendationSuccess,
  fetchRecommendationError,
  regeneratingRecommendation,
  regenerateRecommendationSuccess,
  regenerateRecommendationError,
}

class SubscriptionOptionsState extends Equatable {
  final Plan plan;
  final SubscriptionOptionsStatus status;
  final String errorMessage;

  SubscriptionOptionsState._({
    SubscriptionOptionsStatus status,
    Plan plan,
    String errorMessage,
  })  : status = status,
        plan = plan,
        errorMessage = errorMessage;

  SubscriptionOptionsState.initial()
      : this._(status: SubscriptionOptionsStatus.initial);

  SubscriptionOptionsState.fetchingRecommendation()
      : this._(status: SubscriptionOptionsStatus.fetchingRecommendation);

  SubscriptionOptionsState.fetchRecommendationSuccess(Plan plan)
      : this._(
          status: SubscriptionOptionsStatus.fetchRecommendationSuccess,
          plan: plan,
        );

  SubscriptionOptionsState.fetchRecommendationError(String errorMessage)
      : this._(
          status: SubscriptionOptionsStatus.fetchRecommendationError,
          errorMessage: errorMessage,
        );

  SubscriptionOptionsState.regeneratingRecommendation()
      : this._(status: SubscriptionOptionsStatus.regeneratingRecommendation);

  SubscriptionOptionsState.regenerateRecommendationSuccess(Plan plan)
      : this._(
          status: SubscriptionOptionsStatus.regenerateRecommendationSuccess,
          plan: plan,
        );

  SubscriptionOptionsState.regenerateRecommendationError(String errorMessage)
      : this._(
          status: SubscriptionOptionsStatus.regenerateRecommendationError,
          errorMessage: errorMessage,
        );

  @override
  List<Object> get props => [status, plan, errorMessage];
}
