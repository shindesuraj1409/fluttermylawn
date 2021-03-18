import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';

abstract class PlanEvent {
  const PlanEvent();
}

class PlanFetched extends PlanEvent {
  final Recommendation recommendation;
  final List<SubscriptionData> subscription;
  final List<ActivityData> activities;
  PlanFetched({this.activities, this.subscription, this.recommendation});

  PlanFetched copyWith(
      {Recommendation recommendation,
      List<SubscriptionData> subscription,
      List<ActivityData> activities}) {
    return PlanFetched(
      recommendation: recommendation ?? this.recommendation,
      subscription: subscription ?? this.subscription,
      activities: activities ?? this.activities,
    );
  }
}

class PlanChanged extends PlanEvent {
  final Recommendation recommendation;
  final SubscriptionData subscription;
  final List<ActivityData> activities;
  PlanChanged({this.activities, this.recommendation, this.subscription});
}

class PlanRetryButtonPressed extends PlanEvent {
  PlanRetryButtonPressed();
}

class PlanUpdate extends PlanEvent {
  PlanUpdate();
}
