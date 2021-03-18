import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/password_strength_box_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class AccountPasswordScreen extends StatefulWidget {
  @override
  _AccountPasswordScreenState createState() => _AccountPasswordScreenState();
}

class _AccountPasswordScreenState extends State<AccountPasswordScreen> {
  final _focusNode = FocusNode();

  var _oldPassword = '';
  var _password = '';
  var _isValidPassword = false;

  var _obscureOldPassword = true;
  var _obscurePassword = true;
  AccountBloc _bloc;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = registry<AccountBloc>();
  }

  void _focusNodeListener() => setState(() {});

  @override
  Widget build(BuildContext context) => BasicScaffoldWithSliverAppBar(
        titleString: 'Create New Password',
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextInputField(
                  labelText: 'Old Password',
                  initialValue: _oldPassword,
                  padding: EdgeInsets.zero,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) => setState(() {
                    _oldPassword = value;
                  }),
                  obscureText: _obscureOldPassword,
                  suffixIcon: ObscurityToggle(
                    isObscured: _obscureOldPassword,
                    onTap: (isObscured) => setState(
                      () => _obscureOldPassword = isObscured,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputField(
                  labelText: 'New Password',
                  initialValue: _password,
                  focusNode: _focusNode,
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
                if (_focusNode.hasFocus)
                  PasswordStrengthBox(
                    password: _password,
                    onUpdated: (isValid) =>
                        setState(() => _isValidPassword = isValid),
                  ),
                SizedBox(height: 24),
                BlocConsumer<AccountBloc, AccountState>(
                  cubit: _bloc,
                  listener: (context, state) {
                    switch (state.status) {
                      case AccountStatus.success:
                        registry<AuthenticationBloc>().add(UserUpdated());
                        registry<Navigation>().pop(state.successMessage);
                        break;
                      case AccountStatus.error:
                        showSnackbar(
                            context: context,
                            text: state.errorMessage,
                            duration: Duration(seconds: 2));
                        break;
                      default:
                        break;
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: RaisedButton(
                            child: Text('SET NEW PASSWORD'),
                            onPressed: _isValidPassword &&
                                    _oldPassword.isNotEmpty &&
                                    (state.status != AccountStatus.loading)
                                ? () => _bloc.changePassword(
                                      _oldPassword,
                                      _password,
                                    )
                                : null,
                          ),
                        ),
                        if (state.status == AccountStatus.loading)
                          Positioned(
                            top: 16,
                            right: 12,
                            child: ProgressSpinner(
                              size: 20,
                            ),
                          )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
