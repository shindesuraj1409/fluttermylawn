import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_places_repository.dart';
import 'package:my_lawn/screens/onboarding/permissions/widgets/cta_card_widget.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:navigation/navigation.dart';

class LocationSharingAskScreen extends StatelessWidget {

  void _showDialogAskingToEnablePermission() {
    final navigatorKey = GlobalKey<NavigatorState>();
    final context = navigatorKey.currentState.overlay.context;

    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => PlatformAwareAlertDialog(
        title: Text(
          'Permission needed',
        ),
        content: Text(
          "To use this feature please allow this app access to the location by changing it in the device's settings.",
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            textColor: theme.textTheme.subtitle1.color,
          ),
          FlatButton(
            onPressed: () {
              AppSettings.openAppSettings();
            },
            child: Text('Open Settings'),
            textColor: theme.primaryColor,
          )
        ],
      ),
    );
  }



  void onNegativeActionClicked() {
    registry<Navigation>().setRoot(
      '/quiz/submit',
      rootName: '/welcome',
    );
  }

  void onPositiveActionClicked() {
    registry<AdobePlacesRepository>().checkPermissionWithReaction(
      onGranted: () {
        registry<AdobePlacesRepository>().startMonitoringLocation();

        registry<Navigation>().setRoot(
          '/quiz/submit',
          rootName: '/welcome',
        );
      },
      onDenied: () {},
      onDeniedForever: _showDialogAskingToEnablePermission,
      onDefault: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 0.75,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/location_pin_icon.png',
                        width: 48,
                        height: 48,
                        key: Key('location_pin_icon'),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Take Advantage of Local Deals and Promotions',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline2.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Share your location to get notified of local deals & promotions.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.subtitle2.copyWith(
                          color: theme.colorScheme.onPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CTACard(
              onPositiveActionClicked: onPositiveActionClicked,
              onNegativeActionClicked: onNegativeActionClicked
            ),
          ),
        ],
      ),
    );
  }
}
