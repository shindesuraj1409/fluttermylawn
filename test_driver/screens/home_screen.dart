import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class HomeScreen extends BaseScreen {
//Tab Menus Items
  final PLAN_BUTTON = find.text('Plan');
  final TIPS_BUTTON = find.text('Tips');
  final ASK_BUTTON = find.text('Ask');
  final CALENDAR_BUTTON = find.text('Calendar');

  HomeScreen(FlutterDriver driver) : super(driver);

  // Verify "Home Screen" should be displayed
  Future<void> verifyHomeScreenElementsAreDisplayed() async {
    await verifyElementIsDisplayed(PLAN_BUTTON);
    await verifyElementIsDisplayed(TIPS_BUTTON);
    await verifyElementIsDisplayed(ASK_BUTTON);
    await verifyElementIsDisplayed(CALENDAR_BUTTON);
  }

  // Click on "Tips" navigation button
  Future<void> clickOnTipsNavigationButton() async {
    await clickOn(TIPS_BUTTON);
  }

  // Click on "Plan" navigation button
  Future<void> clickOnPlanNavigationButton() async {
    await clickOn(PLAN_BUTTON);
  }

  // Click on "Ask" navigation button
  Future<void> clickOnAskNavigationButton() async {
    await clickOn(ASK_BUTTON);
  }

  // Click on "Calendar" navigation button
  Future<void> clickOnCalendarNavigationButton() async {
    await clickOn(CALENDAR_BUTTON);
  }
}
