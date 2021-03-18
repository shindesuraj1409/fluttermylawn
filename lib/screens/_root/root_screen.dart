import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  void _navigateElsewhere() {
    final state = registry<AuthenticationBloc>().state;
    final redirectRoute = state.isLoggedOut ? '/welcome' : '/initialize';
    registry<Navigation>().setRoot(redirectRoute);
  }

  @override
  void initState() {
    super.initState();
    registry<AuthenticationBloc>().add(AppStarted());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigateElsewhere();
  }

  @override
  Widget build(BuildContext context) => BasicScaffold(
        child: Container(
          child: Center(
            child: ProgressSpinner(),
          ),
        ),
        allowBackNavigation: false,
      );
}
