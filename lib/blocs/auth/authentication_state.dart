part of 'authentication_bloc.dart';

enum AuthStatus { loggingOut, loggedOut, guest, loggedIn, pendingVerification }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.authStatus = AuthStatus.loggedOut,
    this.user,
    this.lawnData,
  });

  final AuthStatus authStatus;
  final User user;
  final LawnData lawnData;

  const AuthenticationState.loggingOut(User user, LawnData lawnData)
      : this._(
            authStatus: AuthStatus.loggingOut, user: user, lawnData: lawnData);

  const AuthenticationState.loggedOut() : this._();

  const AuthenticationState.guest(User user, LawnData lawnData)
      : this._(authStatus: AuthStatus.guest, user: user, lawnData: lawnData);

  const AuthenticationState.loggedIn(User user, LawnData lawnData)
      : this._(authStatus: AuthStatus.loggedIn, user: user, lawnData: lawnData);

  const AuthenticationState.pendingVerification(User user, LawnData lawnData)
      : this._(
            authStatus: AuthStatus.pendingVerification,
            user: user,
            lawnData: lawnData);

  @override
  List<Object> get props => [authStatus, user, lawnData];
}

extension AuthenticationStateExtensions on AuthenticationState {
  bool get isGuest => authStatus == AuthStatus.guest;
  bool get isLoggingOut => authStatus == AuthStatus.loggingOut;
  bool get isLoggedOut => authStatus == AuthStatus.loggedOut;
  bool get isLogggedIn =>
      authStatus == AuthStatus.pendingVerification ||
      authStatus == AuthStatus.loggedIn;
}
