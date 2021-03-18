import 'dart:io';

import 'package:flutter_driver/src/driver/driver.dart';

import 'screens.dart';

class ForgotPasswordScreen extends BaseScreen {
  ForgotPasswordScreen(FlutterDriver driver) : super(driver);

  final screen_header = find.text('Forgot Password');
  final forgot_password_subtext = find.byValueKey('forgot_pass_subtext');
  final email_input = find.byValueKey('email_input');
  final send_reset_password_email = find.text('SEND RESET PASSWORD EMAIL');

  Future<void> verifyForgotPasswordScreenElements() async {
    await waitForElementToLoad('text', 'Forgot Password');
    await sleep(Duration(seconds: 1));
    await verifyElementIsDisplayed(screen_header);
//    TODO back button on this screen is different, need to dig in more to make it work with flutter integation test
//    await verifyElementIsDisplayed(back_button);
    await validate(await getText(forgot_password_subtext),
        'Don’t worry we’ve got you! Enter your email and we’ll send you an email to reset the password.');
    await verifyElementIsDisplayed(forgot_password_subtext);
    await verifyElementIsDisplayed(email_input);
    await verifyElementIsDisplayed(send_reset_password_email);
  }

  Future<void> enterEmail(String email) async {
    await typeIn(email_input, email);
  }

  Future<void> clickOnSendResetPasswordEmail() async {
    await clickOn(send_reset_password_email);
  }
}
