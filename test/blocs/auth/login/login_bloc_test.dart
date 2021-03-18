import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_responses.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/auth/i_legacy_user_service.dart';
import 'package:my_lawn/services/auth/social/i_social_provider.dart';
import 'package:my_lawn/services/auth/social/i_social_provider_factory.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:test/test.dart';

class MockGigyaService extends Mock implements GigyaService {}

class MockRecommendationService extends Mock implements RecommendationService {}

class MockCustomerService extends Mock implements CustomerService {}

class MockSessionManager extends Mock implements SessionManager {}

class MockLocalyticsService extends Mock implements LocalyticsService {}

class MockLegacyUserService extends Mock implements LegacyUserService {}

class MockGeoService extends Mock implements GeoService {}

class MockSocialProviderFactory extends Mock implements SocialProviderFactory {}

class MockSocialProvider extends Mock implements SocialProvider {}

class MockFindSubscriptionsByCustomerIdService extends Mock
    implements FindSubscriptionsByCustomerIdService {}

class MockAdobeUserProfileRepository extends Mock
    implements AdobeUserProfileRepository {}

void main() {
  group('LoginBloc', () {
    GigyaService gigyaService;
    CustomerService customerService;
    SessionManager sessionManager;
    LocalyticsService localyticsService;
    LoginBloc loginBloc;
    RecommendationService recommendationService;
    AdobeUserProfileRepository adobeUserProfileRepository;
    LegacyUserService legacyUserService;
    SocialProviderFactory socialProviderFactory;
    SocialProvider socialProvider;
    FindSubscriptionsByCustomerIdService findSubscriptionsByCustomerIdService;
    GeoService geoService;

    setUp(() {
      gigyaService = MockGigyaService();
      customerService = MockCustomerService();
      sessionManager = MockSessionManager();
      localyticsService = MockLocalyticsService();
      adobeUserProfileRepository = MockAdobeUserProfileRepository();
      recommendationService = MockRecommendationService();
      legacyUserService = MockLegacyUserService();
      socialProviderFactory = MockSocialProviderFactory();
      socialProvider = MockSocialProvider();
      findSubscriptionsByCustomerIdService =
          MockFindSubscriptionsByCustomerIdService();
      geoService = MockGeoService();

      loginBloc = LoginBloc(
        gigyaService: gigyaService,
        customerService: customerService,
        sessionManager: sessionManager,
        localyticsService: localyticsService,
        adobeUserProfileRepository: adobeUserProfileRepository,
        recommendationService: recommendationService,
        legacyUserService: legacyUserService,
        socialProviderFactory: socialProviderFactory,
        findSubscriptionsByCustomerIdService:
            findSubscriptionsByCustomerIdService,
        geoService: geoService,
      );
    });

    test('initial state is CheckEmailInitialState', () {
      expect(loginBloc.state, LoginInitialState());
      loginBloc.close();
    });

    group('email login', () {
      const email = 'test@scotts.com';
      const password = 'password';
      const gigyaUserId = '123';
      const token = '456';
      const scottsCustomerId = 'scotts123';

      setUp(() {
        when(gigyaService.siteLogin(email, password)).thenAnswer(
          (_) async => GigyaAccountResponse(
            UID: gigyaUserId,
            idToken: token,
            email: email,
          ),
        );
        when(customerService.login(email)).thenAnswer(
          (_) async => CustomerServiceResponse(
            id: scottsCustomerId,
            email: email,
          ),
        );
      });

      blocTest<LoginBloc, LoginState>(
        'invokes GigyaService siteLogin, CustomerService register',
        build: () => loginBloc,
        act: (bloc) =>
            bloc.add(SiteLoginEvent(email: email, password: password)),
        verify: (_) {
          verify(gigyaService.siteLogin(email, password)).called(1);
          verify(customerService.login(email)).called(1);
          verify(localyticsService.updateUserProfile()).called(1);
          verify(adobeUserProfileRepository.updateUserCustomerId(email))
              .called(1);
          verify(adobeUserProfileRepository
                  .updateUserLocalyticsId(scottsCustomerId))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginSuccessState()] when site login succeeds',
        build: () => loginBloc,
        act: (bloc) =>
            bloc.add(SiteLoginEvent(email: email, password: password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginSuccessState(),
        ],
        verify: (bloc) {
          verify(localyticsService.updateUserProfile()).called(1);
          verify(adobeUserProfileRepository.updateUserCustomerId(email))
              .called(1);
          verify(adobeUserProfileRepository
                  .updateUserLocalyticsId(scottsCustomerId))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when site login fails with gigyaErrorException',
        build: () {
          when(gigyaService.siteLogin(email, password))
              .thenThrow(GigyaErrorException(401030));
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SiteLoginEvent(email: email, password: password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorCode: 401030, errorMessage: 'Incorrect password'),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when site login fails with exception',
        build: () {
          when(gigyaService.siteLogin(email, password)).thenThrow(Exception());
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SiteLoginEvent(email: email, password: password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorMessage: 'Error occurred when logging in. Please try again'),
        ],
      );
    });

    group('social login', () {
      const session = {
        'google': {'authToken': 'my_token'}
      };
      const UID = '123';
      const idToken = '456';
      const email = 'test@scotts.com';
      const regToken = 'abc123';
      const scottsId = 'scotts123';
      final user =
          User(customerId: scottsId, email: email, isEmailVerified: true);

      setUp(() {
        when(socialProviderFactory.createInstance(SocialService.GOOGLE))
            .thenReturn(socialProvider);
        when(socialProvider.signIn()).thenAnswer((_) async => session);
        when(socialProvider.email).thenReturn(email);
        when(gigyaService.socialLogin(email, session)).thenAnswer((_) async =>
            GigyaAccountResponse(
                UID: UID, idToken: idToken, email: email, newUser: false));
        when(customerService.login(email)).thenAnswer(
          (_) async => CustomerServiceResponse(
              id: scottsId, email: email, isEmailVerified: true),
        );
        when(sessionManager.setUser(user)).thenAnswer((_) {});
        when(sessionManager.getGigyaToken()).thenAnswer((_) async => idToken);
      });

      blocTest<LoginBloc, LoginState>(
        'invokes socialProvider signIn, GigyaService socialLogin, CustomerService login, SessionManager setUser',
        build: () => loginBloc,
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        verify: (_) {
          verify(socialProvider.signIn()).called(1);
          verify(gigyaService.socialLogin(email, session)).called(1);
          verify(customerService.login(email)).called(1);
          verify(sessionManager.setUser(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'invokes socialProvider signIn, GigyaService socialLogin, CustomerService register when newUser is true',
        build: () {
          when(gigyaService.socialLogin(email, session)).thenAnswer((_) async =>
              GigyaAccountResponse(
                  UID: UID, idToken: idToken, email: email, newUser: true));
          return LoginBloc(
            adobeUserProfileRepository: adobeUserProfileRepository,
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        verify: (_) {
          verify(socialProvider.signIn()).called(1);
          verify(gigyaService.socialLogin(email, session)).called(1);
          verify(customerService.register(email, UID, idToken)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState(), LoginSuccessState()] when social site login succeeds',
        build: () => loginBloc,
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginSuccessState(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState(), PendingRegistrationState()] when socialLogin fails with pendingRegistrationException',
        build: () {
          when(gigyaService.socialLogin(email, session)).thenThrow(
              PendingRegistrationException(
                  'Partial Content', regToken, email, 206001));
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        expect: <LoginState>[
          LoginLoadingState(),
          PendingRegistrationState(email: email, regToken: regToken),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState(), LoginErrorState()] when socialLogin fails with gigyaErrorException',
        build: () {
          when(gigyaService.socialLogin(email, session))
              .thenThrow(GigyaErrorException(403042));
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorCode: 403042,
              errorMessage: 'Please verify your credentials and try again.'),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState(), LoginErrorState()] when social login fails with exception',
        build: () {
          when(gigyaService.socialLogin(email, session)).thenThrow(Exception());
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) =>
            bloc.add(SocialLoginEvent(socialService: SocialService.GOOGLE)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorMessage: 'Error occurred when logging in. Please try again'),
        ],
      );
    });

    group('email signup', () {
      const email = 'test@scotts.com';
      const password = 'password';
      const gigyaUserId = '123';
      const scottsCustomerId = 'scotts123';
      const token = '456';

      setUp(() {
        when(gigyaService.siteRegister(email, password, false)).thenAnswer(
            (_) async =>
                GigyaAccountResponse(UID: gigyaUserId, idToken: token));
        when(customerService.register(email, gigyaUserId, token)).thenAnswer(
          (_) async => CustomerServiceResponse(
            id: scottsCustomerId,
            email: email,
          ),
        );
      });

      blocTest<LoginBloc, LoginState>(
        'invokes GigyaService siteRegister, CustomerService register',
        build: () => LoginBloc(
          gigyaService: gigyaService,
          customerService: customerService,
          sessionManager: sessionManager,
          localyticsService: localyticsService,
          adobeUserProfileRepository: adobeUserProfileRepository,
          recommendationService: recommendationService,
          legacyUserService: legacyUserService,
          socialProviderFactory: socialProviderFactory,
          findSubscriptionsByCustomerIdService:
              findSubscriptionsByCustomerIdService,
          geoService: geoService,
        ),
        act: (bloc) => bloc.add(SiteSignupEvent(
            email: email, password: password, subscribeToNewsLetter: false)),
        verify: (_) {
          verify(gigyaService.siteRegister(email, password, false)).called(1);
          verify(customerService.register(email, gigyaUserId, token)).called(1);
          verify(localyticsService.updateUserProfile()).called(1);
          verify(adobeUserProfileRepository.updateUserCustomerId(email))
              .called(1);
          verify(adobeUserProfileRepository
                  .updateUserLocalyticsId(scottsCustomerId))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginSuccessState()] when site signup succeeds',
        build: () => LoginBloc(
          gigyaService: gigyaService,
          customerService: customerService,
          sessionManager: sessionManager,
          localyticsService: localyticsService,
          adobeUserProfileRepository: adobeUserProfileRepository,
          recommendationService: recommendationService,
          legacyUserService: legacyUserService,
          socialProviderFactory: socialProviderFactory,
          findSubscriptionsByCustomerIdService:
              findSubscriptionsByCustomerIdService,
          geoService: geoService,
        ),
        act: (bloc) => bloc.add(SiteSignupEvent(
            email: email, password: password, subscribeToNewsLetter: false)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginSuccessState(),
        ],
        verify: (bloc) {
          verify(localyticsService.updateUserProfile()).called(1);
          verify(adobeUserProfileRepository.updateUserCustomerId(email))
              .called(1);
          verify(adobeUserProfileRepository
                  .updateUserLocalyticsId(scottsCustomerId))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when site sign up fails with gigyaErrorException',
        build: () {
          when(gigyaService.siteRegister(email, password, false))
              .thenThrow(GigyaErrorException(401030));
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) => bloc.add(SiteSignupEvent(
            email: email, password: password, subscribeToNewsLetter: false)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorCode: 401030, errorMessage: 'Incorrect password'),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when site sign up fails with exception',
        build: () {
          when(gigyaService.siteRegister(email, password, false))
              .thenThrow(Exception());
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) => bloc.add(SiteSignupEvent(
            email: email, password: password, subscribeToNewsLetter: false)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorMessage: 'Error occurred when signing up. Please try again')
        ],
      );
    });

    group('link account', () {
      const email = 'test@scotts.com';
      const password = 'password';
      const scottsCustomerId = 'scotts123';

      setUp(() {
        when(gigyaService.linkAccounts(email, password)).thenAnswer(
          (_) async => GigyaAccountResponse(email: email),
        );
        when(customerService.login(email)).thenAnswer(
          (_) async => CustomerServiceResponse(
            id: scottsCustomerId,
            email: email,
          ),
        );
      });

      blocTest<LoginBloc, LoginState>(
        'invokes GigyaService linkAccounts, CustomerService login, SessionManger setUser',
        build: () => loginBloc,
        act: (bloc) => bloc.add(LinkAccountEvent(email, password)),
        verify: (_) {
          verify(gigyaService.linkAccounts(email, password)).called(1);
          verify(customerService.login(email)).called(1);
          verify(sessionManager.setUser(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginSuccessState()] when link account succeeds',
        build: () => loginBloc,
        act: (bloc) => bloc.add(LinkAccountEvent(email, password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginSuccessState(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when exception occurs',
        build: () {
          when(gigyaService.linkAccounts(email, password))
              .thenThrow(Exception());
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) => bloc.add(LinkAccountEvent(email, password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
            errorMessage: 'Error occurred when logging in. Please try again',
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoadingState, LoginErrorState()] when Gigya exception occurs',
        build: () {
          when(gigyaService.linkAccounts(email, password))
              .thenThrow(GigyaErrorException(401030));
          return LoginBloc(
            gigyaService: gigyaService,
            customerService: customerService,
            sessionManager: sessionManager,
            localyticsService: localyticsService,
            adobeUserProfileRepository: adobeUserProfileRepository,
            recommendationService: recommendationService,
            legacyUserService: legacyUserService,
            socialProviderFactory: socialProviderFactory,
            findSubscriptionsByCustomerIdService:
                findSubscriptionsByCustomerIdService,
            geoService: geoService,
          );
        },
        act: (bloc) => bloc.add(LinkAccountEvent(email, password)),
        expect: <LoginState>[
          LoginLoadingState(),
          LoginErrorState(
              errorCode: 401030, errorMessage: 'Incorrect password'),
        ],
      );
    });

    group('retry registering user', () {
      const email = 'test@scotts.com';
      const password = 'password';
      const scottsCustomerId = 'scotts123';

      setUp(() {
        when(gigyaService.siteLogin(email, password)).thenAnswer(
          (_) async => GigyaAccountResponse(email: email),
        );
        when(customerService.register(email, any, any)).thenAnswer(
          (_) async => CustomerServiceResponse(
            id: scottsCustomerId,
            email: email,
          ),
        );
      });

      blocTest<LoginBloc, LoginState>(
        'invokes GigyaService login, CustomerService register, SessionManger setUser',
        build: () => loginBloc,
        act: (bloc) => bloc.add(RetrySiteSignupEvent(email, password)),
        verify: (_) {
          verify(gigyaService.siteLogin(email, password)).called(1);
          verify(customerService.register(email, any, any)).called(1);
          verify(sessionManager.setUser(any)).called(1);
        },
      );
    });
  });
}
