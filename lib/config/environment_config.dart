import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:local_storage/local_storage.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_core_service.dart';
import 'package:my_lawn/services/auth/gigya/gigya_api_client.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_api_client.dart';
import 'package:my_lawn/services/auth/refresh/i_refresh_token_service.dart';
import 'package:my_lawn/services/auth/refresh/refresh_token_service.dart';
import 'package:my_lawn/services/contentful/contentful_service.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:my_lawn/services/graphql/graphql_repository_imp.dart';
import 'package:my_lawn/services/graphql/i_graphql_repository.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/places/places_api_client.dart';
import 'package:my_lawn/services/recurly/i_recurly_api_client.dart';
import 'package:my_lawn/services/recurly/recurly_api_client.dart';
import 'package:my_lawn/services/scotts_api_client.dart';

class EnvironmentConfig {
  // Adobe Analytics DEV Environment IDs
  static const String ADOBE_ANDROID_KEY_DEV = 'ADOBE_ANDROID_KEY_DEV';
  static const String ADOBE_IOS_KEY_DEV = 'ADOBE_IOS_KEY_DEV';
  // Adobe Analytics PROD Environment IDs
  static const String ADOBE_ANDROID_KEY_PROD = 'ADOBE_ANDROID_KEY_PROD';
  static const String ADOBE_IOS_KEY_PROD = 'ADOBE_IOS_KEY_PROD';

  // Dev environment api key.
  static const String DEV_API_KEY = 'DEV_API_KEY';
  // Rc environment api key
  static const String RC_API_KEY = 'RC_API_KEY';
  // Hotfix environment api key
  static const String HOTFIX_API_KEY = 'HOTFIX_API_KEY';
  // Prod environment api key
  static const String PROD_API_KEY = 'PROD_API_KEY';

  static const String PLACES_API_KEY = 'PLACES_API_KEY';

  static const String PSPIDER_ONLINE_STORES_API_KEY =
      'PSPIDER_ONLINE_STORES_API_KEY';
  static const String PSPIDER_LOCAL_SELLERS_API_KEY =
      'PSPIDER_LOCAL_SELLERS_API_KEY';

  // Contentful api key.
  static const String DEV_CONTENTFUL_KEY = 'DEV_CONTENTFUL_KEY';
  static const String PROD_CONTENTFUL_KEY = 'PROD_CONTENTFUL_KEY';

  // Dev environment Gigya api key.
  static const String DEV_GIGYA_API_KEY = 'DEV_GIGYA_API_KEY';
  // Rc environment Gigya api key
  static const String RC_GIGYA_API_KEY = 'RC_GIGYA_API_KEY';
  // Hotfix environment Gigya api key
  static const String HOTFIX_GIGYA_API_KEY = 'HOTFIX_GIGYA_API_KEY';
  // Prod environment Gigya api key
  static const String PROD_GIGYA_API_KEY = 'PROD_GIGYA_API_KEY';

  // For Dev, Rc and Hotfix env
  static const String RECURLY_PUBLIC_KEY = 'RECURLY_PUBLIC_KEY';
  // For prod env
  static const String PROD_RECURLY_PUBLIC_KEY = 'PROD_RECURLY_PUBLIC_KEY';

  //firebase project names
  static const String DTC_DEVELOP_ECOMM = 'dtc-develop-ecomm';
  static const String DTC_INFRASTRUCTURE_SANDBOX = 'dtc-infrastructure-sandbox';
  static const String DTC_HOTFIX_ECOMM = 'dtc-hotfix-ecomm';
  static const String DTC_PROD_ECOMM = 'dtc-prod-ecomm';

  //dtc-infastructure-sandbox creds
  static const String DTC_INFRASTRUCTURE_SANDBOX_MESSAGE_SENDER_ID =
      'DTC_INFRASTRUCTURE_SANDBOX_MESSAGE_SENDER_ID';
  static const String DTC_INFRASTRUCTURE_SANDBOX_IOS_APP_ID =
      'DTC_INFRASTRUCTURE_SANDBOX_IOS_APP_ID';
  static const String DTC_INFRASTRUCTURE_SANDBOX_ANDROID_APP_ID =
      'DTC_INFRASTRUCTURE_SANDBOX_ANDROID_APP_ID';
  static const String DTC_INFRASTRUCTURE_SANDBOX_IOS_API_KEY =
      'DTC_INFRASTRUCTURE_SANDBOX_IOS_API_KEY';
  static const String DTC_INFRASTRUCTURE_SANDBOX_ANDROID_API_KEY =
      'DTC_INFRASTRUCTURE_SANDBOX_ANDROID_API_KEY';

