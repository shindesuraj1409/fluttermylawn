import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class StayOnTaskScreen extends BaseScreen {
  final SECTION_TITLE = find.text('Stay on Task');
  final SECTION_SUB_TITLE = find.text(
      'Receive helpful lawn care reminders and exclusive offers sent right to your phone.');
  final YES_PLEASE_BUTTON = find.text('YES PLEASE');
  final NOT_NOW_BUTTON = find.text('NOT NOW');

  StayOnTaskScreen(FlutterDriver driver) : super(driver);

  // Verify "Stay On Task" screen should be displayed
  Future<void> verifyStayOnTaskScreenElementsAreDisplayed() async {
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
