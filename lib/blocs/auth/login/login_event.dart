part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SiteLoginEvent extends LoginEvent {
  final String email;
  final String password;

  SiteLoginEvent({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SiteSignupEvent extends LoginEvent {
  final String email;
  final String password;
  final bool subscribeToNewsLetter;

  SiteSignupEvent({
    @required this.email,
    @required this.password,
    @required this.subscribeToNewsLetter,
  });

  @override
  List<Object> get props => [email, password, subscribeToNewsLetter];
}

class SocialLoginEvent extends LoginEvent {
  final SocialService socialService;
  SocialLoginEvent({@required this.socialService});

  @override
  List<Object> get props => [socialService];
}

class LinkAccountEvent extends LoginEvent {
  final String email;
  final String password;

  LinkAccountEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class CompletePendingRegistrationEvent extends LoginEvent {
  final String regToken;
  final bool subscribe;

  CompletePendingRegistrationEvent({this.regToken, this.subscribe});

  @override
  List<Object> get props => [regToken, subscribe];
}

class RetrySiteSignupEvent extends LoginEvent {
  final String email;
  final String password;

  RetrySiteSignupEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
