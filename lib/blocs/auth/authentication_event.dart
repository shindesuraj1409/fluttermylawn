part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {}

class SignUpRequested extends AuthenticationEvent {}

class ContinueAsGuest extends AuthenticationEvent {}

class UserUpdated extends AuthenticationEvent {}

class LogoutRequested extends AuthenticationEvent {}

class PerformLogout extends AuthenticationEvent {}

class UpdateLawnNameRequested extends AuthenticationEvent {
  final String lawnName;

  UpdateLawnNameRequested(this.lawnName);

  @override
  List<Object> get props => [lawnName];
}
