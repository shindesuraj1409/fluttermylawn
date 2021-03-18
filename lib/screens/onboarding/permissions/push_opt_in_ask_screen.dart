import 'package:flutter/material.dart';
import 'package:localytics_plugin/localytics_plugin.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/onboarding/permissions/widgets/cta_card_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/settings_screen/state.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';

class PushOptInAskScreen extends StatefulWidget {
  @override
  _PushOptInAskScreenState createState() => _PushOptInAskScreenState();
}

class _PushOptInAskScreenState extends State<PushOptInAskScreen> {
  PermissionStatus locationPermissionStatus;

  @override
  void initState() {
    super.initState();
    _getPermissionStatuses();
  }

  void _getPermissionStatuses() async {
    locationPermissionStatus = await Permission.location.status;
  }

  void adobeAnalyticCall() {
    registry<AdobeRepository>()
        .trackAppState(SoftAskScreenAdobeState(askType: 'location'));
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
              padding: const EdgeInsets.fromLTRB(16, 112, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Stay on Task',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline2.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Receive helpful lawn care reminders and exclusive offers sent right to your phone.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.subtitle2.copyWith(
                      color: theme.colorScheme.onPrimary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Expanded(
                    child: Image.asset(
                      'assets/images/push_notification_screenshot.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CTACard(
              onPositiveActionClicked: () async {
                // Show Push Notification permission dialog
                final status = await Permission.notification.request();
                if (status.isGranted) {
                  unawaited(registry<LocalyticsPlugin>().registerPushToken());
                }
                // TODO : Based on permission status update in our backend about user's push opt-in status
                // For now, we're just taking them to next screen directly
                adobeAnalyticCall();
                if (locationPermissionStatus.isGranted) {
                  unawaited(registry<Navigation>().setRoot(
                    '/quiz/submit',
                    rootName: '/welcome',
                  ));
                } else {
                  unawaited(
                      registry<Navigation>().push('/quiz/softask/location'));
                }
              },
              onNegativeActionClicked: () {
                adobeAnalyticCall();
                if (locationPermissionStatus.isGranted) {
                  registry<Navigation>().setRoot(
                    '/quiz/submit',
                    rootName: '/welcome',
                  );
                } else {
                  unawaited(
                      registry<Navigation>().push('/quiz/softask/location'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
