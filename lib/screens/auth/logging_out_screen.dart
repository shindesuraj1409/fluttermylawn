import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class LoggingOutScreen extends StatefulWidget {
  @override
  _LoggingOutScreenState createState() => _LoggingOutScreenState();
}

class _LoggingOutScreenState extends State<LoggingOutScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      registry<AuthenticationBloc>().add(PerformLogout());
    });
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
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/icons/logout.png',
                      width: 84,
                      height: 84,
                      key: Key('logout_submit_screen_loading_image'),
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
                'UNTIL NEXT TIME',
                style: theme.textTheme.bodyText2
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
              SizedBox(height: 8),
              Text(
                'Logging Out',
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
}
