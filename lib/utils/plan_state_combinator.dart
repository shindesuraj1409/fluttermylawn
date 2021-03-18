import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';

class PlanStateCombinator {
  final Recommendation recommendation;
  final SubscriptionData subscription;
  final List<ActivityData> activities;

  PlanStateCombinator({
    this.recommendation,
    this.subscription,
    this.activities,
  });
}
