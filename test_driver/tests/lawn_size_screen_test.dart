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
  LawnSizeScreen lawnSizeScreen;
  ManualEntryScreen manualEntryScreen;

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
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  test('traverse to lawn size screen', () async {
    await splashScreen.verifySplashScreenIsDisplayed();
    await welcomeScreen.verifyWelcomeScreenIsDisplayed();
    await welcomeScreen.clickOnGetStartedButton();
    await lawnConditionScreen.clickOnSaveButton();
    await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
    await spreaderTypesScreen.clickOnWheeledSpreaderOption();
  });

  // TODO: Can't automate for now
  // test(
  //     'C68625: user should be able to search address based on location', () async {
  //
  // });

  // TODO: Can't automate for now
  // test(
  //     'C68626: non US user should see error when it\'s trying to search address based on location', () async {
  //
  // });

  test(
      'C68627: user should able to get auto suggestions of an address', () async {
    final address = 'Ohio 3, Columbus, OH, USA';

    await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
    await lawnSizeScreen.typeInAddressInput(address);
    await lawnSizeScreen.verifyAddressIsDisplayedInAutoSuggestion(address);
    await lawnSizeScreen.clickOnLocationOrCancelButton();
  });

  // TODO: Can't automate for now
  // test(
  //     'C68628: user should not see auto suggestion for invalid address', () async {
  //
  // });

  test(
      'C68721: user should be able to see "Manual Entry" screen for lawn size if user already know about "Lawn Size Footage"', () async {
    await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
    await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
  });
}