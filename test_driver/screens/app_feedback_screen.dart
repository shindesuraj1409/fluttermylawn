import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class AppFeedBackScreen extends BaseScreen {
  final star_one = find.byValueKey('rating_star_1');
  final star_two = find.byValueKey('rating_star_2');
  final star_three = find.byValueKey('rating_star_3');
  final star_four = find.byValueKey('rating_star_4');
  final star_five = find.byValueKey('rating_star_5');
  final what_to_buy_description = find.byValueKey('what_to_buy_description');
  final screen_recorder = find.text("Tell us what's working,\nand what's not");
  final your_feedback_label = find.text('Your Feedback');
  final feedback_text_input = find.byValueKey('feedback_text_field');
  final feedback_text_limit_label = find.text('0/280');
  final share_todays_data_label = find.text("Share Today's Data");
  final share_todays_data_description_label = find.text(
      'You can share basic information about your hardware and software specs with us to helps us diagnose bugs.');
  final share_todays_data_switch = find.byValueKey('share_todays_data_switch');
  final send_feedback_button = find.byValueKey('feedback_send_button');

  AppFeedBackScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyAppFeedbackScreenIsDisplayed() async {
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(screen_recorder);
    await verifyElementIsDisplayed(star_one);
    await verifyElementIsDisplayed(star_two);
    await verifyElementIsDisplayed(star_three);
    await verifyElementIsDisplayed(star_four);
    await verifyElementIsDisplayed(star_five);
    await verifyElementIsDisplayed(your_feedback_label);
    await verifyElementIsDisplayed(feedback_text_input);
    await verifyElementIsDisplayed(feedback_text_limit_label);
    await verifyElementIsDisplayed(share_todays_data_label);
    await verifyElementIsDisplayed(share_todays_data_description_label);
    await verifyElementIsDisplayed(share_todays_data_switch);
    await verifyElementIsDisplayed(send_feedback_button);
  }

  Future<void> rateApp(int rate) async {
    switch (rate) {
      case 1:
        await clickOn(star_two);
        break;
      case 2:
        await clickOn(star_two);
        break;
      case 3:
        await clickOn(star_three);
        break;
      case 4:
        await clickOn(star_four);
        break;
      case 5:
        await clickOn(star_five);
        break;
      default:
        throw Exception('Bad value of rate $rate');
        break;
    }
  }

  Future<void> clickOnSendFeedback() async {
    await clickOn(send_feedback_button);
  }
}
