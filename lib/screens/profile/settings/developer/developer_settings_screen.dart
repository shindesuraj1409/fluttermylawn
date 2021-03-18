import 'dart:io';

import 'package:bus/bus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/app_data.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/screens/profile/settings/abstract_settings_screen.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/widgets/env_switching_dialog_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:device_info/device_info.dart';

class DeveloperSettingsScreen extends AbstractSettingsScreen {
  final Logger _logger = registry<Logger>();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  final _user = registry.call<AuthenticationBloc>().state.user;
  final _transId = registry.call<String>(name: RegistryConfig.TRANS_ID);

  void _sendLogs(BuildContext context) async {
    AndroidDeviceInfo _androidInfo;
    IosDeviceInfo _iosInfo;
    final lawnData = await registry<SessionManager>().getLawnData();

    try {
      if (Platform.isAndroid) {
        _androidInfo = await _deviceInfo.androidInfo;
      } else {
        _iosInfo = await _deviceInfo.iosInfo;
      }

      await FlutterEmailSender.send(Email(
        recipients: ['consumer.services@scotts.com'],
        subject: 'My Lawn Log',
        body:
            'customerId: ${_user.customerId}\n\ntransId: $_transId\n\nemail: ${_user?.email ?? 'not registered user'}\n\nplatform: ${Platform.operatingSystem}\n\nosVersion: ${Platform.operatingSystemVersion}\n\nmanufacturer: ${Platform.isAndroid ? _androidInfo.manufacturer : 'Apple'}\n\nbrand: ${Platform.isAndroid ? _androidInfo.brand : 'Apple'}\n\ndevice: ${Platform.isAndroid ? _androidInfo.model : _iosInfo.model}\n\nis physical device: ${Platform.isAndroid ? _androidInfo.isPhysicalDevice : _iosInfo.isPhysicalDevice}\n\nlawn data: ${lawnData.toString()}',
      ));
    } on PlatformException catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error sending email'),
                content: Text(
                    'We were unable to email logs to the developer. Does this device have an email account configured?'),
                actions: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: registry<Navigation>().pop,
                  )
                ],
              ));
    } catch (e) {
      _logger.e(e);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  @override
  List<Widget> buildItems(BuildContext context) => [
        busStreamBuilder<AppModel, AppData>(
          builder: (context, appModel, appData) => buildSwitch(
            context: context,
            iconData: Icons.directions_run,
            description: 'First Run',
            value: appData.isFirstRun,
            onChanged: (enabled) => busPublish<AppModel, AppData>(
              publisher: (data) => AppData(appData: data, isFirstRun: enabled),
            ),
          ),
        ),
        buildHorizontalDivider(),
        buildLink(
          context: context,
          iconData: Icons.feedback,
          description: 'Email Logs to Developers',
          onTap: () => _sendLogs(context),
        ),
        buildHorizontalDivider(),
        buildLink(
          context: context,
          iconData: Icons.navigation,
          description: 'Available Routes',
          route: '/profile/settings/developer/routes',
        ),
        buildHorizontalDivider(),
        buildLink(
            context: context,
            iconData: Icons.face,
            description: 'Copy TransId',
            onTap: () async {
              final transId = _transId;
              await Clipboard.setData(ClipboardData(text: transId));
              showSnackbar(
                context: context,
                text: 'TransId Copied',
                duration: Duration(seconds: 2),
              );
            }),
        buildHorizontalDivider(),
        buildLink(
            context: context,
            iconData: Icons.fingerprint,
            description: 'Copy CustomerId',
            onTap: () async {
              final customerId = _user.customerId;
              await Clipboard.setData(ClipboardData(text: customerId));
              showSnackbar(
                context: context,
                text: 'CustomerId Copied',
                duration: Duration(seconds: 2),
              );
            }),
        buildHorizontalDivider(),
        buildLink(
          context: context,
          iconData: Icons.error_outline_outlined,
          description: 'Launching Exception',
          onTap: () => throw Exception(
              'This is a forced exception, You have been warned!'),
        ),
        buildLink(
          context: context,
          iconData: Icons.error_outline_outlined,
          description: 'Crashes App',
          onTap: () =>
              MethodChannel('crash.flutter.dev/fake').invokeMethod('crashApp'),
        ),
        buildLink(
          context: context,
          iconData: Icons.error_outline_outlined,
          description: 'Red Screen',
          route: '/profile/settings/developer/error',
        ),
        buildLink(
          context: context,
          iconData: Icons.error_outline_outlined,
          description: 'Crashlytics Crash',
          onTap: () => FirebaseCrashlytics.instance.crash(),
        ),
        buildLink(
            context: context,
            iconData: Icons.switch_left,
            description: 'Switch environment',
            onTap: () async {
              final environmentSelected =
                  await registry<EnvironmentConfig>().getSelectedEnvironment();
              showEnvironmentSwitchingDialog(context, environmentSelected);
            }),
      ];

  @override
  String get title => 'Developer Settings';
}
