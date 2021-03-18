import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class CreateAccountScreen extends BaseScreen {
  final email_input = find.byValueKey('email_input');
  final continue_button = find.text('CONTINUE');
  final create_account_text = find.text(
      'Your email address was not found, please add a password to create an account or go back to try another email address.');
  final password_input = find.byValueKey('password_input');
  final subscribeToEmail_checkbox =
      find.byValueKey('subscribeToEmail_checkbox');
  final news_letter_text =
      find.text('Subscribe to Scotts newsletter to become a lawn expert');
  final opt_in_text = find.text(
      'By opting in, you are signing up to receive emails marketed by Scotts Miracle-Gro, its affiliates, and select partners with related tips, information, and promotions.');
  final sign_up_button = find.byValueKey('sign_up_button');
  final please_enter_valid_email =
      find.text('Please enter a valid email address');

  CreateAccountScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyCreateAccountScreenIsDisplayed() async {
    await validate(await getText(header_title), 'Create Account');
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(create_account_text);
    await verifyElementIsDisplayed(password_input);
    await verifyElementIsDisplayed(subscribeToEmail_checkbox);
    await verifyElementIsDisplayed(news_letter_text);
    await verifyElementIsDisplayed(opt_in_text);
    await verifyElementIsDisplayed(sign_up_button);
  }

  Future<void> enterEmail(String email) async {
    await typeIn(email_input, email);
  }

  Future<void> clickOnContinueButton() async {
    await clickOn(continue_button);
  }

  Future<void> enterPassword(String password) async {
    await typeIn(password_input, password);
  }

  Future<void> clickOnNewsLetterCheckbox() async {
    await clickOn(subscribeToEmail_checkbox);
  }

  Future<void> clickOnSignUpButton() async {
    await clickOn(sign_up_button);
  }

  Future<void> waitForCreateAccountScreenLoading() async {
    await waitForElementToLoad('key', 'sign_up_button');
  }

  Future<void> verifyInValidEmail() async {
    await verifyElementIsDisplayed(please_enter_valid_email);
  }
}
