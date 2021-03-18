part of 'check_email_bloc.dart';

abstract class CheckEmailState extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckEmailInitialState extends CheckEmailState {}

class CheckEmailLoadingState extends CheckEmailState {}

class CheckEmailErrorState extends CheckEmailState {
  final String errorMessage;
  final int errorCode;
  CheckEmailErrorState({
    this.errorMessage,
    this.errorCode,
  });

  @override
  List<Object> get props => [errorMessage, errorCode];
}

class CheckEmailSuccessState extends CheckEmailState {
  final String email;
  final bool isEmailAvailable;
  CheckEmailSuccessState({
    @required this.email,
    @required this.isEmailAvailable,
  });

  @override
  List<Object> get props => [email, isEmailAvailable];
}
