import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class LawnTracingScreen extends BaseScreen {
  final SECTION_TITLE =
      find.text('Take Advantage of Local Deals and Promotions');
  final SECTION_SUB_TITLE = find
      .text('Share your location to get notified of local deals & promotions.');
  final YES_PLEASE_BUTTON = find.text('YES PLEASE');
  final NOT_NOW_BUTTON = find.text('NOT NOW');

  LawnTracingScreen(FlutterDriver driver) : super(driver);

  // Verify "Lawn Tracing" screen should be displayed
  Future<void> verifyLawnTracingScreenElementsAreDisplayed() async {
    await verifyElementIsDisplayed(SECTION_TITLE);
    await verifyElementIsDisplayed(SECTION_SUB_TITLE);
    await verifyElementIsDisplayed(YES_PLEASE_BUTTON);
    await verifyElementIsDisplayed(NOT_NOW_BUTTON);
  }

  Future<void> selectYesNo(bool stayOnTask) async {
    if (stayOnTask) {
      await clickOn(YES_PLEASE_BUTTON);
    } else {
      await clickOn(NOT_NOW_BUTTON);
    }
  }
}
