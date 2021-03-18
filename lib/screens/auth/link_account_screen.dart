import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/login_screen/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/text_with_optional_actions_widget.dart';
import 'package:navigation/navigation.dart';

class LinkAccountScreen extends StatefulWidget {
  @override
  _LinkAccountScreenState createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen>
    with RouteMixin<LinkAccountScreen, String> {
  final FocusNode _passwordNode = FocusNode();

  var _password = '';
  String _passwordError;
  var _obscurePassword = true;
  String _email;

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = registry<LoginBloc>();
    _passwordNode.addListener(_passwordFocusNodeListener);
    adobeFamiliarScreenAnalytic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = routeArguments ?? '';
  }

  @override
  void dispose() {
    _passwordNode.removeListener(_passwordFocusNodeListener);
    _passwordNode.dispose();

    super.dispose();
  }

  void adobeFamiliarScreenAnalytic() {
    registry<AdobeRepository>().trackAppState(
      FamiliarEmailScreenAdobeState(),
    );
  }

  void _passwordFocusNodeListener() => setState(() {});

  bool _isValidPassword() {
    if (_password != null && _password.isNotEmpty) {
      setState(() {
        _passwordError = null;
      });
      return true;
    } else {
      setState(() {
        _passwordError = 'Enter a valid password.';
      });
      return false;
    }
  }

  Widget _buildFormWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextInputField(
          labelText: 'Password',
          initialValue: _password,
          focusNode: _passwordNode,
          errorText: _passwordError,
          padding: EdgeInsets.zero,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) => setState(() {
            _password = value;
          }),
          obscureText: _obscurePassword,
          suffixIcon: ObscurityToggle(
            isObscured: _obscurePassword,
            onTap: (isObscured) => setState(
              () => _obscurePassword = isObscured,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final _theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            padding: EdgeInsets.zero,
            child: Text(
              'FORGOT PASSWORD?',
              style: _theme.textTheme.bodyText1.copyWith(
                color: _theme.primaryColor,
              ),
            ),
            onPressed: () {
              registry<Navigation>().push(
                '/auth/forgotpassword',
                arguments: _email,
              );
            },
          ),
        ),
        SizedBox(
          height: 24,
        ),
        FractionallySizedBox(
          widthFactor: 1,
          child: RaisedButton(
            child: Text('Enable Social Login'),
            onPressed: () {
              if (_isValidPassword()) {
                _loginBloc.add(LinkAccountEvent(_email, _password));
              }
            },
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Align(
          alignment: Alignment.center,
          child: TextWithOptionalActions(
            children: [
              'Not your account? ',
              [
                'SIGN UP',
                '/auth/signup',
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      appBarElevation: 0,
      leading: BackButton(
        color: _theme.colorScheme.onBackground,
        onPressed: () => registry<Navigation>().pop(),
      ),
      child: BlocConsumer<LoginBloc, LoginState>(
        cubit: _loginBloc,
        listener: (prev, current) {
          if (current is LoginErrorState) {
            showSnackbar(
                context: context,
                text: current.errorMessage,
                duration: Duration(seconds: 2));
          } else if (current is LoginSuccessState) {
            registry<AuthenticationBloc>().add(LoginRequested());
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              if (state is LoginLoadingState)
                Center(
                  child: ProgressSpinner(),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 48),
                    Text(
                      'This Email Looks Familiar',
                      style: _theme.textTheme.headline1,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$_email has linked to an existing Scotts account. To enable social login with this account, please enter the Scotts password.',
                      style: _theme.textTheme.subtitle2,
                    ),
                    SizedBox(height: 24),
                    _buildFormWidget(context),
                    _buildActionButtons(context),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
