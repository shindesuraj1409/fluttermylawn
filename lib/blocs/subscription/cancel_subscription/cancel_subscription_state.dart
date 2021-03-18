part of 'cancel_subscription_bloc.dart';

abstract class CancelSubscriptionState extends Equatable {
  CancelSubscriptionState([List props = const <dynamic>[]]) : super();
  @override
  List<Object> get props => [];
}

class CancelSubscriptionStateInitial extends CancelSubscriptionState {
  @override
  String toString() => 'CancelSubscriptionStateInitial';
}

class CancelSubscriptionStateLoading extends CancelSubscriptionState {
  @override
  String toString() => 'CancelSubscriptionStateLoading';
}

class CancelSubscriptionStateSuccess extends CancelSubscriptionState {
  @override
  String toString() => 'CancelSubscriptionStateSuccess';
}

class PreviewSubscriptionStateSuccess extends CancelSubscriptionState {
  final RefundData refundData;
  PreviewSubscriptionStateSuccess(this.refundData);

  @override
  String toString() => 'PreviewSubscriptionStateSuccess';

  @override
  List<Object> get props => [refundData];
}

class CancelSubscriptionStateError extends CancelSubscriptionState {
  final String errorMessage;

  CancelSubscriptionStateError(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'CancelSubscriptionStateError $errorMessage';
}
