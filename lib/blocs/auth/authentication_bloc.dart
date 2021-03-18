import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/profile_screen/action.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SessionManager _sessionManager;
  final AdobeRepository _adobeRepository;

  AuthenticationBloc(
      {SessionManager sessionManager, AdobeRepository adobeRepository})
      : _sessionManager = sessionManager ?? registry<SessionManager>(),
        _adobeRepository = adobeRepository ?? registry<AdobeRepository>(),
        super(const AuthenticationState.loggedOut());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    try {
      if (event is LogoutRequested) {
        final user = await _sessionManager.getUser();
        final lawnData = await _sessionManager.getLawnData();
        yield AuthenticationState.loggingOut(user, lawnData);
      } else if (event is PerformLogout) {
        await _sessionManager.clearAll();
        _adobeLogoutAnalytics();
        yield AuthenticationState.loggedOut();
      } else if (event is UpdateLawnNameRequested) {
        await _sessionManager.setLawnData(LawnData(lawnName: event.lawnName));
        final lawnData = await _sessionManager.getLawnData();
        yield _authStateFromUser(state.user, lawnData);
      } else {
        final user = await _sessionManager.getUser();
        final lawnData = await _sessionManager.getLawnData();
        yield _authStateFromUser(user, lawnData);
      }
    } on Exception catch (e) {
      await _sessionManager.clearAll();
      _adobeLogoutAnalytics();

      yield AuthenticationState.loggedOut();
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  AuthenticationState _authStateFromUser(User user, LawnData lawnData) {
    if (user.email != null) {
      if (user.isEmailVerified) {
        return AuthenticationState.loggedIn(user, lawnData);
      } else {
        return AuthenticationState.pendingVerification(user, lawnData);
      }
    } else if (user.recommendationId != null) {
      return AuthenticationState.guest(user, lawnData);
    } else {
      _adobeLogoutAnalytics();
      return AuthenticationState.loggedOut();
    }
  }

  void _adobeLogoutAnalytics() {
    _adobeRepository.trackAppActions(LogOutAdobeAction());
  }
}
