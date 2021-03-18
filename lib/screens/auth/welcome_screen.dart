import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/auth/widgets/onboarding_lawn_plan_carousel_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/widgets/env_switching_dialog_widget.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int tapCounter = 0;

  void getStartedButton() {
    registry<AdobeRepository>().setACPCoreLogLevel();
    registry<AdobeRepository>().trackAppState(LawnLookState());

    registry<Navigation>().push('/quiz');
  }

  void _showEnvSwitchingDialog() async {
    final environmentSelected =
        await registry<EnvironmentConfig>().getSelectedEnvironment();
    showEnvironmentSwitchingDialog(
      context,
      environmentSelected,
      allowCopyingTransId: true,
    );
  }

  void _onLogoTapped() {
    if (tapCounter > 8) {
      _showEnvSwitchingDialog();
      return;
    }
    setState(() {
      tapCounter += 1;
    });
  }

  Widget _buildHeaderImageBackground(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/grass_background.png',
          width: double.infinity,
          height: screenHeight * 0.3,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 134,
                height: 32,
                child: Image.asset(
                  'assets/images/my_lawn.png',
                  fit: BoxFit.contain,
                  key: Key('my_lawn_image'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                child: Text(
                  'by',
                  style: theme.textTheme.bodyText2.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: _onLogoTapped,
                child: Image.asset(
                  'assets/images/scotts_logo.png',
                  fit: BoxFit.contain,
                  width: 64,
                  height: 32,
                  key: Key('scotts_logo'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildGetStartedButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: RaisedButton(
              key: Key('welcome_screen_get_started_button'),
              child: Text('GET STARTED'),
              onPressed: getStartedButton,
            ),
          ),
          SizedBox(height: 16),
          FractionallySizedBox(
            widthFactor: 1,
            child: OutlineButton(
              key: Key('welcome_screen_view_your_lawn_subscription_button'),
              child: Text(
                'VIEW YOUR LAWN SUBSCRIPTION',
                textAlign: TextAlign.center,
              ),
              onPressed: () => buildLoginBottomCard(context),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          top: false,
          child: BlocConsumer<LoginBloc, LoginState>(
            cubit: registry<LoginBloc>(),
            listener: (context, state) {
              if (state is LoginSuccessState) {
                registry<AuthenticationBloc>().add(LoginRequested());
              } else if (state is PendingRegistrationState) {
                Navigator.of(context).pop();
                registry<Navigation>().push('/auth/pendingregistration',
                    arguments: {
                      'email': state.email,
                      'regToken': state.regToken
                    });
              } else if (state is LoginErrorState) {
                showSnackbar(
                  context: context,
                  text: state.errorMessage,
                  duration: Duration(
                    seconds: 2,
                  ),
                );
              } else if (state is LoginLinkAccountState) {
                registry<Navigation>()
                    .push('/auth/linkaccount', arguments: state.email);
              }
            },
            builder: (context, state) {
              return Stack(children: [
                if (state is LoginLoadingState)
                  Center(
                    child: ProgressSpinner(
                      size: 40,
                    ),
                  ),
                Column(
                  children: [
                    _buildHeaderImageBackground(context),
                    OnboardingLawnPlanCarousel(),
                    _buildGetStartedButtons(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? '),
                          TextButton(
                            onPressed: () => buildLoginBottomCard(context),
                            child: Text(
                              'LOG IN',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
