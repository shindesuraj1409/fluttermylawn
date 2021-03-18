import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/utils/regex_util.dart';
import 'package:my_lawn/utils/validators/email_validator.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

class AccountEmailScreen extends StatefulWidget {
  @override
  _AccountEmailScreenState createState() => _AccountEmailScreenState();
}

class _AccountEmailScreenState extends State<AccountEmailScreen>
    with RouteMixin<AccountEmailScreen, AccountBloc> {
  String _emailAddress;
  User _user;
  AccountBloc _bloc;

  @override
  void initState() {
    super.initState();

    _user = registry<AuthenticationBloc>().state.user;
    _emailAddress = _user.email ?? '';
  }

  bool _canSave() {
    return _emailAddress.isNotEmpty &&
        _emailAddress.isValidEmail &&
        _emailAddress.trim() != _user.email;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = routeArguments;
  }

  @override
  Widget build(BuildContext context) => BasicScaffoldWithSliverAppBar(
        titleString: 'Change Email Address',
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AccountBloc, AccountState>(
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextInputField(
                      labelText: 'Email',
                      initialValue: _emailAddress,
                      textCapitalization: TextCapitalization.none,
                      textInputType: TextInputType.emailAddress,
                      autovalidate: true,
                      validator: emailValidator,
                      textInputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(allowedEmailCharactersRegex),
                        )
                      ],
                      onChanged: (value) =>
                          setState(() => _emailAddress = value),
                    ),
                    SizedBox(height: 24),
                    Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: RaisedButton(
                            key: Key('save_button'),
                            child: Text('SAVE'),
                            onPressed: _canSave() &&
                                    (state.status != AccountStatus.loading)
                                ? () => _bloc.updateAccount(
                                      email: _emailAddress,
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
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}
