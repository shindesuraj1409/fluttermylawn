import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/login_screen/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with RouteMixin<LoginScreen, String> {
  final FocusNode _passwordNode = FocusNode();

  String _password;
  String _emailAddress;
  String _passwordError;

  bool _obscurePassword = true;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<LoginBloc>();

    adobeWelcomeBackScreenAnalytic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _emailAddress = routeArguments;
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  void adobeWelcomeBackScreenAnalytic() {
    registry<AdobeRepository>().trackAppState(
      WelcomeBackScreenAdobeState(),
    );
  }

  bool _isValidPassword(String password) {
    if (password != null && password.isNotEmpty) {
      setState(() {
        _passwordError = null;
        _password = password;
      });
      return true;
    } else {
      setState(() {
        _passwordError = 'Enter a valid password.';
        _password = password;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      isNotUsingWillPop: true,
      titleString: 'Welcome Back',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: BlocConsumer<LoginBloc, LoginState>(
          cubit: _bloc,
          listener: (context, state) async {
            if (state is LoginSuccessState) {
              registry<AuthenticationBloc>().add(LoginRequested());
            } else if (state is LoginErrorState) {
              showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextInputField(
                  initialValue: _emailAddress,
                  labelText: 'Email',
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  onChanged: null,
                  suffixIcon: Image.asset(
                    'assets/icons/completed.png',
                  ),
                  enabled: false,
                  disabledColor: theme.textTheme.subtitle1.color,
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputField(
                  labelText: 'Password',
                  errorText: _passwordError,
                  initialValue: _password,
                  focusNode: _passwordNode,
                  padding: EdgeInsets.zero,
                  textCapitalization: TextCapitalization.none,
                  enabled: !(state is LoginLoadingState),
                  onChanged: _isValidPassword,
                  obscureText: _obscurePassword,
                  suffixIcon: ObscurityToggle(
                    isObscured: _obscurePassword,
                    onTap: (isObscured) => setState(
                      () => _obscurePassword = isObscured,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      'FORGOT PASSWORD?',
                      style: theme.textTheme.bodyText1.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      registry<Navigation>().push(
                        '/auth/forgotpassword',
                        arguments: _emailAddress,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: RaisedButton(
                            child: Text('LOG IN'),
                            onPressed: (_passwordError == null &&
                                    _password != null &&
                                    _password.isNotEmpty &&
                                    !(state is LoginLoadingState))
                                ? () =>
                                    _bloc.siteLogin(_emailAddress, _password)
                                : null),
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
