import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class WhyAreYouCancellingScreen extends BaseScreen {
  final close_icon = find.byValueKey('close_icon');

  final reason_price_of_subscription = find.text('Price of Subscription');
  final reason_delivery = find.text('Delivery or Shipping Issue');
  final reason_product_quality = find.text('Product Quality or Results');
  final reason_i_moved = find.text('I Moved');
  final reason_prefer_store =
      find.text('Prefer to Buy at a Store or Other Retailer');
  final reason_switched_to_lawn_service =
      find.text('Switched to a Lawn Service');
  final reason_leftover_product = find.text('I Have Leftover Product');
  final reason_webapp_issue = find.text('Issue with Website or App');
  final reason_other = find.text('Other');

  final phone_image = find.byValueKey('phone_image');
  final phone_number = find.text('1-877-220-3091');
  final mail_image = find.byValueKey('mail_image');
  final mail = find.text('orders@scotts.com');

  final continue_button = find.text('CONTINUE');

  WhyAreYouCancellingScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyWhyAreYouCancellingScreenIsDisplayed() async {
    await verifyElementIsDisplayed(reason_price_of_subscription);
    await verifyElementIsDisplayed(reason_delivery);
    await verifyElementIsDisplayed(reason_product_quality);
    await verifyElementIsDisplayed(reason_i_moved);
    await verifyElementIsDisplayed(reason_prefer_store);
    await verifyElementIsDisplayed(reason_switched_to_lawn_service);
    await verifyElementIsDisplayed(reason_leftover_product);
    await verifyElementIsDisplayed(reason_webapp_issue);
    await verifyElementIsDisplayed(reason_other);

    await verifyElementIsDisplayed(close_icon);
    await validate(await getText(header_title), 'Why Are You Canceling?');

    await verifyCancelationBottomSection();
  }

  Future<void> verifyCancelationBottomSection() async {
    await verifyElementIsDisplayed(phone_image);
    await verifyElementIsDisplayed(phone_number);
    await verifyElementIsDisplayed(mail_image);
    await verifyElementIsDisplayed(mail);
    await verifyElementIsDisplayed(continue_button);
  }

  Future<void> clickOnContinueButton() async {
    await scrollTillElementIsVisible(continue_button, dy: 5);
    await clickOn(continue_button);
  }

  Future<void> selectCancelationOption(String reason) async {
    var element;
    switch (reason) {
      case 'price':
        element = reason_price_of_subscription;
        break;
      case 'shipping':
        element = reason_delivery;
        break;
      case 'quality':
        element = reason_product_quality;
        break;
      case 'moved':
        element = reason_i_moved;
        break;
      case 'prefer_store':
        element = reason_prefer_store;
        break;
      case 'lawn_service':
        element = reason_switched_to_lawn_service;
        break;
      case 'leftover_product':
        element = reason_leftover_product;
        break;
      case 'app_issue':
        element = reason_webapp_issue;
        break;
      case 'other':
        element = reason_other;
        break;
      default:
        throw Exception('Bad reason: $reason');
        break;
    }

    await scrollTillElementIsVisible(element, dy: 5);
    await clickOn(element);
  }
}
