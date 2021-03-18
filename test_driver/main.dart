import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/config/routes_config.dart';
import 'package:my_lawn/main.dart' as app;
import 'package:my_lawn/repositories/analytic/adobe_places_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/deep_links/i_deep_links.dart';
import 'stub/stub.dart';
import 'stubs/fake_deep_links.dart';
import 'stubs/stud_adobe_places.dart';
import 'stubs/stud_adobe_repository.dart';

import 'utils/test_asset_bundle.dart';

Future<void> main() async {
  void startApp() {
    runApp(
      DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: app.App(
          configureModels: mockConfiguration,
        ),
      ),
    );
  }

  const FLUTTER_DRIVER_OS = String.fromEnvironment('FLUTTER_DRIVER_OS');
  const TEST_ENV = String.fromEnvironment('TEST_ENV', defaultValue: 'rc');

  Future<String> dataHandlder(String message) async {
    var _message = message;
    var _value;
    if (message.contains('|')) {
      final _splitedMessage = message.split('|');

      _message = _splitedMessage.first;
      _value = _splitedMessage.last;
    }

    switch (_message) {
      case 'platform':
        return Platform.isIOS ? 'ios' : 'android';
      case 'raiseDeepLink':
        raiseDeeplink(_value);
        return '';
      case 'getAllAnalyticCalls':
        getAllAnalyticCalls();
        return '';
      case 'trackAppState':
        verifyFunction(_message, value: _value);
        return '';
      case 'checkPermissionWithReaction':
        verifyFunction(_message);
        return 'checkPermissionWithReaction';
      case 'restart':
        startApp();
        return 'ok';
        break;
      case 'get_os':
        return FLUTTER_DRIVER_OS;
        break;
      case 'env':
        return TEST_ENV;
    }
    throw Exception('Unknown command');
  }

  enableFlutterDriverExtension(handler: dataHandlder);

  // Uncomment if main is async.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Send errors to Crashlytics for debug builds.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

  // Send uncaught Flutter errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  configureRoutes();

  startApp();
}

Future<void> mockConfiguration({VoidCallback callback}) async {
  final test_env = await getEnvironment(
      const String.fromEnvironment('TEST_ENV', defaultValue: 'rc'));
  await configureModels();
  registry.unregister<AdobeRepository>();
  registry.unregister<AdobePlacesRepository>();

  registry.register<AdobeRepository>(instance: StubAdobeRepository());
  registry.register<AdobePlacesRepository>(
      instance: StubAdobePlacesRepository());
  await registry<EnvironmentConfig>().switchEnvironment(test_env);
  await registry<EnvironmentConfig>().configureAdobeAnalytics();
  configureDeeplink();

  if (callback != null) {
    callback();
  }
}

void raiseDeeplink(String link) {
  final deeplinks = registry<DeepLinks>() as FakeDeeplink;
  deeplinks.raise(Uri(path: link));
}

Future<Environment> getEnvironment(env_name) async {
  switch (env_name) {
    case 'dev':
      return Environment.dev;
    case 'rc':
      return Environment.rc;
    case 'hotfix':
      return Environment.hotfix;
    case 'prod':
      return Environment.prod;
    default:
      return Environment.rc;
  }
}

void configureDeeplink() {
  registry.unregister<DeepLinks>();
  registry.register<DeepLinks>(instance: FakeDeeplink());
}
