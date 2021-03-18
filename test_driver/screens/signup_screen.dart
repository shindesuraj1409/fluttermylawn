import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'base_screen.dart';

class SignUpScreen extends BaseScreen {
  final CONTINUE_WITH_GOOGLE_BUTTON =
      find.byValueKey('social_button_continue_with_google');
  final CONTINUE_WITH_FACEBOOK_BUTTON =
      find.byValueKey('social_button_continue_with_facebook');
  final CONTINUE_WITH_APPLE_BUTTON =
      find.byValueKey('social_button_continue_with_apple');
  final CONTINUE_WITH_EMAIL_BUTTON =
      find.byValueKey('continue_with_email_button');
  final CONTINUE_AS_GUEST_BUTTON =
      find.byValueKey('signup_screen_continue_as_guest_button');
  final NEWSLETTER_CHECKBOX =
      find.byValueKey('signup_screen_subscribe_to_newsletter_checkbox');
  final NEWSLETTER_CHECKBOX_TEXT = 'signup_screen_newsletter_checkbox_text';
  final AGREEMENT_TEXT = find.byValueKey('signup_screen_agreement_text');
  final INFORMATION_AND_PROMOTION_TEXT =
  find.text('By opting in, you are signing up to receive emails marketed by Scotts Miracle-Gro, its affiliates, and select partners with related tips, information, and promotions.');

//  final CONDITIONS_OF_USE_LINK = 'Conditions of Use';
//  final ARBITRATION_AND_CLASS_ACTION_WAIVER_LINK = 'arbitration and class action waiver';
//  final PRIVACY_NOTICE_LINK = 'Privacy Notice';
//  final INFORMATION_WE_COLLECT_LINK = 'Privacy Notice';
//  final RIGHTS_LINK = 'rights.';

  final email_input = find.byValueKey('email_input');
  final continue_button = find.text('CONTINUE');
  final password_input = find.byValueKey('password_input');
  final sign_up_button = find.text('sign_up_button');

  SignUpScreen(FlutterDriver driver) : super(driver);

  Future<void> verifySignUpScreenIsDisplayed() async {
    await verifyElementIsDisplayed(scotts_logo);
    await verifyElementIsDisplayed(CONTINUE_WITH_GOOGLE_BUTTON);
    await verifyElementIsDisplayed(CONTINUE_WITH_FACEBOOK_BUTTON);
    await verifyElementIsDisplayed(CONTINUE_WITH_EMAIL_BUTTON);
    await verifyElementIsDisplayed(CONTINUE_AS_GUEST_BUTTON);
    await verifyElementIsDisplayed(NEWSLETTER_CHECKBOX);
    await verifyElementIsDisplayed(AGREEMENT_TEXT);

    if (Platform.isIOS) {
      await verifyElementIsDisplayed(CONTINUE_WITH_APPLE_BUTTON);
    }

    if (Platform.isAndroid) {
      await verifyAgreementIsDisplayed();
    }
  }

  Future<void> verifyAgreementIsDisplayed() async {
    await verifyElementIsDisplayed(AGREEMENT_TEXT);
    await verifyElementIsDisplayed(INFORMATION_AND_PROMOTION_TEXT);
  }

  Future<void> clickOnContinueWithEmailButton() async {
    await clickOn(CONTINUE_WITH_EMAIL_BUTTON);
  }

  Future<void> clickOnContinueWithGuestButton() async {
    await clickOn(CONTINUE_AS_GUEST_BUTTON);
  }

  Future<void> waitForSignUpScreenLoading() async {
    await waitForElementToLoad('key', 'continue_with_email_button');
  }
}
