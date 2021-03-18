import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_condition_screen_data.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';

class UserInitializationScreen extends StatefulWidget {
  @override
  _UserInitializationScreenState createState() =>
      _UserInitializationScreenState();
}

class _UserInitializationScreenState extends State<UserInitializationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      final user = registry<AuthenticationBloc>().state.user;
      if (user != null && user.recommendationId == null) {
        registry<Navigation>()
            .push('/quiz', arguments: LawnConditionScreenData(canPop: false));
      } else if (user != null && user.recommendationId != null) {
        registry<Navigation>().setRoot('/home');
      } else {
        registry<Navigation>().setRoot('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryVariant,
      body: Center(
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
                      color: theme.colorScheme.surface, shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/images/lawn_mower_loading.png',
                    width: 84,
                    height: 84,
                    key: Key('user_initialization_screen_loading_image'),
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
              'HANG TIGHT',
              style: theme.textTheme.bodyText2
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
            SizedBox(height: 8),
            Text(
              'Fetching Your Lawn',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline2
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