  final LocalStorage _localStorage;
  final SessionManager _sessionManager;

  EnvironmentConfig(
    LocalStorage localStorage,
    SessionManager sessionManager,
  )   : _localStorage = localStorage,
        _sessionManager = sessionManager;

  Future<void> switchEnvironment(Environment environment) async {
    // Logout user. Clearing all the data for particular environment
    await _sessionManager.clearAll();
    // Update environment value in localstorage to be picked up on app restart.
    await _localStorage.write('environment', environment.string);
  }

  Future<Environment> getSelectedEnvironment() async {
    final environmentSaved = await _localStorage.read('environment');
    final environmentSelected = Environment.values.firstWhere(
      (environment) => environment.string == environmentSaved,
      orElse: () => kDebugMode ? Environment.rc : Environment.prod,
    );
    return environmentSelected;
  }

  Future<void> configureAdobeAnalytics() async {
    final environmentSelected = await getSelectedEnvironment();

    // Would have preferred to use ternary operators inside
    // of String.fromEnvironment, but it is const only:
    // https://github.com/flutter/flutter/issues/55870
    String adobeEnvironmentId;
    if (Platform.isAndroid) {
      if (environmentSelected == Environment.prod) {
        adobeEnvironmentId = const String.fromEnvironment(
          EnvironmentConfig.ADOBE_ANDROID_KEY_PROD,
        );
      } else {
        adobeEnvironmentId = const String.fromEnvironment(
          EnvironmentConfig.ADOBE_ANDROID_KEY_DEV,
        );
      }
    } else {
      if (environmentSelected == Environment.prod) {
        adobeEnvironmentId = const String.fromEnvironment(
          EnvironmentConfig.ADOBE_IOS_KEY_PROD,
        );
      } else {
        adobeEnvironmentId = const String.fromEnvironment(
          EnvironmentConfig.ADOBE_IOS_KEY_DEV,
        );
      }
    }

    try {
      if (await registry<AdobeCoreService>().configure(adobeEnvironmentId)) {
        registry<Logger>().d(
          'configureAdobeAnalytics($adobeEnvironmentId): success',
        );
      } else {
        registry<Logger>().w(
          'configureAdobeAnalytics($adobeEnvironmentId): failure',
        );
      }
    } on PlatformException catch (e) {
      registry<Logger>().e(
        'configureAdobeAnalytics($adobeEnvironmentId): failure: ${e.message}',
      );
    }
  }

