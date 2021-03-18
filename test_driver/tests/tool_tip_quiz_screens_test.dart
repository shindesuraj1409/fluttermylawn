import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

void main() {
  FlutterDriver driver;

  // Screen objects
  var splashScreen;
  var welcomeScreen;
  var lawnConditionScreen;
  var spreaderTypesScreen;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  test(
    'C68729: Tool tip text across all quiz screens.',
    () async {
      // traversal till spreader screen
      await splashScreen.verifySplashScreenIsDisplayed();
      await welcomeScreen.verifyWelcomeScreenIsDisplayed();
      await welcomeScreen.clickOnGetStartedButton();
      await lawnConditionScreen.clickOnSaveButton();

      // verify tool tip
      await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
      await spreaderTypesScreen.clickOnSpreaderTypeScreenInfoIconButton();
      await spreaderTypesScreen.verifyWhyNeedSpreaderBottomSheet();
      await spreaderTypesScreen.clickOnGotIt();
    },
    timeout: Timeout(
      Duration(
        minutes: 5,
      ),
    ),
  );
}
