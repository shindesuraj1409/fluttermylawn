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
  GrassTypesScreen grassTypesScreen;

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
    grassTypesScreen = GrassTypesScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  test('traverse to manual entry screen', () async {
    await splashScreen.verifySplashScreenIsDisplayed();
    await welcomeScreen.verifyWelcomeScreenIsDisplayed();
    await welcomeScreen.clickOnGetStartedButton();
    await lawnConditionScreen.clickOnSaveButton();
    await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
    await spreaderTypesScreen.clickOnWheeledSpreaderOption();
    await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
  });

  test(
      'C68723: user should enter invalid zip code and lawn size and it will get an error', () async {
    final zipCode = '364002';
    final lawnSize = '250';

    await manualEntryScreen.setZipCodeAndLawnSizeData(zipCode, lawnSize);
    await manualEntryScreen.invalidZipCodeErrorIsDisplayed();
  });

  test(
      'C68725: user should get an error when it uses invalid zip codes', () async {
    const invalidZipcodes = ['123456', '1234'];
    const validZipCode = '43203';
    const lawnSize = '250';

    await manualEntryScreen.typeInZipCodeInputField(invalidZipcodes[0]);
    await manualEntryScreen.typeInLawnSizeInputField('');
    await manualEntryScreen.clickOnContinueButton();

    await manualEntryScreen.invalidZipCodeErrorIsDisplayed();
    await manualEntryScreen.typeInZipCodeInputField(invalidZipcodes[1]);
    await manualEntryScreen.typeInLawnSizeInputField(lawnSize);
    await manualEntryScreen.clickOnContinueButton();
    await manualEntryScreen.invalidZipCodeErrorIsDisplayed();

    await manualEntryScreen.typeInZipCodeInputField(validZipCode);
    await manualEntryScreen.typeInLawnSizeInputField(lawnSize);
    await manualEntryScreen.clickOnContinueButton();
    await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
    await grassTypesScreen.goToBack();
  });

  test(
      'C68722: user should get an error when it entered invalid zip code and lawn size data', () async {
    final invalidData = <String>['*', '+', '.', '#', '/'];

    await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
    await manualEntryScreen.verifyManualEntryScreenIsDisplayed();

    for (var value in invalidData) {
      await manualEntryScreen.typeInZipCodeInputField(value);
      await manualEntryScreen.typeInLawnSizeInputField(value);
      await manualEntryScreen.clickOnContinueButton();
      await manualEntryScreen.invalidZipCodeErrorIsDisplayed();
    }
    await manualEntryScreen.goToBack();
  });

  test(
      'C68724: user should be able to enter lawn size data manually', () async {
    await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
    await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
    await manualEntryScreen.setZipCodeAndLawnSizeData('43203', '350');
    await manualEntryScreen.clickOnContinueButton();
    await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
  });
}