import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/forgot_password/forgot_password_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';

import 'package:navigation/navigation.dart';

class ForgotPasswordEmailSentScreen extends StatefulWidget {
  @override
  _ForgotPasswordEmailSentScreenState createState() =>
      _ForgotPasswordEmailSentScreenState();
}

class _ForgotPasswordEmailSentScreenState
    extends State<ForgotPasswordEmailSentScreen>
    with RouteMixin<ForgotPasswordEmailSentScreen, String> {
  ForgotPasswordBloc _bloc;
  String _emailAddress;

  @override
  void initState() {
    super.initState();
    _bloc = ForgotPasswordBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _emailAddress = routeArguments ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffold(
      allowBackNavigation: false,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          cubit: _bloc,
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              showSnackbar(
                context: context,
                text: 'Reset password email sent',
                duration: Duration(seconds: 2),
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
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/email.png',
                          height: 64,
                          width: 64,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Email Has been Sent',
                          style: theme.textTheme.headline1,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'To reset your password, please check your inbox and follow the instruction.',
                          style: theme.textTheme.subtitle2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 104,
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: OutlineButton(
                            child: Text(
                              'BACK TO LOGIN',
                              style: theme.textTheme.bodyText1.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              registry<Navigation>().setRoot(
                                '/auth/login',
                                arguments: _emailAddress,
                                rootName: '/welcome',
                              );
                            },
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Didn’t receive the email? '),
                                TextButton(
                                    onPressed: () {
                                          _bloc.add(
                                            ResetPasswordEmailRequested(_emailAddress),
                                        );
                                },
                                    child: Text(
                                    'SEND AGAIN',
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
                    if (state is ForgotPasswordLoading)
                      Center(
                        child: ProgressSpinner(),
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
