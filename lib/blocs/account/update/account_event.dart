part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountUpdateEvent extends AccountEvent {
  final String email;
  final String firstName;
  final String lastName;
  final bool isNewsletterSubscribed;

  AccountUpdateEvent(
    this.email,
    this.firstName,
    this.lastName,
    this.isNewsletterSubscribed,
  );

  @override
  List<Object> get props =>
      [email, firstName, lastName, isNewsletterSubscribed];
}

class AccountSubscribeNewsLetterEvent extends AccountEvent {
  AccountSubscribeNewsLetterEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends AccountEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent(
    this.oldPassword,
    this.newPassword,
  );

  @override
  List<Object> get props => [
        oldPassword,
        newPassword,
      ];
}
