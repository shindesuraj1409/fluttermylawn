import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PaymentVerificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class PaymentVerificationInitialState extends PaymentVerificationState {}

class PaymentVerificationLoadingState extends PaymentVerificationState {}

class PaymentVerificationFailure extends PaymentVerificationState {
  final String errorMessage;
  PaymentVerificationFailure({
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class PaymentVerificationVerifiedState extends PaymentVerificationState {
  final String recurly_token;
  PaymentVerificationVerifiedState({
    @required this.recurly_token,
  });

  @override
  List<Object> get props => [recurly_token];
}

class BillingAddressValidationFailure extends PaymentVerificationState {}
