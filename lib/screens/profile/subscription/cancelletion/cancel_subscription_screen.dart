import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/profile/subscription/widgets/cancelation_bottom_nav_bar.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class CancelSubscriptionScreen extends StatefulWidget {
  @override
  _CancelSubscriptionScreenState createState() => _CancelSubscriptionScreenState();
}

class _CancelSubscriptionScreenState extends State<CancelSubscriptionScreen> {

  @override
  void initState() {
    adobeAnalyticCall();

    super.initState();
  }

  void adobeAnalyticCall() {
    registry<AdobeRepository>().trackAppState(
      CancelSubscriptionScreenAdobeState(),
    );
  }

  final _radioDecoration = BoxDecoration(
    color: Styleguide.color_gray_0,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ],
  );

  Widget _questionAndAnswerWidgets(
    String question,
    String answer,
    EdgeInsets margin,
    ThemeData theme,
  ) {
    return Container(
      margin: margin,
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            question,
            style: theme.textTheme.headline4,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '$answer\t',
                  style: theme.textTheme.subtitle1,
                ),
                TextSpan(
                  text: 'Learn more',
                  style: theme.textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Text(
                    'We understand that lawn care can be tough. Can we help you get your best results?',
                    style: theme.textTheme.subtitle1.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  decoration: _radioDecoration,
                  margin: EdgeInsets.fromLTRB(8, 20, 8, 56),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _questionAndAnswerWidgets(
                          'Still seeing weeds?',
                          'You should see the results from weed control after about 30 days.',
                          EdgeInsets.fromLTRB(10, 10, 5, 12),
                          theme),
                      _questionAndAnswerWidgets(
                          'Lawn looking brown?',
                          'Your lawn can get stressed from really hot air or dry condition.',
                          EdgeInsets.fromLTRB(10, 10, 5, 12),
                          theme),
                      _questionAndAnswerWidgets(
                          'Grass not growing?',
                          'Starting from seeds require daily watering for best success.',
                          EdgeInsets.fromLTRB(10, 6, 5, 6),
                          theme)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CancelationBottomNavBar(
          hasDescription: true,
          onPressed: () => registry<Navigation>().pushReplacement(
            '/profile/subscription/why_are_you_canceling_screen',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
        titleString: 'Before You Cancel',
        leading: GestureDetector(
          onTap: () => registry<Navigation>().pop(),
          child: Icon(
            Icons.close,
            size: 32,
            key: Key('close_icon'),
          ),
        ),
        appBarForegroundColor: theme.colorScheme.onPrimary,
        appBarBackgroundColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primary,
        child: _buildBody(theme));
  }
}
