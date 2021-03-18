import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/check_email/check_email_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/login_screen/state.dart';
import 'package:my_lawn/utils/regex_util.dart';
import 'package:my_lawn/utils/validators/email_validator.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

class EnterEmailScreen extends StatefulWidget {
  @override
  _EnterEmailScreenState createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final FocusNode _emailNode = FocusNode();

  String _emailAddress = '';

  bool autoValidate = false;

  CheckEmailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CheckEmailBloc();

    adobeEmailScreenAnalytic();
  }

  void _onEmailChanged(String email) {
    _emailAddress = email;
  }

  void continueButton(CheckEmailState state) {
    if (_emailAddress.isNotEmpty && !(state is CheckEmailLoadingState)) {
      _bloc.checkIsEmailAvailable(_emailAddress);
    }
  }

  void adobeEmailScreenAnalytic() {
    registry<AdobeRepository>().trackAppState(
      EmailLoginScreenAdobeState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      isNotUsingWillPop: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: BlocConsumer<CheckEmailBloc, CheckEmailState>(
          cubit: _bloc,
          listener: (context, state) {
            if (state is CheckEmailSuccessState) {
              if (state.isEmailAvailable) {
                registry<Navigation>().push(
                  '/auth/createpassword',
                  arguments: state.email,
                );
              } else {
                registry<Navigation>().push(
                  '/auth/login',
                  arguments: state.email,
                );
              }
            } else if (state is CheckEmailErrorState) {
              showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: <Widget>[
                TextInputField(
                  labelText: 'Email',
                  focusNode: _emailNode,
                  autofocus: true,
                  autocorrect: false,
                  autovalidate: autoValidate,
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  enabled: !(state is CheckEmailLoadingState),
                  onChanged: _onEmailChanged,
                  validator: emailValidator,
                  textInputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(allowedEmailCharactersRegex),
                    )
                  ],
                ),
                Spacer(flex: 1),
                Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: RaisedButton(
                        child: Text('CONTINUE'),
                        onPressed: () {
                          if (_emailAddress.isValidEmail) {
                            continueButton(state);
                          } else {
                            setState(() {
                              autoValidate = true;
                            });
                          }
                        },
                      ),
                    ),
                    if (state is CheckEmailLoadingState)
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
            );
          },
        ),
      ),
    );
  }
}
