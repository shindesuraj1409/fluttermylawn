import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class OrderConfirmationScreen extends BaseScreen {
  // payment tile
  final thank_you_label = find.text('Thank You');
  final order_number_label = find.text('Order Number');
  final order_number = find.byValueKey('order_number');
  final order_confirmation_message = find.text(
      'Your order confirmation, complete with tracking details, will soon be arriving in your inbox.');
  final next_shipment_label = find.text('NEXT SHIPMENT');
  final next_shipment_date = find.byValueKey('next_shipment_date');
  final next_shipment_sub_text =
      find.text('We’ll send you SMS and push notifications on your shipments.');
  final change_settings_link = find.text('Change settings');
  final product_image = find.byValueKey('product_image');
  final bag_image = find.byValueKey('bag_image');
  final bag_text = find.byValueKey('bag_text');
  final return_home_button = find.text('RETURN HOME');

  OrderConfirmationScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyOrderConfirmationDetails() async {
    await verifyElementIsDisplayed(thank_you_label);
    await verifyElementIsDisplayed(order_number_label);
    await verifyElementIsDisplayed(order_number);
    await verifyElementIsDisplayed(order_confirmation_message);
    await verifyElementIsDisplayed(next_shipment_label);
    await verifyElementIsDisplayed(next_shipment_date);
    await verifyElementIsDisplayed(next_shipment_sub_text);
    await verifyElementIsDisplayed(change_settings_link);
    await verifyElementIsDisplayed(product_image);
    await verifyElementIsDisplayed(bag_image);
    await verifyElementIsDisplayed(return_home_button);
  }

  Future<void> clickOnReturnHome() async {
    await clickOn(return_home_button);
  }

  Future<void> clickOnChangeSettingsLink() async {
    await clickOn(change_settings_link);
  }
}
