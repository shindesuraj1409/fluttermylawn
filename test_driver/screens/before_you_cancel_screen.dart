import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class BeforeYouCancelScreen extends BaseScreen {
  final close_icon = find.byValueKey('close_icon');
  final we_understand_text = find.text(
      'We understand that lawn care can be tough. Can we help you get your best results?');
  final still_seeing_weeds_text = find.text('Still seeing weeds?');
  final still_seeing_weeds_subtext = find.text(
      'You should see the results from weed control after about 30 days.	');
  final lawn_looking_brown_text = find.text('Lawn looking brown?');
  final lawn_looking_brown_subtext = find.text(
      'Your lawn can get stressed from really hot air or dry condition.	');
  final grass_not_growing_text = find.text('Grass not growing?');
  final grass_not_growing_subtext = find
      .text('Starting from seeds require daily watering for best success.	');

  final cancellation_Bottom_NavBar = find.byType('CancelationBottomNavBar');
  final service_team_text =
      find.text('Our service team is here to help you get your best lawn. ');
  final phone_image = find.byValueKey('phone_image');
  final phone_number = find.text('1-877-220-3091');
  final mail_image = find.byValueKey('mail_image');
  final mail = find.text('orders@scotts.com');

  final continue_button = find.text('CONTINUE');

  BeforeYouCancelScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyBeforeYouCancelScreenIsDisplayed() async {
    await verifyElementIsDisplayed(we_understand_text);
    await verifyElementIsDisplayed(still_seeing_weeds_text);
//    await verifyElementIsDisplayed(still_seeing_weeds_subtext); //TODO: Rich Text
    await verifyElementIsDisplayed(lawn_looking_brown_text);
//    await verifyElementIsDisplayed(lawn_looking_brown_subtext); //TODO: Rich Text
    await verifyElementIsDisplayed(grass_not_growing_text);
//    await verifyElementIsDisplayed(grass_not_growing_subtext); //TODO: Rich Text
    await verifyElementIsDisplayed(cancellation_Bottom_NavBar);
    await verifyElementIsDisplayed(await find.descendant(
        of: cancellation_Bottom_NavBar, matching: service_team_text));
    await verifyElementIsDisplayed(await find.descendant(
        of: cancellation_Bottom_NavBar, matching: phone_image));
    await verifyElementIsDisplayed(await find.descendant(
        of: cancellation_Bottom_NavBar, matching: phone_number));
    await verifyElementIsDisplayed(await find.descendant(
        of: cancellation_Bottom_NavBar, matching: mail_image));
    await verifyElementIsDisplayed(
        await find.descendant(of: cancellation_Bottom_NavBar, matching: mail));
    await verifyElementIsDisplayed(close_icon);
    await validate(await getText(header_title), 'Before You Cancel');
    await verifyElementIsDisplayed(continue_button);
  }

  Future<void> clickOnContinueButton() async {
    await scrollTillElementIsVisible(continue_button, dy: 5);
    await clickOn(continue_button);
  }
}
