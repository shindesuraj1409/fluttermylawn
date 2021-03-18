import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/widgets/password_strength_box_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';

class CreatePasswordScreen extends StatefulWidget {
  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen>
    with RouteMixin<CreatePasswordScreen, String> {
  final FocusNode _passwordNode = FocusNode();

  String _email;
  String _password = '';
  bool _subscribeToEmail = false;

  bool _isValidPassword = false;

  String _passwordError;
  bool _obscurePassword = true;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _passwordNode.addListener(_passwordFocusNodeListener);
    _bloc = registry<LoginBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = routeArguments;
  }

  @override
  void dispose() {
    _passwordNode.removeListener(_passwordFocusNodeListener);

    _passwordNode.dispose();
    super.dispose();
  }

  void _passwordFocusNodeListener() => setState(() {});

  bool _isPasswordValid(String password) =>
      !password.toLowerCase().contains(_email.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      appBarElevation: 0,
      titleString: 'Create Account',
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_passwordNode.hasFocus)
              PasswordStrengthBox(
                password: _password,
                onUpdated: (isValid) {
                  setState(() => _isValidPassword = isValid);
                },
              ),
            BlocConsumer<LoginBloc, LoginState>(
              cubit: _bloc,
              listener: (context, state) async {
                if (state is LoginSuccessState) {
                  registry<AuthenticationBloc>().add(SignUpRequested());
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
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 21),
                      Text(
                        'Your email address was not found, please add a password to create an account or go back to try another email address.',
                        style: theme.textTheme.bodyText2,
                      ),
                      SizedBox(height: 21),
                      TextInputField(
                        labelText: 'Password',
                        initialValue: _password,
                        focusNode: _passwordNode,
                        padding: EdgeInsets.zero,
                        enabled: !(state is LoginLoadingState),
                        textCapitalization: TextCapitalization.none,
                        onChanged: (password) {
                          final isPasswordValid = _isPasswordValid(password);
                          if (isPasswordValid) {
                            setState(() {
                              _password = password;
                              _passwordError = null;
                            });
                          } else {
                            setState(() {
                              _password = password;
                              _passwordError =
                                  'Cannot contain the same email used in this account';
                            });
                          }
                        },
                        errorText: _passwordError,
                        obscureText: _obscurePassword,
                        suffixIcon: ObscurityToggle(
                          isObscured: _obscurePassword,
                          onTap: (isObscured) => setState(
                            () => _obscurePassword = isObscured,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                      Row(
                        children: [
                          Checkbox(
                            key: Key('subscribeToEmail_checkbox'),
                              value: _subscribeToEmail,
                              onChanged: (subscribe) {
                                setState(() {
                                  _subscribeToEmail = subscribe;
                                });
                              }),
                          Expanded(
                            child: Text(
                              'Subscribe to Scotts newsletter to become a lawn expert',
                              style: theme.textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
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
                      Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: RaisedButton(
                              key: Key('sign_up_button'),
                              child: Text('SIGN UP'),
                              onPressed: (_passwordError == null &&
                                      _isValidPassword &&
                                      !(state is LoginLoadingState))
                                  ? () => _bloc.siteRegister(
                                      _email, _password, _subscribeToEmail)
                                  : null,
                            ),
                          ),
                          if (state is LoginLoadingState)
                            Positioned(
                              top: 16,
                              right: 12,
                              child: ProgressSpinner(
                                size: 20,
                              ),
                            )
                        ],
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
