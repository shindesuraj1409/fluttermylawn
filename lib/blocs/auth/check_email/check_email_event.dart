part of 'check_email_bloc.dart';

class CheckEmailEvent extends Equatable {
  final String email;
  CheckEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}
