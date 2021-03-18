import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class LoginScreen extends BaseScreen {
  final email_input = find.byValueKey('email_input');
  final continue_button = find.text('CONTINUE');

  // Welcome Back Screen
  final password_input = find.byValueKey('password_input');
  final forgot_password = find.text('FORGOT PASSWORD?');
  final log_in_button = find.text('LOG IN');

  final login_error_text =
      find.text('Please verify your credentials and try again.');

  LoginScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyLoginScreenIsDisplayed() async {
    await verifyElementIsDisplayed(email_input);
    await verifyElementIsDisplayed(continue_button);
    await verifyElementIsDisplayed(back_button);
  }

  Future<void> enterEmail(String email) async {
    await typeIn(email_input, email);
  }

  Future<void> clickOnContinueButton() async {
    await clickOn(continue_button);
  }

  Future<void> verifyWelcomeBackScreenIsDisplayed() async {
    await validate(await getText(header_title), 'Welcome Back');
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(email_input);
    await verifyElementIsDisplayed(password_input);
    await verifyElementIsDisplayed(forgot_password);
    await verifyElementIsDisplayed(log_in_button);
  }

  Future<void> enterPassword(String password) async {
    await typeIn(password_input, password);
  }

  Future<void> clickOnLoginButton() async {
    await clickOn(log_in_button);
  }

  Future<void> clickOnForgotPasswordButton() async {
    await clickOn(forgot_password);
  }

  Future<void> verifyLoginErrorMessage() async {
    await verifyElementIsDisplayed(login_error_text);
  }
}
