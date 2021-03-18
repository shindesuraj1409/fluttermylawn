import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:my_lawn/screens/_root/connectivity_screen.dart';
import 'package:my_lawn/screens/_root/first_run_screen.dart';
import 'package:my_lawn/screens/_root/missing_screen.dart';
import 'package:my_lawn/screens/_root/root_screen.dart';
import 'package:my_lawn/screens/account/account_email_screen.dart';
import 'package:my_lawn/screens/account/account_name_screen.dart';
import 'package:my_lawn/screens/account/account_password_screen.dart';
import 'package:my_lawn/screens/account/account_screen.dart';
import 'package:my_lawn/screens/auth/create_new_password_screen.dart';
import 'package:my_lawn/screens/auth/create_password_screen.dart';
import 'package:my_lawn/screens/auth/enter_email_screen.dart';
import 'package:my_lawn/screens/auth/forgot_password_email_sent_screen.dart';
import 'package:my_lawn/screens/auth/forgot_password_screen.dart';
import 'package:my_lawn/screens/auth/link_account_screen.dart';
import 'package:my_lawn/screens/auth/link_social_account_screen.dart';
import 'package:my_lawn/screens/auth/login_screen.dart';
import 'package:my_lawn/screens/auth/logging_out_screen.dart';
import 'package:my_lawn/screens/auth/pending_registration_screen.dart';
import 'package:my_lawn/screens/auth/reset_screen.dart';
import 'package:my_lawn/screens/auth/signup_screen.dart';
import 'package:my_lawn/screens/auth/welcome_screen.dart';
import 'package:my_lawn/screens/calendar/search_screen.dart';
import 'package:my_lawn/screens/cart/cart_screen.dart';
import 'package:my_lawn/screens/checkout/checkout_screen.dart';
import 'package:my_lawn/screens/checkout/order_confirmation_screen.dart';
import 'package:my_lawn/screens/checkout/order_processing_screen.dart';
import 'package:my_lawn/screens/home/actions/activity_screen.dart';
import 'package:my_lawn/screens/home/actions/add_note.dart';
import 'package:my_lawn/screens/home/actions/add_task.dart';
import 'package:my_lawn/screens/home/ask/widgets/help_article.dart';
import 'package:my_lawn/screens/home/home_screen.dart';
import 'package:my_lawn/screens/initialization/user_initialization_screen.dart';
import 'package:my_lawn/screens/onboarding/permissions/location_sharing_ask_screen.dart';
import 'package:my_lawn/screens/onboarding/permissions/push_opt_in_ask_screen.dart';
import 'package:my_lawn/screens/pdp/store_locator/local_store_locator_screen.dart';
import 'package:my_lawn/screens/pdp/store_locator/online_store_locator_screen.dart';
import 'package:my_lawn/screens/plp/listing_screen.dart';
import 'package:my_lawn/screens/plp/main_product_listing_screen.dart';
import 'package:my_lawn/screens/plp/widgets/plp_search_bar.dart';
import 'package:my_lawn/screens/product/product_detail_screen.dart';
import 'package:my_lawn/screens/profile/edit_lawn_profile_screen.dart';
import 'package:my_lawn/screens/profile/profile_screen.dart';
import 'package:my_lawn/screens/profile/settings/app_feedback_negative_screen.dart';
import 'package:my_lawn/screens/profile/settings/app_feedback_positive_screen.dart';
import 'package:my_lawn/screens/profile/settings/app_feedback_screen.dart';
import 'package:my_lawn/screens/profile/settings/app_settings_screen.dart';
import 'package:my_lawn/screens/profile/settings/developer/available_routes_screen.dart';
import 'package:my_lawn/screens/profile/settings/developer/developer_settings_screen.dart';
import 'package:my_lawn/screens/profile/subscription/cancelletion/cancel_subscription_screen.dart';
import 'package:my_lawn/screens/profile/subscription/cancelletion/canceling_screen.dart';
import 'package:my_lawn/screens/profile/subscription/cancelletion/cancellation_completed_screen.dart';
import 'package:my_lawn/screens/profile/subscription/cancelletion/why_are_you_canceling_screen.dart';
import 'package:my_lawn/screens/profile/subscription/renew_subscription_screen.dart';
import 'package:my_lawn/screens/profile/subscription/subscription_faqs_screen.dart';
import 'package:my_lawn/screens/profile/subscription/subscription_screen.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/update_billing_info_screen.dart';
import 'package:my_lawn/screens/profile/update_lawn_profile/modify_lawn_profile_loading_screen.dart';
import 'package:my_lawn/screens/profile/update_lawn_profile/update_plan_screen.dart';
import 'package:my_lawn/screens/quiz/grass_type_screen.dart';
import 'package:my_lawn/screens/quiz/lawn_address_screen.dart';
import 'package:my_lawn/screens/quiz/lawn_condition_screen.dart';
import 'package:my_lawn/screens/quiz/lawn_size_zipcode_screen.dart';
import 'package:my_lawn/screens/quiz/lawn_tracing_screen.dart';
import 'package:my_lawn/screens/quiz/quiz_modify_screen.dart';
import 'package:my_lawn/screens/quiz/quiz_submit_screen.dart';
import 'package:my_lawn/screens/quiz/spreader_type_screen.dart';
import 'package:my_lawn/screens/subscription/subscription_options_screen.dart';
import 'package:my_lawn/screens/tips/tips_detail_screen.dart';
import 'package:my_lawn/widgets/add_product.dart';
import 'package:my_lawn/widgets/web_view_screen_widget.dart';

