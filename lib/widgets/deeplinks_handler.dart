import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/screens/home/home_screen.dart';
import 'package:my_lawn/services/deep_links/i_deep_links.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class DeeplinksHandler extends StatefulWidget {
  const DeeplinksHandler({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _DeeplinksHandlerState createState() => _DeeplinksHandlerState();
}

class _DeeplinksHandlerState extends State<DeeplinksHandler> {
  StreamSubscription _sub;
  DeepLinks _deepLinks;

  @override
  void initState() {
    super.initState();
    _deepLinks = registry<DeepLinks>();
    _sub = _deepLinks.getUriLinksStream().listen((Uri uri) {
      _navigateToRoute(uri);
    }, onError: (Object err) {
      registry<Logger>().d('got err: $err');
    });

    unawaited(initPlatformState());
  }

  Future<void> initPlatformState() async {
    try {
      final initialUri = await _deepLinks.getInitialUri();

      if (initialUri != null) {
        _navigateToRoute(initialUri);
      }
    } on PlatformException catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } on FormatException catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _navigateToRoute(Uri uri) {
    if (uri?.path == '/signup' ||
        registry<AuthenticationBloc>().state.authStatus ==
            AuthStatus.loggedOut) {
      _saveLoggedInLink(uri);
      registry<Navigation>().popToRoot();
      registry<Navigation>().push('/auth/signup');
    } else {
      switch (uri?.path) {
        case '/homescreen':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.plan, ''));
          break;
        case '/calendar':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.calendar, ''));
          break;
        case '/ask':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.ask, ''));
          break;
        case '/ask/MyLawnCarePlan':
          final args =
              HomeScreenArguments(HomeScreenTab.ask, 'My Lawn Care Plan');
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home', arguments: args);
          break;
        case '/ask/FeedSeedActivities':
          final args =
              HomeScreenArguments(HomeScreenTab.ask, 'Feed & Seed Activities');
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home', arguments: args);
          break;
        case '/ask/rainfalltotal':
          final args = HomeScreenArguments(HomeScreenTab.ask, 'Rainfall Total');
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home', arguments: args);
          break;
        case '/Tips':
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.tips, ''));
          break;
        case '/plp':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/plp');
          break;
        case '/plp/category/InsectDiseaseControl':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.plan, ''));
          registry<Navigation>().push('/plp');
          registry<Navigation>().push(
            '/plp/listing',
            arguments: ProductCategory.insectAndDiseaseControl,
          );
          break;
        case '/plp/category/weedControl':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.plan, ''));
          registry<Navigation>().push('/plp');
          registry<Navigation>().push(
            '/plp/listing',
            arguments: ProductCategory.weedControl,
          );
          break;
        case '/plp/category/lawnFood':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.plan, ''));
          registry<Navigation>().push('/plp');
          registry<Navigation>().push(
            '/plp/listing',
            arguments: ProductCategory.lawnFood,
          );
          break;
        case '/plp/category/grassSeeds':
          registry<Navigation>().popToRoot();
          registry<Navigation>().pushReplacement('/home',
              arguments: HomeScreenArguments(HomeScreenTab.plan, ''));
          registry<Navigation>().push('/plp');
          registry<Navigation>().push(
            '/plp/listing',
            arguments: ProductCategory.grassSeeds,
          );
          break;
        case '/Task':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          break;
        case '/Task/Water':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.waterLawn);
          break;
        case '/Task/Mowing':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.mowLawn);
          break;
        case '/Task/AerateLawn':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.aerateLawn);
          break;
        case '/Task/DethatchLawn':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.dethatchLawn);
          break;
        case '/Task/OverseedLawn':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.overseedLawn);
          break;
        case '/Task/MulchBeds':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.mulchBeds);
          break;
        case '/Task/CleanDeck':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.cleanDeckPatio);
          break;
        case '/Task/winterizeSprinkler':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>().push('/activity',
              arguments: ActivityType.winterizeSprinklerSystem);
          break;
        case '/Task/TuneUpMower':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addtask');
          registry<Navigation>()
              .push('/activity', arguments: ActivityType.tuneUpMower);
          break;
        case '/Note':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/addnote');
          break;
        case '/profile':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/profile');
          break;
        case '/appSettings':
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/profile');
          registry<Navigation>().push('/profile/settings');
          break;
        case '/appSettings/aboutMyLawnApp':
          registry<Navigation>().popToRoot();
          registry<Navigation>()
              .push('/profile/settings', arguments: '/ask/detail');
          break;
        case '/mysubscriptionscreen':
          registry<SubscriptionBloc>().state.status.hasSubscriptionData;
          registry<Navigation>().popToRoot();
          registry<Navigation>().push('/profile');
          registry<Navigation>().push('/profile/subscription');
          break;
        default:
          {
            if (uri?.queryParameters['deep_link_value'] == 'profile') {
              registry<Navigation>().popToRoot();
              registry<Navigation>().push('/profile');
            } else if (uri?.pathSegments?.first == 'tips') {
              registry<Navigation>().popToRoot();
              registry<Navigation>().pushReplacement('/home',
                  arguments: HomeScreenArguments(
                      HomeScreenTab.tips, '${uri?.pathSegments?.last}'));
            } else if (uri?.pathSegments?.first == 'product') {
              registry<Navigation>().popToRoot();
              registry<Navigation>().pushReplacement('/home',
                  arguments: HomeScreenArguments(
                      HomeScreenTab.plan, '${uri?.pathSegments?.last}'));
            } else if (uri?.pathSegments?.first == 'faqs') {
              registry<Navigation>().popToRoot();
              registry<Navigation>().push('/profile');
              registry<Navigation>().push('/profile/subscription');
              registry<Navigation>().push('/profile/subscription/faqs',
                  arguments: '${uri?.pathSegments?.last}');
            }
          }
      }
    }
  }

  void _saveLoggedInLink(Uri uri) async {
    var path = uri?.queryParameters['deep_link_value'];
    if (path != null) {
      path = path[0] == '/' ? path : '/$path';
      await registry<SessionManager>().setLoggedInPath(path);
    }
  }
}

class HomeScreenArguments {
  final HomeScreenTab homeScreenTab;
  final String path;

  HomeScreenArguments(this.homeScreenTab, this.path);
}
