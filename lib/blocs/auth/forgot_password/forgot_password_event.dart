part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class ResetPasswordEmailRequested extends ForgotPasswordEvent {
  final String email;

  ResetPasswordEmailRequested(this.email);

  @override
  List<Object> get props => [email];
}
