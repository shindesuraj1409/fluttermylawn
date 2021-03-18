import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/forgot_password/forgot_password_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/sign_up_screen/state.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/utils/regex_util.dart';
import 'package:my_lawn/utils/validators/email_validator.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with RouteMixin<ForgotPasswordScreen, String> {
  String _emailError;
  String _emailAddress;

  final TextEditingController _emailController = TextEditingController();
  ForgotPasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ForgotPasswordBloc();
    registry<AdobeRepository>().trackAppState(ForgotPasswordScreenAdobeState());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final email = routeArguments ?? '';
    _emailController.text = email;

    if (email.isValidEmail) {
      setState(() {
        _emailAddress = email;
        _emailError = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithAppBar(
      appBarElevation: 0,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            registry<Navigation>().push(
              '/auth/forgotpassword/emailsent',
              arguments: _emailAddress,
            );
          }
          if (state is ForgotPasswordError) {
            showSnackbar(
              context: context,
              text: state.errorMessage,
              duration: Duration(seconds: 2),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 48),
                      Text(
                        'Forgot Password',
                        style: theme.textTheme.headline1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Don’t worry we’ve got you! Enter your email and we’ll send you an email to reset the password.',
                          style: theme.textTheme.subtitle2.copyWith(
                            height: 1.5,
                          ),
                          key: Key('forgot_pass_subtext'),
                        ),
                      ),
                      SizedBox(height: 28),
                      TextInputField(
                        labelText: 'Email',
                        textCapitalization: TextCapitalization.none,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                        textInputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(allowedEmailCharactersRegex),
                          )
                        ],
                        validator: emailValidator,
                        onChanged: (email) {
                          if (email.isValidEmail) {
                            setState(() {
                              _emailAddress = email;
                              _emailError = null;
                            });
                          } else {
                            setState(() {
                              _emailAddress = email;
                              _emailError = 'Please enter a valid email';
                            });
                          }
                        },
                        errorText: _emailError,
                      ),
                      SizedBox(height: 60),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: RaisedButton(
                          child: Text(
                            'SEND RESET PASSWORD EMAIL',
                            style: theme.textTheme.bodyText1.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: (_emailAddress != null &&
                                  _emailError == null)
                              ? () {
                                  _bloc.add(
                                    ResetPasswordEmailRequested(_emailAddress),
                                  );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is ForgotPasswordLoading)
                Center(
                  child: ProgressSpinner(),
                )
            ],
          );
        },
      ),
    );
  }
}
