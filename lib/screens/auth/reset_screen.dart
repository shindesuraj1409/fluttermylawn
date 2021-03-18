import 'package:flutter/material.dart';
import 'package:my_lawn/mixins/progress_tracker_mixin.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ProgressTrackerMixin {
  final TextEditingController _emailController = TextEditingController();

  String _lastError;

  final _didResetPassword = false;

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _emailController.text = ModalRoute.of(context).settings.arguments ?? '';
  }

  @override
  Widget build(BuildContext context) => BasicScaffoldWithSliverAppBar(
        titleString: 'Reset Password',
        child: SingleChildScrollView(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (_lastError != null)
                    Text(
                      _lastError,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).errorColor,
                          ),
                    ),
                  if (_didResetPassword)
                    Text(
                      'We have sent you an email with instructions for how to reset your password.',
                      textAlign: TextAlign.center,
                    ),
                  if (!_didResetPassword)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: TextInputField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email Address',
                      ),
                    ),
                  if (!_didResetPassword)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: RaisedButton(
                        child: Text('Reset Password'),
                        onPressed: inProgress
                            ? null
                            : () {
                                trackProgress(
                                  () async {
                                    //TODO Chirag
                                  },
                                );
                              },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
