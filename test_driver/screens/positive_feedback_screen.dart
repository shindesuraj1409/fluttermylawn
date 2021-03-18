import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class PositiveFeedbackScreen extends BaseScreen {
  final thankyou_image = find.byValueKey('thankyou_image');
  final thankyou_label = find.text('Thank you!');
  final description = find
      .text('Would you like to rate us and write a review in the app store?');
  final go_to_app_store_button = find.byValueKey('go_to_app_store_button');

  PositiveFeedbackScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyPositiveFeedbackScreenElementsAreDisplayed() async {
//    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(thankyou_image);
    await verifyElementIsDisplayed(thankyou_label);
    await verifyElementIsDisplayed(description);
    await verifyElementIsDisplayed(go_to_app_store_button);
  }

  Future<void> clickOnGoToAppStoreButton() async {
    await clickOn(go_to_app_store_button);
  }

}
