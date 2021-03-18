import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/sign_up_screen/state.dart';
import 'package:my_lawn/widgets/password_strength_box_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:navigation/navigation.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _passwordNode = FocusNode();
  var _password = '';
  var _obscurePassword = true;
  var _isValidPassword = false;
  var _didPasswordReset = false;

  @override
  void initState() {
    super.initState();

    _passwordNode.addListener(_passwordFocusNodeListener);

    registry<AdobeRepository>().trackAppState(CreateNewPasswordScreenAdobeState());
  }

  @override
  void dispose() {
    _passwordNode.removeListener(_passwordFocusNodeListener);
    _passwordNode.dispose();

    super.dispose();
  }

  void _didSetNewPassword() {
    // TODO: Change password.
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Password reset! Please login to continue.'),
      ),
    );
    setState(() {
      _didPasswordReset = true;
    });
  }

  void _passwordFocusNodeListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithAppBar(
      leading: IconButton(
        icon: Image.asset('assets/icons/cancel.png'),
        onPressed: () => registry<Navigation>().pop(),
      ),
      appBarElevation: 0,
      scaffoldKey: _scaffoldKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              'Create New Password',
              style: theme.textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Create a new, strong password for your account ',
                style: theme.textTheme.subtitle2,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextInputField(
              labelText: 'Password',
              initialValue: _password,
              focusNode: _passwordNode,
              padding: EdgeInsets.zero,
              textCapitalization: TextCapitalization.none,
              onChanged: (password) => setState(() {
                _password = password;
              }),
              obscureText: _obscurePassword,
              suffixIcon: ObscurityToggle(
                isObscured: _obscurePassword,
                onTap: (isObscured) => setState(
                  () => _obscurePassword = isObscured,
                ),
              ),
            ),
            if (_passwordNode.hasFocus)
              PasswordStrengthBox(
                password: _password,
                onUpdated: (isValid) =>
                    setState(() => _isValidPassword = isValid),
              ),
            SizedBox(
              height: _passwordNode.hasFocus ? 16 : 64,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: RaisedButton(
                child: Text(
                  'SET NEW PASSWORD',
                  style: theme.textTheme.bodyText1.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                onPressed: (_isValidPassword && !_didPasswordReset)
                    ? _didSetNewPassword
                    : null,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: OutlineButton(
                child: Text(
                  'BACK TO LOGIN',
                ),
                onPressed: () {
                  registry<Navigation>().setRoot(
                    '/auth/login',
                  );
                },
                borderSide: BorderSide(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
