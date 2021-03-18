import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';


void main() {
  FlutterDriver driver;

  // Screen objects
  SplashScreen splashScreen;
  WelcomeScreen welcomeScreen;
  LawnConditionScreen lawnConditionScreen;
  SpreaderTypesScreen spreaderTypesScreen;

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

  test('traverse to spreader types screen', () async {
    await splashScreen.verifySplashScreenIsDisplayed();
    await welcomeScreen.verifyWelcomeScreenIsDisplayed();
    await welcomeScreen.clickOnGetStartedButton();
    await lawnConditionScreen.clickOnSaveButton();
  });

  test(
      'C67837: user should be able to select wheeled spreader option', () async {
    await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
    await spreaderTypesScreen.clickOnWheeledSpreaderOption();
  });
}