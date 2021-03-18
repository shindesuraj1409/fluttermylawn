import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  var splashScreen;
  var welcomeScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;

  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
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

  group('description', () {
    test(
      'C67266: Backward navigation',
          () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        //click on grass type screen back button
        await grassTypesScreen.clickOnBackButton();
        //verify lawn size screen elements
        await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
        //click on lawn size screen back button
        await lawnSizeScreen.clickOnBackButton();
        // verify spreader types screen elements
        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        //click on spreader type screen back button
        await spreaderTypesScreen.clickOnBackButton();
        //verify lawn conditions screen elements
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        //click on lawn conditions screen back button
        await lawnConditionsScreen.clickOnBackButton();
        //verify welcome screen
        await await welcomeScreen.verifyWelcomeScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'C68730: Check progress bar at the top across all quiz screens',
          () async {
            // Create an account using an email
            await splashScreen.verifySplashScreenIsDisplayed();
            await welcomeScreen.verifyWelcomeScreenIsDisplayed();
            await welcomeScreen.clickOnGetStartedButton();

            // Complete quiz
            await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
            await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
            await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
            await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
            await lawnConditionsScreen.clickOnSaveButton();

            await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
            await spreaderTypesScreen.selectSpreader('no');

            await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
            await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
            await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
            await manualEntryScreen.clickOnContinueButton();

            await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
            //click on grass type screen back button
            await grassTypesScreen.clickOnBackButton();
            //verify lawn size screen elements
            await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
            //click on lawn size screen back button
            await lawnSizeScreen.clickOnBackButton();
            // verify spreader types screen elements
            await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
            //click on spreader type screen back button
            await spreaderTypesScreen.clickOnBackButton();
            //verify lawn conditions screen elements
            await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
            //click on lawn conditions screen back button
            await lawnConditionsScreen.clickOnBackButton();
            //verify welcome screen
            await await welcomeScreen.verifyWelcomeScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );


  });
}
