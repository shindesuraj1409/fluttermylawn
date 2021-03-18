import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class NegativeFeedbackScreen extends BaseScreen {
  final thankyou_image = find.byValueKey('thankyou_image');
  final thankyou_label = find.text('Thank you!');
  final description = find.text(
      'Would you like to contact customer support and tell us more about your experience?');
  final contact_customar_support_button =
      find.byValueKey('contact_customer_support_button');

  NegativeFeedbackScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyNegativeFeedbackScreenElementsAreDisplayed() async {
//    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(thankyou_image);
    await verifyElementIsDisplayed(thankyou_label);
    await verifyElementIsDisplayed(description);
    await verifyElementIsDisplayed(contact_customar_support_button);
  }

  Future<void> clickOnContactCustomerSupport() async {
    await clickOn(contact_customar_support_button);
  }
}
