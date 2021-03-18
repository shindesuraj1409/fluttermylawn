import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/quiz_modify_screen_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class QuizModifyScreen extends StatefulWidget {
  @override
  _QuizModifyScreenState createState() => _QuizModifyScreenState();
}

class _QuizModifyScreenState extends State<QuizModifyScreen>
    with RouteMixin<QuizModifyScreen, QuizModifyScreenData> {
  String subtitle = 'You Got the Same Plan!';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final quantity = routeArguments.quantity;
    subtitle = quantity == 0
        ? 'You Got the Same Plan!'
        : 'Got [$quantity] Product ${quantity == 1 ? 'Update' : 'Updates'}!';
    _redirectToCheckout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryVariant,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/icons/all_set.png',
                      width: 84,
                      height: 84,
                      key: Key('quiz_submit_screen_loading_image'),
                    ),
                  ),
                  ProgressSpinner(
                    size: 128,
                    strokeWidth: 8,
                    color: Styleguide.color_green_4,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'YOU ARE ALL SET',
                style: theme.textTheme.bodyText2
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headline2
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _redirectToCheckout() async {
    //3 seconds is defined on the mockup as the time the message is being shown
    await Future.delayed(Duration(seconds: 3));
    if (registry<SubscriptionBloc>().state.status.isPreview &&
        registry<SubscriptionBloc>().state.data.isNotEmpty) {
      unawaited(registry<Navigation>()
          .pushReplacement('/profile/update_plan_screen', arguments: {
        'title': 'Update Subscription',
        'description': 'Here are your new product recommendations!'
      }));
    } else {
      unawaited(registry<Navigation>().pushReplacement('/profile/editlawn'));
    }
  }
}
