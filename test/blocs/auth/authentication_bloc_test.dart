import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class MockSessionManager extends Mock implements SessionManager {}

class MockAdobeRepository extends Mock implements AdobeRepository {}

void main() {
  group('AuthenticationBloc', () {
    AuthenticationBloc authenticationBloc;
    SessionManager sessionManager;
    AdobeRepository adobeRepository;

    setUp(() {
      sessionManager = MockSessionManager();
      adobeRepository = MockAdobeRepository();
      authenticationBloc = AuthenticationBloc(
          sessionManager: sessionManager, adobeRepository: adobeRepository);
    });

    test('initial state is AuthStatus.loggedOut', () {
      expect(authenticationBloc.state.authStatus, AuthStatus.loggedOut);
      authenticationBloc.close();
    });

    group('App started', () {
      final user = User();
      final guestUser = User(recommendationId: '123abc');
      final authedUser = User(email: 'test@email.com', isEmailVerified: true);
      final pendingUser = User(email: 'test@email.com', isEmailVerified: false);
      final lawnData =
          LawnData(grassType: 'Test', color: LawnGrassColor.greenAndBrown);

      setUp(() {
        when(sessionManager.getUser()).thenAnswer((_) async => user);
      });

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [loggedOut] if user is empty',
        build: () => authenticationBloc,
        act: (bloc) => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          AuthenticationState.loggedOut(),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [loggedIn] if user has email and isVerified',
        build: () {
          when(sessionManager.getUser()).thenAnswer((_) async => authedUser);
          when(sessionManager.getLawnData()).thenAnswer((_) async => lawnData);
          return AuthenticationBloc(
              sessionManager: sessionManager, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          AuthenticationState.loggedIn(authedUser, lawnData),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [pendingVerification] if user has email and isVerified false',
        build: () {
          when(sessionManager.getUser()).thenAnswer((_) async => pendingUser);
          when(sessionManager.getLawnData()).thenAnswer((_) async => lawnData);
          return AuthenticationBloc(
              sessionManager: sessionManager, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          AuthenticationState.pendingVerification(pendingUser, lawnData),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [guest] if user has recommendationId',
        build: () {
          when(sessionManager.getUser()).thenAnswer((_) async => guestUser);
          when(sessionManager.getLawnData()).thenAnswer((_) async => lawnData);
          return AuthenticationBloc(
              sessionManager: sessionManager, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          AuthenticationState.guest(guestUser, lawnData),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [loggedOut] if exception occurs',
        build: () {
          when(sessionManager.getUser()).thenThrow(Exception());
          return AuthenticationBloc(
              sessionManager: sessionManager, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(AppStarted()),
        expect: <AuthenticationState>[
          AuthenticationState.loggedOut(),
        ],
      );
    });

    group('Logout', () {
      final authedUser = User(email: 'test@email.com', isEmailVerified: true);
      final lawnData =
          LawnData(grassType: 'Test', color: LawnGrassColor.greenAndBrown);
      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [loggingOut] when user logs out',
        build: () {
          when(sessionManager.getUser()).thenAnswer((_) async => authedUser);
          when(sessionManager.getLawnData()).thenAnswer((_) async => lawnData);

          return authenticationBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: <AuthenticationState>[
          AuthenticationState.loggingOut(authedUser, lawnData),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits [loggedOut] when user logs out and calls sessionManager.clearAll',
        build: () => authenticationBloc,
        act: (bloc) => bloc.add(PerformLogout()),
        verify: (_) {
          verify(sessionManager.clearAll()).called(1);
        },
        expect: <AuthenticationState>[
          AuthenticationState.loggedOut(),
        ],
      );
    });
  });
}
