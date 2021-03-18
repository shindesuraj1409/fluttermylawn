import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class WelcomeScreen extends BaseScreen {
  final get_started_button =
      find.byValueKey('welcome_screen_get_started_button');
  final view_your_lawn_subscription_button =
      find.byValueKey('welcome_screen_view_your_lawn_subscription_button');
  final login_text = find.text('Already have an account? ');
  final login_link = find.text('LOG IN');

  // Login bottom sheet
  final bottom_login_sheet_cancel_button =
      find.byValueKey('welcome_screen_bottom_sheet_cancel_button');
  final bottom_login_sheet_continue_with_google_button =
      find.byValueKey('social_button_continue_with_google');
  final bottom_login_sheet_continue_with_facebook_button =
      find.byValueKey('social_button_continue_with_facebook');
  final bottom_login_sheet_continue_with_email_button =
      find.byValueKey('continue_with_email_button');
  final bottom_login_sheet_continue_with_apple_button =
      find.byValueKey('social_button_continue_with_apple');
  final bottom_login_sheet_options_logo = find.byValueKey('social_button_logo');

  // Image slider
  final slider_1 = find.text(
      'Tell us about your lawn and we’ll give you an easy-to-follow plan — created specifically for your yard.');
  final slider_2 = find.text(
      'With our application reminders, we will tell you the best time to apply your products. We take out the guesswork of when to apply.');
  final slider_3 = find.text(
      'Get inspiration and other tips on how to keep your lawn lush and beautiful.');
  final slider_4 = find.text(
      'Subscribe to your custom lawn care plan and we’ll ship you the products right to your door!');

  WelcomeScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyWelcomeScreenIsDisplayed() async {
    await verifyElementIsDisplayed(get_started_button);
    await verifyElementIsDisplayed(scotts_logo);
    await verifyElementIsDisplayed(my_lawn_image);
    await verifyElementIsDisplayed(by_word);
    await verifyElementIsDisplayed(view_your_lawn_subscription_button);
    await verifyElementIsDisplayed(login_text);
    await verifyElementIsDisplayed(login_link);
  }

  Future<void> verifySliderIsDisplayed() async {
    await verifyElementIsDisplayed(slider_1);
    await scrollElement(slider_1, dx: -73, dy: 0);
    await verifyElementIsDisplayed(slider_2);
    await scrollElement(slider_2, dx: -73, dy: 0);
    await verifyElementIsDisplayed(slider_3);
    await scrollElement(slider_3, dx: -73, dy: 0);
    await verifyElementIsDisplayed(slider_4);
    await scrollElement(slider_4, dx: -73, dy: 0);
  }

  Future<void> verifyLoginBottomSheetIsDisplayed() async {
    await verifyElementIsDisplayed(bottom_login_sheet_cancel_button);
    await verifyElementIsDisplayed(
        bottom_login_sheet_continue_with_google_button);
    await verifyElementIsDisplayed(find.descendant(
        of: bottom_login_sheet_continue_with_google_button,
        matching: bottom_login_sheet_options_logo));
    await verifyElementIsDisplayed(
        bottom_login_sheet_continue_with_facebook_button);
    await verifyElementIsDisplayed(find.descendant(
        of: bottom_login_sheet_continue_with_facebook_button,
        matching: bottom_login_sheet_options_logo));
    await verifyElementIsDisplayed(
        bottom_login_sheet_continue_with_email_button);
    await verifyElementIsDisplayed(find.descendant(
        of: bottom_login_sheet_continue_with_email_button,
        matching: bottom_login_sheet_options_logo));
    if (await driver.requestData('get_os') == 'ios') {
      await verifyElementIsDisplayed(
          bottom_login_sheet_continue_with_apple_button);
      await verifyElementIsDisplayed(find.descendant(
          of: bottom_login_sheet_continue_with_apple_button,
          matching: bottom_login_sheet_options_logo));
    }
  }

  Future<void> verifyGetStartedButtonIsDisplayed() async {
    await verifyElementIsDisplayed(get_started_button);
  }

  Future<void> verifyViewYourLawnSubscriptionButtonIsDisplayed() async {
    await verifyElementIsDisplayed(view_your_lawn_subscription_button);
  }

  Future<void> verifyLoginLinkIsDisplayed() async {
    await verifyElementIsDisplayed(login_text);
  }

  Future<void> clickOnViewYourLawnSubscriptionButton() async {
    await clickOn(view_your_lawn_subscription_button);
  }

  Future<void> clickOnGetStartedButton() async {
    await clickOn(get_started_button);
  }

  Future<void> clickOnLoginButton() async {
    await clickOn(login_link);
  }

  Future<void> clickOnContinueWithEmailButton() async {
    await clickOn(bottom_login_sheet_continue_with_email_button);
  }

  Future<void> clickOnBottomLoginSheetCancelButton() async {
    await clickOn(bottom_login_sheet_cancel_button);
  }
}
