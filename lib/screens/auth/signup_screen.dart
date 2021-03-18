import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/sign_up_screen/state.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/social_buttons_widgets.dart';
import 'package:my_lawn/widgets/text_with_optional_actions_widget.dart';
import 'package:navigation/navigation.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _subscribeToNewsLetter = false;

  @override
  void initState() {
    registry<AdobeRepository>().trackAppState(SignUpScreenAdobeState());

    super.initState();
  }

  Widget _buildSocialLoginButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: SocialButtons(
        appleSignInTapped: () =>
            registry<LoginBloc>().socialLogin(SocialService.APPLE),
        facebookLoginTapped: () =>
            registry<LoginBloc>().socialLogin(SocialService.FB),
        googleSignInTapped: () =>
            registry<LoginBloc>().socialLogin(SocialService.GOOGLE),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            key: Key('signup_screen_subscribe_to_newsletter_checkbox'),
            activeColor: theme.primaryColor,
            value: _subscribeToNewsLetter,
            onChanged: (newValue) {
              setState(() => _subscribeToNewsLetter = newValue);
            },
          ),
          Expanded(
            child: Text(
              'Subscribe to Scotts newsletter to become a lawn expert',
              style: theme.textTheme.bodyText2,
              key: Key('signup_screen_newsletter_checkbox_text'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: _buildAgreement(context),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 36),
          child: Text(
            'By opting in, you are signing up to receive emails marketed by Scotts Miracle-Gro, its affiliates, and select partners with related tips, information, and promotions.',
            style: theme.textTheme.bodyText2.copyWith(
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            key: Key('signup_screen_agreement_text'),
          ),
        ),
      ],
    );
  }

  TextWithOptionalActions _buildAgreement(BuildContext context) {
    final theme = Theme.of(context);
    return TextWithOptionalActions(
      children: [
        'By continuing, you agree to the ',
        [
          'Conditions of Use',
          'https://scottsmiraclegro.com/terms-conditions?utm_source=mylawn&utm_medium=inapplink&utm_content=signup',
        ],
        ' for this application, including the terms of ',
        [
          'arbitration and class action waiver',
          'https://scottsmiraclegro.com/terms-conditions/#arbitration_waiver?utm_source=mylawn&utm_medium=inapplink&utm_content=signup',
        ],
        ', and consent to the collection and use of my personal information. See our ',
        [
          'Privacy Notice',
          'https://scottsmiraclegro.com/privacy?utm_source=mylawn&utm_medium=inapplink&utm_content=signup',
        ],
        ' to learn more about what ',
        [
          'information we collect',
          'https://scottsmiraclegro.com/privacy/#3_info_we_collect?utm_source=mylawn&utm_medium=inapplink&utm_content=signup',
        ],
        ' and your',
        [
          ' rights.',
          'https://scottsmiraclegro.com/privacy/#16_your_rights?utm_source=mylawn&utm_medium=inapplink&utm_content=signup',
        ],
      ],
      style: theme.textTheme.bodyText2.copyWith(
        height: 1.7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      appBarElevation: 0,
      child: BlocConsumer<LoginBloc, LoginState>(
        cubit: registry<LoginBloc>(),
        listener: (context, state) {
          if (state is LoginSuccessState) {
            registry<AuthenticationBloc>().add(LoginRequested());
          } else if (state is PendingRegistrationState) {
            registry<Navigation>().push(
              '/auth/pendingregistration',
              arguments: {'email': state.email, 'regToken': state.regToken},
            );
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
          return Stack(
            children: [
              if (state is LoginLoadingState)
                Center(
                  child: ProgressSpinner(size: 40),
                ),
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/scotts_logo.png',
                    width: 64,
                    height: 32,
                    key: Key('scotts_logo'),
                  ),
                  _buildSocialLoginButtons(context),
                  _buildCheckbox(context),
                  FlatButton(
                    key: Key('signup_screen_continue_as_guest_button'),
                    child: Text('CONTINUE AS GUEST'),
                    onPressed: () {
                      registry<AuthenticationBloc>().add(ContinueAsGuest());
                    },
                  ),
                  _buildFooterWidget(context),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
