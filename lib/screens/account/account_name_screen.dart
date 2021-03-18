import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/utils/regex_util.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class AccountNameScreen extends StatefulWidget {
  @override
  _AccountNameScreenState createState() => _AccountNameScreenState();
}

class _AccountNameScreenState extends State<AccountNameScreen>
    with RouteMixin<AccountNameScreen, AccountBloc> {
  String _firstName;
  String _lastName;
  User _user;
  AccountBloc _bloc;

  @override
  void initState() {
    super.initState();

    _user = registry<AuthenticationBloc>().state.user;

    _firstName = _user.firstName ?? '';
    _lastName = _user.lastName ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = routeArguments;
  }

  bool _canSave() {
    return (_firstName.isNotEmpty && _firstName.trim() != _user.firstName) ||
        (_lastName.isNotEmpty && _lastName.trim() != _user.lastName);
  }

  @override
  Widget build(BuildContext context) => BasicScaffoldWithSliverAppBar(
        titleString: 'Change Name',
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
                      labelText: 'First Name',
                      initialValue: _firstName,
                      textInputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(
                          symbolsAndEmojiRegex,
                        )),
                      ],
                      onChanged: (value) => setState(() => _firstName = value),
                    ),
                    SizedBox(height: 12),
                    TextInputField(
                      labelText: 'Last Name',
                      initialValue: _lastName,
                      textInputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(
                          symbolsAndEmojiRegex,
                        )),
                      ],
                      onChanged: (value) => setState(() => _lastName = value),
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
                                      firstName: _firstName,
                                      lastName: _lastName,
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
