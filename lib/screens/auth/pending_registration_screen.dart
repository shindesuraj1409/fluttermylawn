import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/sign_up_screen/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_with_optional_actions_widget.dart';
import 'package:navigation/navigation.dart';

class PendingRegistrationScreen extends StatefulWidget {
  @override
  _PendingRegistrationScreenState createState() =>
      _PendingRegistrationScreenState();
}

class _PendingRegistrationScreenState extends State<PendingRegistrationScreen> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = registry<LoginBloc>();

    _sendAdobeAnalyticState();
  }

  void _sendAdobeAnalyticState() {
    registry<AdobeRepository>().trackAppState(
        NewsLetterSignUpScreenAdobeState()
    );
  }

  TextWithOptionalActions _buildAgreement(BuildContext context) {
    final theme = Theme.of(context);
    return TextWithOptionalActions(
      children: [
        'By continuing, you agree to the ',
        [
          'Conditions of Use',
          'https://scottsmiraclegro.com/terms-conditions?utm_source=mylawn&utm_medium=inapplink&utm_content=pendingregistration',
        ],
        ' for this application, including the terms of ',
        [
          'arbitration and class action waiver',
          'https://scottsmiraclegro.com/terms-conditions/#arbitration_waiver?utm_source=mylawn&utm_medium=inapplink&utm_content=pendingregistration',
        ],
        ', and consent to the collection and use of my personal information. See our ',
        [
          'Privacy Notice',
          'https://scottsmiraclegro.com/privacy?utm_source=mylawn&utm_medium=inapplink&utm_content=pendingregistration',
        ],
        ' to learn more about what ',
        [
          'information we collect',
          'https://scottsmiraclegro.com/privacy/#3_info_we_collect?utm_source=mylawn&utm_medium=inapplink&utm_content=pendingregistration',
        ],
        ' and your',
        [
          ' rights.',
          'https://scottsmiraclegro.com/privacy/#16_your_rights?utm_source=mylawn&utm_medium=inapplink&utm_content=pendingregistration',
        ],
      ],
      style: theme.textTheme.bodyText2.copyWith(
        height: 1.7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> argumentsMap =
        ModalRoute.of(context).settings.arguments;
    final email = argumentsMap['email'] ?? '';
    final regToken = argumentsMap['regToken'] ?? '';
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      titleString: 'One Last Thing',
      child: BlocConsumer<LoginBloc, LoginState>(
          cubit: _loginBloc,
          listener: (context, state) {
            if (state is LoginSuccessState) {
              registry<Navigation>().setRoot('/home');
            } else if (state is LoginErrorState) {
              showSnackbar(
                  context: context,
                  text: state.errorMessage,
                  duration: Duration(
                    seconds: 2,
                  ));
            }
          },

          builder: (context, state) {
            return Stack(
              children: [
                if (state is LoginLoadingState)
                  Center(
                    child: ProgressSpinner(
                      size: 40,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Would you like to subscribe to Scotts newsletter with $email and become a lawn expert? ',
                        style: theme.textTheme.subtitle2,
                      ),
                      SizedBox(
                        height: 128,
                      ),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            'SUBSCRIBE',
                            style: theme.textTheme.bodyText1.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () => _loginBloc
                              .completePendingRegistration(regToken, true),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: OutlineButton(
                          child: Text(
                            'LATER',
                            style: theme.textTheme.bodyText1.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                          onPressed: () => _loginBloc
                              .completePendingRegistration(regToken, false),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      _buildAgreement(context),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                        child: Text(
                          'By opting in, you are signing up to receive emails marketed by Scotts Miracle-Gro, its affiliates, and select partners with related tips, information, and promotions.',
                          style: theme.textTheme.bodyText2.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
