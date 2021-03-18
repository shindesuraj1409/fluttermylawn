import 'package:flutter_driver/src/driver/driver.dart';


import 'base_screen.dart';

class LocationSharingScreen extends BaseScreen {
  final location_pin_icon = find.text('location_pin_icon');
  final local_deals_text =
      find.text('Take Advantage of Local Deals and Promotions');
  final share_location_text = find
      .text('Share your location to get notified of local deals & promotions.');
  final yes_button = find.text('YES PLEASE');
  final not_now_label = find.text('NOT NOW');

  LocationSharingScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyLocalDealsScreenIsDisplayed() async {
//    await verifyElementIsDisplayed(location_pin_icon);
    await verifyElementIsDisplayed(local_deals_text);
    await verifyElementIsDisplayed(share_location_text);
    await verifyElementIsDisplayed(yes_button);
    await verifyElementIsDisplayed(not_now_label);
  }

  Future<void> clickOnYesPlease() async {
    await clickOn(yes_button);
  }

  Future<void> clickOnNotNow() async {
    await clickOn(not_now_label);
  }
}
