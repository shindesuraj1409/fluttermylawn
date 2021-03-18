import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class LoadingScreen extends BaseScreen {
  final you_got_the_same_plan_text = find.text('You Got the Same Plan!');
  final creating_your_new_lawn_plan_text = find.text('Creating Your New Lawn Plan');
  
  LoadingScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyYouGotTheSamePlanScreenIsDisplayed() async {
    await verifyElementIsDisplayed(you_got_the_same_plan_text, runUnsynchronized: true);
  }

  Future<void> verifyCreatingYourNewLawnPlanScreenIsDisplayed() async {
    await verifyElementIsDisplayed(creating_your_new_lawn_plan_text, runUnsynchronized: true);
  }
}