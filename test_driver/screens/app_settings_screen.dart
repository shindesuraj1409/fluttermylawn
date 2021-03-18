import 'package:flutter_driver/flutter_driver.dart';

import '../stub/stub.dart';
import 'base_screen.dart';

class AppSettingScreen extends BaseScreen {
  final header_label = find.text('App Settings');

  final push_notification_icon = find.byValueKey('push_notifications_icon');
  final push_notification_label = find.text('Push Notifications');
  final push_notification_switch = find.byValueKey('push_notifications');

  final location_permission_icon = find.byValueKey('location_permission_icon');
  final location_permission_label = find.text('Location Permission');
  final location_permission_switch = find.byValueKey('location_permission');

  final dark_mode_icon = find.byValueKey('dark_mode_icon');
  final dark_mode_label = find.text('Dark Mode');
  final dark_mode_switch = find.byValueKey('dark_mode');

  final about_my_lawn_app_icon = find.byValueKey('about_the_mylawn_app_icon');
  final about_my_lawn_app_label = find.text('About the MyLawn App');
  final about_my_lawn_app_button =
      find.byValueKey('about_the_mylawn_app_goto_icon');

  final condition_of_use_icon = find.byValueKey('conditions_of_use_icon');
  final condition_of_use_label = find.text('Conditions of Use');
  final condition_of_use_button =
      find.byValueKey('conditions_of_use_goto_icon');

  final privacy_notice_icon = find.byValueKey('privacy_notice_icon');
  final privacy_notice_label = find.text('Privacy Notice');
  final privacy_notice_button = find.byValueKey('privacy_notice_goto_icon');

  final do_not_sell_my_information_icon =
      find.byValueKey('do_not_sell_my_information_icon');
  final do_not_sell_my_information_label =
      find.text('Do Not Sell My Information');
  final do_not_sell_my_information_button =
      find.byValueKey('do_not_sell_my_information_goto_icon');

  final give_app_feedback_icon = find.byValueKey('give_app_feedback_icon');
  final give_app_feedback_label = find.text('Give App Feedback');
  final give_app_feedback_button =
      find.byValueKey('give_app_feedback_goto_icon');

  final developer_setting_icon = find.byValueKey('developer_settings_icon');
  final developer_setting_label = find.byValueKey('Developer Settings');
  final developer_setting_button =
      find.byValueKey('developer_settings_goto_icon');

  AppSettingScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyAppSettingScreenIsDisplayed() async {
    // Verify "APP SETTINGS Screen" should be displayed
    await verifyElementIsDisplayed(header_label);
    await verifyElementIsDisplayed(push_notification_icon);
    await verifyElementIsDisplayed(push_notification_label);
    await verifyElementIsDisplayed(push_notification_switch);
    await verifyElementIsDisplayed(location_permission_icon);
    await verifyElementIsDisplayed(location_permission_label);
    await verifyElementIsDisplayed(location_permission_switch);
    await verifyElementIsDisplayed(about_my_lawn_app_icon);
    await verifyElementIsDisplayed(about_my_lawn_app_label);
    await verifyElementIsDisplayed(about_my_lawn_app_button);
    await verifyElementIsDisplayed(condition_of_use_icon);
    await verifyElementIsDisplayed(condition_of_use_label);
    await verifyElementIsDisplayed(condition_of_use_button);
    await verifyElementIsDisplayed(privacy_notice_icon);
    await verifyElementIsDisplayed(privacy_notice_label);
    await verifyElementIsDisplayed(privacy_notice_button);
    await verifyElementIsDisplayed(do_not_sell_my_information_icon);
    await verifyElementIsDisplayed(do_not_sell_my_information_label);
    await verifyElementIsDisplayed(do_not_sell_my_information_button);
    await verifyElementIsDisplayed(give_app_feedback_icon);
    await verifyElementIsDisplayed(give_app_feedback_label);
    await verifyElementIsDisplayed(give_app_feedback_button);
  }

  Future<void> clickOnPushNotificationsSwitch() async {
    await clickOn(push_notification_switch);
  }

  Future<void> clickOnLocationPermissionSwitch() async {
    await clickOn(location_permission_switch);
  }

  Future<void> clickOnAboutMyLawnAppButton() async {
    await clickOn(about_my_lawn_app_button);
  }

  Future<void> clickOnConditionsOfUseButton() async {
    await clickOn(condition_of_use_button);
  }

  Future<void> clickOnPrivacyNoticeButton() async {
    await clickOn(privacy_notice_button);
  }

  Future<void> clickOnGiveAppFeedbackButton() async {
    await clickOn(give_app_feedback_button);
  }

  Future<void> clickOnDoNotSellMyInfoButton() async {
    await clickOn(do_not_sell_my_information_button);
  }

  Future<void> clickOnDeveloperSettingsButton() async {
    await clickOn(developer_setting_button);
  }

  Future<void> startMonitoring() async {
    verifyFunction('startMonitoringLocation');
  }
}
