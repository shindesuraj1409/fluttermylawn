import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localytics_plugin/localytics_plugin.dart';
import 'package:my_lawn/blocs/help_bloc/help_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_event.dart';
import 'package:my_lawn/blocs/help_bloc/help_state.dart';
import 'package:my_lawn/config/registry_config.dart';

import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_places_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/profile/settings/widgets/setting_menu_option_switch.dart';
import 'package:my_lawn/screens/profile/settings/widgets/setting_menu_option_with_link.dart';
import 'package:my_lawn/screens/profile/settings/widgets/setting_menu_spacer.dart';

import 'package:my_lawn/data/build_data.dart';
import 'package:my_lawn/data/device_data.dart';
import 'package:my_lawn/models/device_model.dart';
import 'package:my_lawn/services/analytic/resources.dart';
import 'package:my_lawn/services/analytic/screen_state_action/settings_screen/state.dart';
import 'package:my_lawn/utils/lifecycle_event_handler.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

import 'package:permission_handler/permission_handler.dart';

class AppSettingsScreen extends StatefulWidget {
  static const String title = 'App Settings';

  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen>
    with RouteMixin<AppSettingsScreen, String> {
  bool locationPermission;
  bool pushNotifications;
  bool smsPermission;
  String _deepLinkRoute;

  final int defaultCounter = 8;
  int onTapCounter = 0;

  @override
  void initState() {
    super.initState();
    registry<HelpBloc>().add(FetchHelpEvent());

    registry<AdobeRepository>().trackAppState(SettingsScreenAdobeState());

    checkLocationPermission();
    checkPushPermissions();
    checkSmsPermission();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
              checkLocationPermission();
              checkPushPermissions();
              checkSmsPermission();
            })));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deepLinkRoute = routeArguments;
  }

  void checkPushPermissions() async {
    final notification = await Permission.notification.isGranted;

    setState(() {
      pushNotifications = notification;
    });
  }

  void checkLocationPermission() async {
    final _locationPermission = await Permission.location.isGranted;

    setState(() {
      locationPermission = _locationPermission;
    });
  }

  //TODO: check and add if need sms permission button and logic
  void checkSmsPermission() {
    setState(() {
      smsPermission = false;
    });
  }

  void changePushPermission(bool value) async {
    final notificationPermissionStatus = await Permission.notification.status;

    if (notificationPermissionStatus.isGranted) {
      //open app settings to deny permissions
      //for android application it will restart application if permissions on
      //location will be removed
      await openAppSettings();
    } else if (!notificationPermissionStatus.isGranted) {
      final status = await Permission.notification.request();

      if (!status.isGranted) {
        await openAppSettings();
      }
    }

    final updatedNotificationPermissionStatus =
        await Permission.notification.status;
    if (updatedNotificationPermissionStatus.isGranted) {
      unawaited(registry<LocalyticsPlugin>().registerPushToken());
    }

    _updateAdobeUserProfileRepository(
        pushAttributeEnabledStr, pushNotifications);
  }

  void changeLocationPermission(bool value) async {
    final locationPermissionStatus = await Permission.location.status;

    if (locationPermissionStatus.isGranted) {
      //open app settings to deny permissions
      await openAppSettings();
      registry<AdobePlacesRepository>().stopMonitoringLocation();
    } else if (!locationPermissionStatus.isGranted) {
      final status = await Permission.location.request();

      if (!status.isGranted) {
        await openAppSettings();
        registry<AdobePlacesRepository>().startMonitoringLocation();
      }
    }

    _updateAdobeUserProfileRepository(
        locationAttributeEnabledStr, locationPermission);
  }

  //TODO: check and add if need sms permission button and logic
  void changeSmsPermission(bool value) async {
    setState(() {
      smsPermission = value;
    });
    _updateAdobeUserProfileRepository(smsAttributeEnabledStr, smsPermission);
  }

  void _updateAdobeUserProfileRepository(String attribute, bool value) {
    registry<AdobeUserProfileRepository>()
        .updateUserAttribute(attribute, value);
  }

  Widget buildHorizontalDivider() => Divider();

  Widget _buildDeviceAndBuild(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceData = busSnapshot<DeviceModel, DeviceData>();
    final buildData = busSnapshot<AppModel, BuildData>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${deviceData.manufacturer ?? '?'} ${deviceData.model ?? '?'}, ${deviceData.version ?? '?'}',
            textAlign: TextAlign.start,
            style: textTheme.caption,
          ),
          Text(
            '${buildData.version ?? '-'}+${buildData.build ?? '-'}',
            textAlign: TextAlign.end,
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }

  bool showDebug = false;

  void developerPageValidation() {
    if (onTapCounter == defaultCounter) {
      setState(() {
        showDebug = true;
      });
    }
  }

  void onTapValidation() {
    if (onTapCounter < defaultCounter) {
      onTapCounter++;
      return;
    }

    developerPageValidation();
  }

  void onLongValidation() {}

  final String conditionsDescription = 'Conditions of Use';

  final String privacyDescription = 'Privacy Notice';
  final String informationDescription = 'Do Not Sell My Information';

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      titleString: AppSettingsScreen.title,
      child: locationPermission == null
          ? ProgressSpinner()
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: add block for data switch
                SettingMenuSwitch(
                  imageName: 'assets/icons/push_notification.png',
                  description: 'Push Notifications',
                  value: pushNotifications,
                  onChanged: changePushPermission,
                ),
                buildHorizontalDivider(),

                //TODO: add block for data switch
                SettingMenuSwitch(
                  imageName: 'assets/icons/location_permission.png',
                  description: 'Location Permission',
                  value: locationPermission,
                  onChanged: changeLocationPermission,
                ),
                //TODO: add divider when enabling SMS Order Status Notification
                Visibility(
                  child: SettingMenuSwitch(
                    imageName: 'assets/icons/sms.png',
                    description: 'SMS Order Status Notification',
                    value: smsPermission,
                    onChanged: changeSmsPermission,
                  ),
                  visible: false,
                ),

                buildHorizontalDivider(),
                SettingMenuSpacer(),
                buildHorizontalDivider(),
                BlocConsumer<HelpBloc, HelpState>(
                    cubit: registry<HelpBloc>(),
                    listener: (context, state) {
                      if (_deepLinkRoute != null && state is HelpSuccessState) {
                        final article = state.helpList.firstWhere(
                            (element) => element.isAboutTheAppArticle == true);
                        registry<Navigation>()
                            .push('/ask/detail', arguments: article);
                      }
                    },
                    builder: (context, state) {
                      if (state is HelpSuccessState) {
                        final article = state.helpList.firstWhere(
                            (element) => element.isAboutTheAppArticle == true);

                        return SettingMenuOptionWithLink(
                            imageName: 'assets/icons/info.png',
                            description: article.title,
                            onTap: () {
                              registry<AdobeRepository>().trackAppState(
                                  SettingsSubScreenAdobeState(
                                      option: article.title.toLowerCase()));
                              registry<Navigation>()
                                  .push('/ask/detail', arguments: article);
                            });
                      } else {
                        return Container();
                      }
                    }),
                buildHorizontalDivider(),
                SettingMenuOptionWithLink(
                    imageName: 'assets/icons/terms_and_conditions.png',
                    description: conditionsDescription,
                    onTap: () {
                      registry<AdobeRepository>().trackAppState(
                          SettingsSubScreenAdobeState(
                              option: conditionsDescription.toLowerCase()));
                      registry<Navigation>()
                          .push('/profile/settings/termsconditions');
                    }),
                buildHorizontalDivider(),
                SettingMenuOptionWithLink(
                    imageName: 'assets/icons/privacy_policy.png',
                    description: privacyDescription,
                    onTap: () {
                      registry<AdobeRepository>().trackAppState(
                          SettingsSubScreenAdobeState(
                              option: privacyDescription.toLowerCase()));
                      registry<Navigation>().push('/profile/settings/privacy');
                    }),
                buildHorizontalDivider(),
                SettingMenuOptionWithLink(
                    imageName: 'assets/icons/shield.png',
                    description: informationDescription,
                    onTap: () {
                      registry<AdobeRepository>().trackAppState(
                          SettingsSubScreenAdobeState(
                              option: informationDescription.toLowerCase()));
                      registry<Navigation>()
                          .push('/profile/settings/dontsellinformation');
                    }),
                buildHorizontalDivider(),
                SettingMenuSpacer(),
                buildHorizontalDivider(),
                SettingMenuOptionWithLink(
                  imageName: 'assets/icons/app_feedback.png',
                  description: 'Give App Feedback',
                  onTap: () {
                    registry<AdobeRepository>().trackAppState(
                      AppFeedbackScreenAdobeState(),
                    );
                    registry<Navigation>().push('/profile/settings/feedback');
                  },
                ),
                buildHorizontalDivider(),
                if (showDebug)
                  SettingMenuOptionWithLink(
                    iconData: Icons.settings,
                    description: 'Developer Settings',
                    route: '/profile/settings/developer',
                  ),

                Expanded(
                  child: SettingMenuSpacer(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: onTapValidation,
                          onLongPress: onLongValidation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _buildDeviceAndBuild(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
