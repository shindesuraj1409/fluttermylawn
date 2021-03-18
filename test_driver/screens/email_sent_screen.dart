import 'package:flutter_driver/src/driver/driver.dart';
import 'screens.dart';

class EmailSentScreen extends BaseScreen {
  EmailSentScreen(FlutterDriver driver) : super(driver);

  final screen_header = find.text('Email Has been Sent');
  final subtext = find.text(
      'To reset your password, please check your inbox and follow the instruction.');
  final back_to_login = find.text('BACK TO LOGIN');
  final did_not_receive_label = find.text('Didn’t receive the email? ');
  final send_again = find.text('SEND AGAIN');

  Future<void> verifyEmailSentScreenElements() async {
    await waitForElementToLoad('text', 'Email Has been Sent');
    assert(await getText(screen_header) == 'Email Has been Sent');
    await verifyElementIsDisplayed(subtext);
    await verifyElementIsDisplayed(back_to_login);
    await verifyElementIsDisplayed(did_not_receive_label);
    await verifyElementIsDisplayed(send_again);
  }

  Future<void> clickOnBackToLogin() async {
    await clickOn(back_to_login);
  }

  Future<void> clickOnSendAgain() async {
    await clickOn(send_again);
  }
}
