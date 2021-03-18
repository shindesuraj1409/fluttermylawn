import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/checkout/widgets/maybe_spinner_button_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class ConnectivityScreen extends StatefulWidget {
  @override
  _ConnectivityScreenState createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  bool checkingConnection = false;

  // Allow option to check connection manually
  // This needs to be done because in case of iOS
  // "onConnectivityChanged" doesn't gets fired: https://github.com/flutter/flutter/issues/20980 in some cases
  // So we're providing option to user to check their internet connection status manually here
  // in this screen
  void _checkConnection() async {
    try {
      setState(() => checkingConnection = true);

      final result = await (Connectivity().checkConnectivity());

      // If connected, pop up this screen
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        unawaited(registry<Navigation>().pop());
      }
      // Show snackbar error message
      else {
        showSnackbar(
          context: context,
          text: 'No Internet Connection available',
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      showSnackbar(
        context: context,
        text: 'Unable to get connection status. Try again',
        duration: Duration(seconds: 2),
      );
    } finally {
      setState(() => checkingConnection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithAppBar(
      backgroundColor: Styleguide.nearBackground(theme),
      appBarElevation: 0.0,
      appBarBackgroundColor: Styleguide.nearBackground(theme),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.signal_wifi_off,
            size: 48.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'No Internet Connection Available',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          FlatButton(
            child: MaybeSpinnerButton(
              spinner: checkingConnection,
              text: 'CHECK CONNECTION',
              spinnerText: 'CHECKING CONNECTION',
            ),
            onPressed: checkingConnection ? null : _checkConnection,
          )
        ],
      ),
    );
  }
}
