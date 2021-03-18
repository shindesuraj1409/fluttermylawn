part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;
  final int errorCode;

  ForgotPasswordError({
    this.errorMessage,
    this.errorCode,
  });

  @override
  List<Object> get props => [errorMessage, errorCode];
}
