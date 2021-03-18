import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/calendar/calendar_screen.dart';
import 'package:my_lawn/screens/home/ask/ask_screen.dart';
import 'package:my_lawn/screens/home/plan_screen.dart';
import 'package:my_lawn/screens/tips/tips_screen.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/analytic/actions/localytics/home_screen_locading_event.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/home_screen/state.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/widgets/deeplinks_handler.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

enum HomeScreenTab {
  plan,
  tips,
  ask,
  calendar,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, RouteMixin<HomeScreen, HomeScreenArguments> {
  HomeScreenTab _selectedTab = HomeScreenTab.plan;

  String deepLinkPath;
  HomeScreenArguments savedArguments;

  @override
  void initState() {
    super.initState();

    final user = registry<AuthenticationBloc>().state.user;

    assert(user != null); // User should never be null to be on this screen.

    _navigateToLoggedInPath();
    if (user.customerId != null) {
      registry<RecommendationService>()
          .getRecommendationByCustomer(user.customerId);
    } else {
      registry<RecommendationService>()
          .getRecommendation(user.recommendationId);
    }

    registry<FindSubscriptionsByCustomerIdService>()
        .findSubscriptionsByCustomerId(user.customerId)
        .catchError((e) {
      var message;
      if (e is FindSubscriptionByCustomerIdException) message = e.errorMessage;
      unawaited(FirebaseCrashlytics.instance
          .recordError(message ?? e, StackTrace.current));
    });
    registry<ActivitiesService>()
        .waitForActivities(user.customerId, user.recommendationId);

    registry<LocalyticsService>().tagEvent(HomeScreenLoadingEvent());

    registry<AdobeRepository>().trackAppState(HomeScreenAdobeState());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if ((savedArguments?.path != routeArguments?.path)) {
      savedArguments = routeArguments;
      _selectedTab =
          routeArguments?.homeScreenTab ?? _selectedTab ?? HomeScreenTab.plan;
      deepLinkPath = routeArguments?.path;
    } else if (savedArguments?.path == routeArguments?.path) {
      deepLinkPath = null;
    }
  }

  void _navigateToLoggedInPath() async {
    final path = await registry<SessionManager>().getLoggedInPath();
    if (path?.isNotEmpty ?? false) {
      registry<SessionManager>().setLoggedInPath(null);
      await registry<Navigation>().push(path);
    }
  }

  void _didSelectTab(HomeScreenTab tab) {
    setState(() => _selectedTab = tab);
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case HomeScreenTab.plan:
        return PlanScreen(deepLinkPath: deepLinkPath);
      case HomeScreenTab.tips:
        return TipsScreen(deepLinkPath: deepLinkPath);
      case HomeScreenTab.ask:
        return AskScreen(deepLinkPath: deepLinkPath);
      case HomeScreenTab.calendar:
        return CalendarScreen();
      default:
        return null;
    }
  }

  static const double _tabIconSize = 32;

  BottomNavigationBarItem _buildTabItem({
    @required String activeIcon,
    @required String icon,
    @required String label,
  }) =>
      BottomNavigationBarItem(
        activeIcon: Image.asset(
          activeIcon,
          width: _tabIconSize,
          height: _tabIconSize,
          key:
              Key(label.removeNonCharsMakeLowerCaseMethod(identifier: '_icon')),
        ),
        icon: Image.asset(
          icon,
          width: _tabIconSize,
          height: _tabIconSize,
          key:
              Key(label.removeNonCharsMakeLowerCaseMethod(identifier: '_icon')),
        ),
        label: label,
      );

  Widget _buildTab() => BottomNavigationBar(
        key: Key('bottom_navigation_bar'),
        onTap: (index) => _didSelectTab(HomeScreenTab.values[index]),
        currentIndex: _selectedTab.index,
        items: [
          _buildTabItem(
            activeIcon: 'assets/icons/plan_selected.png',
            icon: 'assets/icons/plan_unselected.png',
            label: 'Plan',
          ),
          _buildTabItem(
            activeIcon: 'assets/icons/tips_selected.png',
            icon: 'assets/icons/tips_unselected.png',
            label: 'Tips',
          ),
          _buildTabItem(
            activeIcon: 'assets/icons/ask_selected.png',
            icon: 'assets/icons/ask_unselected.png',
            label: 'Ask',
          ),
          _buildTabItem(
            activeIcon: 'assets/icons/calendar_selected.png',
            icon: 'assets/icons/calendar_unselected.png',
            label: 'Calendar',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: _buildContent(),
      bottomNavigationBar: _buildTab(),
    );
  }
}
