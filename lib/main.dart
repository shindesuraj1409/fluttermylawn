import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:bus/bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/proxy_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/config/routes_config.dart';
import 'package:my_lawn/data/remote_config_data.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/models/remote_config_model.dart';
import 'package:my_lawn/models/theme_model.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/_root/forced_update_screen.dart';
import 'package:my_lawn/screens/_root/kill_switch_screen.dart';
import 'package:my_lawn/screens/_root/splash_screen.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/services/analytic/resources.dart';
import 'package:my_lawn/services/analytic/screen_state_action/kill_switch_screen/state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/welcome_screen/state.dart';
import 'package:my_lawn/widgets/deeplinks_handler.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Uncomment if main is async.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Send errors to Crashlytics for debug builds.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Send uncaught Flutter errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await configureProxy();

  // Set device to portrait mode only
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Send uncaught Dart errors to Crashlytics.
  await runZonedGuarded<Future<void>>(
    () async {
      runApp(
        Phoenix(
            child: App(
          configureModels: configureModels,
        )),
      );
    },
    (e, trace) {
      FirebaseCrashlytics.instance.recordError(e, trace);
    },
  );

  configureRoutes();
}

class App extends StatefulWidget {
  final Future<void> Function() configureModels;

  const App({Key key, @required this.configureModels}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isInitialized = false;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    widget
        .configureModels()
        .then((value) {
          _sendSplashAnalytic();
        })
        .then((_) {
          _listenToAuthBloc();
          setFirebaseCustomKeys();
          setState(() => _isInitialized = true);
        })
        .then(
          (_) => AnalyticsEvent.appOpen.log(registry<Analytics>()),
        )
        .then((_) => registry<AppsFlyerService>().initAppsFlyer());
  }

  void _sendSplashAnalytic() async {
    registry<AdobeRepository>().trackAppState(
      OnBoardingState(
        smsEnabled: await Permission.sms.isGranted,
        pushEnabled: await Permission.notification.isGranted,
        locationEnabled: await Permission.location.isGranted,
      ),
    );
  }

  void _listenToAuthBloc() {
    _subscription = registry<AuthenticationBloc>().distinct(
      (prev, current) {
        // Don't re-route from here when user changes from "Guest" to "LoggedIn"
        // and let all local routing logic handle it on their own based on from where
        // the "Guest" user was converted to "Registered" user
        // instead of clearing stack unnecessarily by routing from here.
        if (prev.isGuest && current.isLogggedIn) {
          return true;
        }
        // Re-route from here when auth status changes except for the above case
        return prev.authStatus == current.authStatus;
      },
    ).listen((state) {
      //Re-direct to logout submit screen to clear the navigation stack
      if (state.isLoggingOut) {
        registry<Navigation>().setRoot('/loggingout');
        return;
      }
      if (state.isLoggedOut) {
        //Re-create a new transId when a user logs out.
        setFirebaseCustomKeys();
        //also delete all data from cache
        clearCache();
      }

      registry<AdobeUserProfileRepository>().updateUserAttribute(
        isLoggedInAttributeStr,
        state.isLogggedIn,
      );

      final redirectRoute = state.isLoggedOut ? '/welcome' : '/initialize';
      registry<Navigation>().setRoot(redirectRoute);

      final customerId = state.user == null ? '' : state.user.customerId;
      unawaited(FirebaseCrashlytics.instance.setUserIdentifier(customerId));
    });
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    super.dispose();
  }

  Widget _buildKillSwitch(String message) => MaterialApp(
        title: registry<AppModel>().title,
        theme: busSnapshot<ThemeModel, ThemeData>(),
        home: KillSwitchScreen(message),
      );

  Widget _buildForcedUpdate(String message) => MaterialApp(
        title: registry<AppModel>().title,
        theme: busSnapshot<ThemeModel, ThemeData>(),
        home: ForcedUpdateScreen(message),
      );

  Widget _buildApp() => busStreamBuilder<ThemeModel, ThemeData>(
        builder: (context, themeModel, themeData) => MaterialApp(
          title: registry<AppModel>().title,
          theme: themeData,
          navigatorKey: registry<Navigation>().navigatorKey,
          navigatorObservers: [
            registry<Navigation>().navigatorObserver,
            registry<Analytics>().navigatorObserver,
          ],
          initialRoute: '/',
          builder: (_, child) => DeeplinksHandler(child: child),
          onGenerateRoute: generateRoute,
        ),
      );

  //TODO: should be removed from main
  void _sendAdobeAnalytic() {
    registry<AdobeRepository>().trackAppState(
      KillSwitchForceScreenAdobeState(),
    );
  }

  @override
  Widget build(BuildContext context) => !_isInitialized
      ? SplashScreen()
      : busStreamBuilder<RemoteConfigModel, RemoteConfigData>(
          builder: (context, remoteModel, remoteConfigData) {
            if (remoteConfigData.isKillSwitchActive) {
              //TODO: should be removed from main
              _sendAdobeAnalytic();
              return _buildKillSwitch(remoteConfigData.killSwitchMessage);
            } else if (remoteConfigData.isForceUpdateActive) {
              //TODO: should be removed from main
              _sendAdobeAnalytic();
              return _buildForcedUpdate(remoteConfigData.forceUpdateMessage);
            }

            return _buildApp();
          },
        );
}
