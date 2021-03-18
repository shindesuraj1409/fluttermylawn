part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;
  final int errorCode;
  LoginErrorState({
    this.errorMessage,
    this.errorCode,
  });

  @override
  List<Object> get props => [errorMessage, errorCode];
}

class PendingRegistrationState extends LoginState {
  final String regToken;
  final String email;

  PendingRegistrationState({this.regToken, this.email});

  @override
  List<Object> get props => [regToken, email];
}

class LoginSuccessState extends LoginState {}

class LoginLinkAccountState extends LoginState {
  final String email;

  LoginLinkAccountState(this.email);

  @override
  List<Object> get props => [email];
}