enum RouteTransition {
  Default,
  SlideInFromLeft,
}

final Map<String, WidgetBuilder> _routes = {};
final Map<String, RouteTransition> _transitions = {};

Map<String, Type> get debugRoutes {
  // https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
  final keyRegExp = RegExp(r'^\^?(.*?)\$?$');
  return Map.unmodifiable({
    for (final key in _routes.keys)
      keyRegExp.firstMatch(key)?.group(1) ?? key:
          _routes[key]?.call(null).runtimeType,
  });
}

void configureRoutes() {
  _routes.clear();

  _addRoute(
    '__missing__',
    (context) => MissingScreen(),
  );

  _addRoute(
    r'^/$',
    (context) => RootScreen(),
  );
  _addRoute(
    r'^/connectivity$',
    (context) => ConnectivityScreen(),
  );
  _addRoute(
    r'^/firstrun$',
    (context) => FirstRunScreen(),
  );
  _addRoute(
    r'^/initialize',
    (context) => UserInitializationScreen(),
  );
  _addRoute(
    r'^/welcome$',
    (context) => WelcomeScreen(),
  );
  _addRoute(
    r'^/loggingout$',
    (context) => LoggingOutScreen(),
  );
  _addRoute(
    r'^/home$',
    (context) => HomeScreen(),
  );
  _addRoute(
    r'^/addnote$',
    (context) => AddNote(),
  );
  _addRoute(
    r'^/addtask$',
    (context) => AddTask(),
  );
  _addRoute(
    r'^/addproduct$',
    (context) => AddProduct(),
  );
  _addRoute(
    r'^/activity$',
    (context) => ActivityScreen(),
  );
  _addRoute(
    r'^/subscription/options$',
    (context) => SubscriptionOptionsScreen(),
  );

  _addRoute(
    r'^/profile$',
    (context) => ProfileScreen(),
    routeTransition: RouteTransition.SlideInFromLeft,
  );
  _addRoute(
    r'^/profile/subscription$',
    (context) => SubscriptionScreen(),
  );
  _addRoute(
    r'^/profile/subscription/faqs$',
    (context) => SubscriptionFaqsScreen(),
  );
  _addRoute(
    r'^/profile/subscription/renew$',
    (context) => RenewSubscriptionScreen(),
  );
  _addRoute(
    r'^/profile/subscription/cancel$',
    (context) => CancelSubscriptionScreen(),
  );
  _addRoute(
    r'^/profile/subscription/update_billing_info$',
    (context) => UpdateBillingInfoScreen(),
  );
  _addRoute(
    r'^/profile/subscription/why_are_you_canceling_screen$',
    (context) => WhyAreYouCancelingScreen(),
  );
  _addRoute(
    r'^/profile/subscription/canceling_screen$',
    (context) => CancelingScreen(),
  );
  _addRoute(
    r'^/profile/subscription/cancellation_completed_screen$',
    (context) => CancellationCompletedScreen(),
  );
  _addRoute(
    r'^/profile/editlawn$',
    (context) => EditLawnProfileScreen(),
  );
  _addRoute(
    r'^/profile/settings$',
    (context) => AppSettingsScreen(),
  );
  _addRoute(
    r'^/profile/settings/feedback$',
    (context) => AppFeedbackScreen(),
  );
  _addRoute(
    r'^/profile/settings/termsconditions$',
    (context) => WebViewScreen(
      title: 'Conditions of Use',
      url:
          'https://scottsmiraclegro.com/terms-conditions?utm_source=mylawn&utm_medium=inapplink&utm_content=appsettings',
    ),
  );
  _addRoute(
    r'^/profile/settings/privacy$',
    (context) => WebViewScreen(
      title: 'Privacy Notice',
      url:
          'https://scottsmiraclegro.com/privacy?utm_source=mylawn&utm_medium=inapplink&utm_content=appsettings',
    ),
  );
  _addRoute(
    r'^/profile/settings/dontsellinformation$',
    (context) => WebViewScreen(
      title: 'Do Not Sell My Information',
      url:
          'https://docs.google.com/forms/d/e/1FAIpQLSfRPI5U7u6w-_7ixsYJUM68c2iv97vLIc6qVbIghx_RhyOHDw/viewform',
    ),
  );
  _addRoute(
    r'^/profile/settings/feedback/positive$',
    (context) => AppFeedbackPositiveScreen(),
  );
  _addRoute(
    r'^/profile/settings/feedback/negative$',
    (context) => AppFeedbackNegativeScreen(),
  );

  _addRoute(
    r'^/profile/settings/developer$',
    (context) => LogConsoleOnShake(child: DeveloperSettingsScreen()),
  );
  _addRoute(
    r'^/profile/settings/developer/error$',
    (context) => ErrorWidget('This is a sample Red Error Page'),
  );
  _addRoute(
    r'^/profile/settings/developer/routes$',
    (context) => AvailableRoutesScreen(),
  );

  _addRoute(
    r'^/account$',
    (context) => AccountScreen(),
  );
  _addRoute(
    r'^/account/name$',
    (context) => AccountNameScreen(),
  );
  _addRoute(
    r'^/account/email$',
    (context) => AccountEmailScreen(),
  );
  _addRoute(
    r'^/account/password$',
    (context) => AccountPasswordScreen(),
  );

  _addRoute(
    r'^/auth/login$',
    (context) => LoginScreen(),
  );
  _addRoute(
    r'^/auth/reset$',
    (context) => ResetPasswordScreen(),
  );
  _addRoute(
    r'^/auth/signup$',
    (context) => SignupScreen(),
  );
  _addRoute(
    r'^/auth/forgotpassword$',
    (context) => ForgotPasswordScreen(),
  );
  _addRoute(
    r'^/auth/forgotpassword/emailsent$',
    (context) => ForgotPasswordEmailSentScreen(),
  );
  _addRoute(
    r'^/auth/createnewpassword$',
    (context) => CreateNewPasswordScreen(),
  );
  _addRoute(
    r'^/auth/pendingregistration$',
    (context) => PendingRegistrationScreen(),
  );
  _addRoute(
    r'^/auth/linkaccount$',
    (context) => LinkAccountScreen(),
  );
  _addRoute(
    r'^/auth/linksocialaccount$',
    (context) => LinkSocialAccountScreen(),
  );
  _addRoute(
    r'^/auth/enteremail$',
    (context) => EnterEmailScreen(),
  );
  _addRoute(
    r'^/auth/createpassword$',
    (context) => CreatePasswordScreen(),
  );

  _addRoute(
    r'^/checkout$',
    (context) => CheckoutScreen(),
  );
  _addRoute(
    r'^/checkout/processing$',
    (context) => OrderProcessingScreen(),
  );
  _addRoute(
    r'^/checkout/confirmation$',
    (context) => OrderConfirmationScreen(),
  );

  // Quiz Screens
  // -----  ----  ------

  // This is because lawn condition screen will be first screen always in quiz flow
  // Registered other one `quiz/lawncondition` because if someone wants to open
  // LawnCondition screen directly from other screens like EditLawnProfile they
  // can do it without creating confusion of whether they should push `/quiz` or `/quiz/lawncondition`
  // route to Navigation stack.
  _addRoute(
    r'^/quiz$',
    (context) => LawnConditionScreen(),
  );
  _addRoute(
    r'^/quiz/lawncondition$',
    (context) => LawnConditionScreen(),
  );
  _addRoute(
    r'^/quiz/spreadertype$',
    (context) => SpreaderTypeScreen(),
  );
  _addRoute(
    r'^/quiz/lawnaddress$',
    (context) => LawnAddressScreen(),
  );
  _addRoute(
    r'^/quiz/tracing$',
    (context) => LawnTracingScreen(),
  );
  _addRoute(
    r'^/quiz/lawnsizezipcode$',
    (context) => LawnSizeZipCodeScreen(),
  );
  _addRoute(
    r'^/quiz/grasstype$',
    (context) => GrassTypeScreen(),
  );
  _addRoute(
    r'^/quiz/softask/push$',
    (context) => PushOptInAskScreen(),
  );
  _addRoute(
    r'^/quiz/softask/location$',
    (context) => LocationSharingAskScreen(),
  );
  _addRoute(
    r'^/quiz/submit$',
    (context) => QuizSubmitScreen(),
  );
  _addRoute(
    r'^/quiz/modify$',
    (context) => QuizModifyScreen(),
  );
  _addRoute(
    r'^/product/detail$',
    (context) => ProductDetailScreen(),
  );

  _addRoute(
    r'^/plp$',
    (context) => MainProductListingScreen(),
  );
  _addRoute(
    r'^/plp/listing$',
    (context) => ProductListingScreen(),
  );

  _addRoute(
    r'^/plp/search$',
    (context) => PlpSearchScreen(),
  );

  _addRoute(
    r'^/pdp/storelocator/local$',
    (context) => LocalStoreLocatorScreen(),
  );
  _addRoute(
    r'^/pdp/storelocator/online$',
    (context) => OnlineStoreLocatorScreen(),
  );
  _addRoute(
    r'^/cart$',
    (context) => CartScreen(),
  );

  _addRoute(
    r'^/tips/detail$',
    (context) => TipsDetailScreen(),
  );
  _addRoute(
    r'^/ask/detail$',
    (context) => HelpArticleScreen(),
  );
  _addRoute(
    r'^/profile/update_plan_screen$',
    (context) => UpdatePlanScreen(),
  );
  _addRoute(
    r'^/profile/modify_lawn_profile_loading_screen$',
    (context) => ModifyLawnProfileLoadingScreen(),
  );
  _addRoute(
    r'^/calendar/search$',
    (context) => SearchScreen(),
  );
  _addRoute(
    r'^/profile/subscription/track$',
    (context) => WebViewScreen(),
  );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  final routeKey = _routes.keys.firstWhere(
      (pattern) => RegExp(pattern).hasMatch(settings.name),
      orElse: () => '__missing__');

  if (routeKey == null) {
    return null;
  }

  final transitionKey = _transitions.keys.firstWhere(
      (pattern) => RegExp(pattern).hasMatch(settings.name),
      orElse: () => null);
  final routeTransition =
      _transitions[transitionKey] ?? RouteTransition.Default;

  switch (routeTransition) {
    case RouteTransition.SlideInFromLeft:
      return PageRouteBuilder(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            _routes[routeKey](context),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) =>
            SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child),
        settings: settings,
      );
    case RouteTransition.Default:
    default:
      return MaterialPageRoute(
        builder: (context) => _routes[routeKey](context),
        settings: settings,
      );
  }
}

void _addRoute(
  String pattern,
  Widget Function(BuildContext) childBuilder, {
  RouteTransition routeTransition = RouteTransition.Default,
}) {
  assert(
    !_routes.containsKey(pattern),
    '$pattern was already added',
  );

  _routes[pattern] = childBuilder;
  _transitions[pattern] = routeTransition;
}
