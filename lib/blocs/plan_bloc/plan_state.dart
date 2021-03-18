import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object> get props => [];
}

class PlanInitialState extends PlanState {}

class PlanLoadingState extends PlanState {}

class PlanErrorState extends PlanState {
  final String errorMessage;
  final int errorCode;

  PlanErrorState({
    this.errorMessage,
    this.errorCode,
  });

  @override
  List<Object> get props => [errorMessage, errorCode];
}

class PlanSuccessState extends PlanState {
  final Plan plan;
  final SubscriptionData subscription;
  final List<String> recommendationImages;

  PlanSuccessState({this.recommendationImages, this.subscription, this.plan});

  PlanSuccessState copyWith({
    SubscriptionData subscription,
    Plan plan,
    List<String> recommendationImages,
  }) {
    return PlanSuccessState(
      plan: plan ?? this.plan,
      subscription: subscription ?? this.subscription,
      recommendationImages: recommendationImages ?? this.recommendationImages,
    );
  }

  @override
  List<Object> get props => [plan, subscription, recommendationImages];
}