  void registerApiClients() async {
    String xApiKey;
    String gigyaApiKey;
    String contentfulKey;
    String recurlyPublicKey;
    String contentfulEnvironment;
    String host;
    String source;
    final sourceService = 'LS';

    try {
      final environmentSelected = await getSelectedEnvironment();

      host = environmentSelected.host;
      contentfulEnvironment = environmentSelected.contentfulEnvironment;

      switch (environmentSelected) {
        case Environment.dev:
          xApiKey = const String.fromEnvironment(EnvironmentConfig.DEV_API_KEY);
          source = 'scottsprogram.com';
          gigyaApiKey =
              const String.fromEnvironment(EnvironmentConfig.DEV_GIGYA_API_KEY);
          recurlyPublicKey = const String.fromEnvironment(
              EnvironmentConfig.RECURLY_PUBLIC_KEY);
          contentfulKey = const String.fromEnvironment(
              EnvironmentConfig.DEV_CONTENTFUL_KEY);
          break;
        case Environment.rc:
          xApiKey = const String.fromEnvironment(EnvironmentConfig.RC_API_KEY);
          source = 'scottsprogram.com';
          gigyaApiKey =
              const String.fromEnvironment(EnvironmentConfig.RC_GIGYA_API_KEY);
          recurlyPublicKey = const String.fromEnvironment(
              EnvironmentConfig.RECURLY_PUBLIC_KEY);
          contentfulKey = const String.fromEnvironment(
              EnvironmentConfig.PROD_CONTENTFUL_KEY);
          break;
        case Environment.hotfix:
          xApiKey =
              const String.fromEnvironment(EnvironmentConfig.HOTFIX_API_KEY);
          source = 'scottsprogram.com';
          gigyaApiKey = const String.fromEnvironment(
              EnvironmentConfig.HOTFIX_GIGYA_API_KEY);
          recurlyPublicKey = const String.fromEnvironment(
              EnvironmentConfig.RECURLY_PUBLIC_KEY);
          contentfulKey = const String.fromEnvironment(
              EnvironmentConfig.PROD_CONTENTFUL_KEY);
          break;
        case Environment.prod:
          xApiKey =
              const String.fromEnvironment(EnvironmentConfig.PROD_API_KEY);
          source = 'program.scotts.com';
          gigyaApiKey = const String.fromEnvironment(
              EnvironmentConfig.PROD_GIGYA_API_KEY);
          recurlyPublicKey = const String.fromEnvironment(
              EnvironmentConfig.PROD_RECURLY_PUBLIC_KEY);
          contentfulKey = const String.fromEnvironment(
              EnvironmentConfig.PROD_CONTENTFUL_KEY);

          break;
        default:
      }
    } catch (e) {
      xApiKey = const String.fromEnvironment(EnvironmentConfig.DEV_API_KEY);
      source = 'scottsprogram.com';
      host = Environment.dev.host;
      gigyaApiKey =
          const String.fromEnvironment(EnvironmentConfig.DEV_GIGYA_API_KEY);
      contentfulKey =
          const String.fromEnvironment(EnvironmentConfig.DEV_CONTENTFUL_KEY);
      contentfulEnvironment = Environment.dev.contentfulEnvironment;
      recurlyPublicKey =
          const String.fromEnvironment(EnvironmentConfig.RECURLY_PUBLIC_KEY);
    }

    // Refresh Token Service
    registry.register<RefreshTokenService>(
      instance: RefreshTokenServiceImpl(
        xApiKey,
        Client(),
        registry<SessionManager>(),
        host,
        source,
        sourceService,
      ),
    );

    // Scotts Api client
    registry.register<ScottsApiClient>(
      instance: ScottsApiClientImpl(
        xApiKey,
        registry<SessionManager>(),
        host,
        source,
        sourceService,
        registry<RefreshTokenService>(),
      ),
    );

    // GraphQL Api Client
    registry.register<GraphQlRepository>(
      instance: GraphQlRepositoryImpl(
        xApiKey,
        host,
      ),
    );

    // Gigya Api client
    registry.register<GigyaApiClient>(
      instance: GigyaApiClientImpl(gigyaApiKey),
    );

    // Contentful Api client
    registry.register<ContentfulService>(
      instance: ContentfulServiceImpl(
        contentfulKey,
        environment: contentfulEnvironment,
      ),
    );

    // Places Api Client
    registry.register<PlacesApiClient>(
      instance: PlacesApiClientImpl(
        Client(),
        const String.fromEnvironment(PLACES_API_KEY),
      ),
    );

    // Recurly Api Client
    registry.register<RecurlyApiClient>(
      instance: RecurlyClientImpl(recurlyPublicKey),
    );
  }
}

enum Environment {
  dev,
  rc,
  hotfix,
  prod,
}

extension EnvironmentStringExtension on Environment {
  String get string {
    switch (this) {
      case Environment.dev:
        return 'dev';
      case Environment.rc:
        return 'rc';
      case Environment.hotfix:
        return 'hotfix';
      case Environment.prod:
        return 'prod';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  String get host {
    switch (this) {
      case Environment.dev:
        return 'develop.api.scotts.com';
      case Environment.rc:
        return 'rc.api.scotts.com';
      case Environment.hotfix:
        return 'hotfix.api.scotts.com';
      case Environment.prod:
        return 'api.scotts.com';
      default:
        throw UnimplementedError('Missing host for $this');
    }
  }

  String get contentfulEnvironment {
    switch (this) {
      case Environment.dev:
        return 'development';
      case Environment.rc:
        return 'production';
      case Environment.hotfix:
        return 'production';
      case Environment.prod:
        return 'production';
      default:
        throw UnimplementedError('Missing contentfulEnvironment for $this');
    }
  }

  Color get color {
    switch (this) {
      case Environment.dev:
        return Styleguide.color_accents_blue_3;
      case Environment.rc:
        return Styleguide.color_accents_yellow_3;
      case Environment.hotfix:
        return Styleguide.color_accents_red;
      case Environment.prod:
        return Styleguide.color_green_3;
      default:
        throw UnimplementedError('Missing color for $this');
    }
  }
}
