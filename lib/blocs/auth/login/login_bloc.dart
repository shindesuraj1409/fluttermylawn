import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_responses.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/auth/i_legacy_user_service.dart';
import 'package:my_lawn/services/auth/social/i_social_provider_factory.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:pedantic/pedantic.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GigyaService _gigyaService;
  final CustomerService _customerService;
  final RecommendationService _recommendationService;
  final FindSubscriptionsByCustomerIdService
      _findSubscriptionsByCustomerIdService;
  final GeoService _geoService;
  final SessionManager _sessionManager;
  final LocalyticsService _localyticsService;
  final AdobeUserProfileRepository _adobeUserProfileRepository;
  final LegacyUserService _legacyUserService;
  final SocialProviderFactory _socialProviderFactory;

  LoginBloc({
    GigyaService gigyaService,
    CustomerService customerService,
    SessionManager sessionManager,
    FindSubscriptionsByCustomerIdService findSubscriptionsByCustomerIdService,
    LocalyticsService localyticsService,
    AdobeUserProfileRepository adobeUserProfileRepository,
    RecommendationService recommendationService,
    LegacyUserService legacyUserService,
    GeoService geoService,
    SocialProviderFactory socialProviderFactory,
  })  : _gigyaService = gigyaService ?? registry<GigyaService>(),
        _customerService = customerService ?? registry<CustomerService>(),
        _sessionManager = sessionManager ?? registry<SessionManager>(),
        _localyticsService = localyticsService ?? registry<LocalyticsService>(),
        _adobeUserProfileRepository = adobeUserProfileRepository ??
            registry<AdobeUserProfileRepository>(),
        _recommendationService =
            recommendationService ?? registry<RecommendationService>(),
        _findSubscriptionsByCustomerIdService =
            findSubscriptionsByCustomerIdService ??
                registry<FindSubscriptionsByCustomerIdService>(),
        _legacyUserService = legacyUserService ?? registry<LegacyUserService>(),
        _geoService = geoService ?? registry<GeoService>(),
        _socialProviderFactory =
            socialProviderFactory ?? registry<SocialProviderFactory>(),
        super(LoginInitialState());

  // Actions
  void siteLogin(String email, String password) {
    add(SiteLoginEvent(
      email: email,
      password: password,
    ));
  }

  void siteRegister(String email, String password, bool subscribe) {
    add(SiteSignupEvent(
      email: email,
      password: password,
      subscribeToNewsLetter: subscribe,
    ));
  }

  void socialLogin(SocialService socialService) {
    add(SocialLoginEvent(socialService: socialService));
  }

  void completePendingRegistration(String regToken, bool subscribe) {
    add(CompletePendingRegistrationEvent(
        regToken: regToken, subscribe: subscribe));
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SiteLoginEvent) {
      try {
        yield LoginLoadingState();

        final accountResponse = await _gigyaService.siteLogin(
          event.email.toLowerCase(),
          event.password,
        );

        final customerServiceResponse =
            await _customerService.login(accountResponse.email);

        if (customerServiceResponse.status == 404) {
          // Retry when a user is registered with Gigya but not Scotts
          add(RetrySiteSignupEvent(event.email, event.password));
        }

        await _sessionManager.setUser(
          User(
            customerId: customerServiceResponse.id,
            email: customerServiceResponse.email,
            isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
            firstName: customerServiceResponse.firstName,
            lastName: customerServiceResponse.lastName,
          ),
        );
        await _fetchCustomerRecommendations();
        await _localyticsService.updateUserProfile();

        _adobeUserProfileRepository
            .updateUserCustomerId(customerServiceResponse.email);

        _adobeUserProfileRepository
            .updateUserLocalyticsId(customerServiceResponse.id);

        unawaited(_legacyUserService.saveLegacyUserId());

        yield LoginSuccessState();
      } on GigyaErrorException catch (e) {
        yield LoginErrorState(
          errorCode: e.errorCode,
          errorMessage: e.message,
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } on FindSubscriptionByCustomerIdException catch (e) {
        yield LoginErrorState(
          errorMessage: e.errorMessage,
        );
      } on Exception catch (e) {
        yield LoginErrorState(
          errorMessage: 'Error occurred when logging in. Please try again',
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
    if (event is SiteSignupEvent) {
      try {
        yield LoginLoadingState();

        final lowerCaseEmail = event.email.toLowerCase();

        final accountResponse = await _gigyaService.siteRegister(
          lowerCaseEmail,
          event.password,
          event.subscribeToNewsLetter,
        );

        final customerServiceResponse =
            await _createNewUser(lowerCaseEmail, accountResponse);

        await _sessionManager.setUser(
          User(
            customerId: customerServiceResponse.id,
            email: customerServiceResponse.email,
            isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
          ),
        );

        await _localyticsService.updateUserProfile();

        _adobeUserProfileRepository
            .updateUserCustomerId(customerServiceResponse.email);

        _adobeUserProfileRepository
            .updateUserLocalyticsId(customerServiceResponse.id);

        unawaited(_legacyUserService.saveLegacyUserId());

        yield LoginSuccessState();
      } on GigyaErrorException catch (e) {
        yield LoginErrorState(
          errorCode: e.errorCode,
          errorMessage: e.message,
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield LoginErrorState(
          errorMessage: 'Error occurred when signing up. Please try again',
        );
        await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
    if (event is SocialLoginEvent) {
      yield LoginLoadingState();
      try {
        final socialProvider =
            _socialProviderFactory.createInstance(event.socialService);

        final session = await socialProvider.signIn();
        final email = socialProvider.email;

        if (session == null) {
          // The user canceled the social login flow, reset to initial state
          yield LoginInitialState();
          return;
        }

        final accountResponse = await _gigyaService.socialLogin(email, session);
        final customerServiceResponse = await _customerService.login(email);

        // Register a new user when a user is registered with Gigya but not Scotts, or is brand new
        if (accountResponse.newUser || customerServiceResponse.status == 404) {
          await _createNewUser(email, accountResponse);
        } else {
          await _sessionManager.setUser(
            User(
              customerId: customerServiceResponse.id,
              email: customerServiceResponse.email,
              isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
            ),
          );
          await _fetchCustomerRecommendations();
        }

        unawaited(_legacyUserService.saveLegacyUserId());
        yield LoginSuccessState();
      } on GigyaErrorException catch (e) {
        if (e is PendingRegistrationException) {
          yield PendingRegistrationState(
            regToken: e.regToken,
            email: e.email,
          );
        } else if (e is LinkAccountsException) {
          yield LoginLinkAccountState(e.email);
        } else {
          yield LoginErrorState(
            errorCode: e.errorCode,
            errorMessage: e.message,
          );
        }
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield LoginErrorState(
            errorMessage: 'Error occurred when logging in. Please try again');
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
    if (event is CompletePendingRegistrationEvent) {
      try {
        yield LoginLoadingState();

        final accountResponse = await _gigyaService.completePendingRegistration(
          event.regToken,
          event.subscribe,
        );

        final user = await _sessionManager.getUser();

        final customerServiceResponse =
            await _createNewUser(user.email, accountResponse);
        await _sessionManager.setUser(
          User(
            customerId: customerServiceResponse.id,
            email: customerServiceResponse.email,
            isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
          ),
        );

        unawaited(_legacyUserService.saveLegacyUserId());

        yield LoginSuccessState();
      } on GigyaErrorException catch (e) {
        yield LoginErrorState(
          errorCode: e.errorCode,
          errorMessage: e.message,
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield LoginErrorState(
            errorMessage: 'Error occurred when logging in. Please try again');
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
    if (event is LinkAccountEvent) {
      yield LoginLoadingState();
      try {
        final accountResponse =
            await _gigyaService.linkAccounts(event.email, event.password);

        final customerServiceResponse =
            await _customerService.login(accountResponse.email);

        if (customerServiceResponse.status == 404) {
          await _createNewUser(accountResponse.email, accountResponse);
        } else {
          await _sessionManager.setUser(
            User(
              customerId: customerServiceResponse.id,
              email: customerServiceResponse.email,
              isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
              firstName: customerServiceResponse.firstName,
              lastName: customerServiceResponse.lastName,
            ),
          );
        }

        yield LoginSuccessState();
      } on GigyaErrorException catch (e) {
        yield LoginErrorState(
          errorCode: e.errorCode,
          errorMessage: e.message,
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } on Exception catch (e) {
        yield LoginErrorState(
          errorMessage: 'Error occurred when logging in. Please try again',
        );
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
    if (event is RetrySiteSignupEvent) {
      try {
        final lowerCaseEmail = event.email.toLowerCase();

        final accountResponse = await _gigyaService.siteLogin(
          lowerCaseEmail,
          event.password,
        );

        final customerServiceResponse =
            await _createNewUser(lowerCaseEmail, accountResponse);

        await _sessionManager.setUser(
          User(
            customerId: customerServiceResponse.id,
            email: customerServiceResponse.email,
            isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
          ),
        );

        await _localyticsService.updateUserProfile();

        _adobeUserProfileRepository
            .updateUserCustomerId(customerServiceResponse.email);

        _adobeUserProfileRepository
            .updateUserLocalyticsId(customerServiceResponse.id);

        unawaited(_legacyUserService.saveLegacyUserId());

        yield LoginSuccessState();
      } catch (e) {
        yield LoginErrorState(
          errorMessage: 'Error occurred when signing up. Please try again',
        );
        await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
  }

  Future<CustomerServiceResponse> _createNewUser(
      String email, GigyaAccountResponse accountResponse) async {
    final user = await _sessionManager.getUser();
    final customerServiceResponse = await _customerService.register(
      email,
      accountResponse.UID,
      accountResponse.idToken,
    );
    if (user != null && user.recommendationId != null) {
      await _recommendationService.createActivities(
          user.recommendationId, customerServiceResponse.id);
      await _sessionManager.setUser(
        User(
          customerId: customerServiceResponse.id,
          email: customerServiceResponse.email,
          isEmailVerified: customerServiceResponse.isEmailVerified ?? false,
        ),
      );
    }
    return customerServiceResponse;
  }

  Future _fetchCustomerRecommendations() async {
    final user = await _sessionManager.getUser();
    if (user != null && user.recommendationId == null) {
      var recommendation = await _recommendationService
          .getRecommendationByCustomer(user.customerId);
      if (recommendation != null && recommendation.recommendationId != null) {
        final currentDateTime = DateTime.now();

        // Sort products in the plan by application endDate
        recommendation.plan.products.sort(
          (product1, product2) => product1.applicationWindow.endDate.compareTo(
            product2.applicationWindow.endDate,
          ),
        );

        // This would happen when user has logged in from
        // previous Native Application and recommendation is of Last year
        // So, the old recommendation plan is no longer applicable and needs
        // to be "regenerated" using old "recommendationId".
        if (recommendation.plan.products.last.applicationWindow.endDate
            .isBefore(currentDateTime)) {
          recommendation = await _recommendationService
              .regenerateRecommendation(recommendation.recommendationId);
        }

        await _saveLawnData(recommendation.lawnData);
        await _sessionManager.setUser(
            user.copyWith(recommendationId: recommendation.recommendationId));
      }
    } else {
      if (user == null || user.customerId == null) return;
      final subscription = await _findSubscriptionsByCustomerIdService
          .findSubscriptionsByCustomerId(user.customerId);
      if (subscription.isEmpty) {
        await _recommendationService.updateCustomerRecommendation(
            user.recommendationId, user.customerId);
      } else {
        final recommendation = await _recommendationService
            .getRecommendationByCustomer(user.customerId);
        await _saveLawnData(recommendation.lawnData);
        await _sessionManager.setUser(User(
          recommendationId: recommendation.recommendationId,
        ));
      }
    }
  }

  Future<void> _saveLawnData(LawnData lawnData) async {
    try {
      final grassTypes = await _geoService
          .getGrassTypes(lawnData?.lawnAddress?.zip?.substring(0, 3));

      final userSelectedGrassType = grassTypes.firstWhere(
        (grassType) => grassType.type == lawnData.grassType,
        orElse: () => null,
      );

      if (userSelectedGrassType != null) {
        final updatedLawnData = lawnData.copyWith(
          grassTypeName: userSelectedGrassType.name,
          grassTypeImageUrl: userSelectedGrassType.imageUrl,
        );
        await _sessionManager.setLawnData(updatedLawnData);
        return;
      }
      await _sessionManager.setLawnData(lawnData);
    } catch (e) {
      // We save lawn data we get from recommendation service
      // and ignore grass type failures if it occurs and don't prevent login
      await _sessionManager.setLawnData(lawnData);
    }
  }
}
