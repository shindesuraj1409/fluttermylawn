import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/zone_details.dart';

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

  group('C96335: Zone wise "Grass Types" Test', ()
  {
    test('traverse to lawn size screen', () async {
      await splashScreen.verifySplashScreenIsDisplayed();
      await welcomeScreen.verifyWelcomeScreenIsDisplayed();
      await welcomeScreen.clickOnGetStartedButton();
      await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
      await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
      await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
      await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
      await lawnConditionsScreen.clickOnSaveButton();
      await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
      await spreaderTypesScreen.selectSpreader('no');
    });

    test('User should be able to see grass types for different zones', () async {
        for(var i = 0; i < zipCodes.length; i++) {
          await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
          await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
          await manualEntryScreen.setZipCodeAndLawnSizeData(zipCodes[i], size);
          await manualEntryScreen.clickOnContinueButton();
          await grassTypesScreen.verifyGrassTypes(zoneWiseGrassTypes[i]);
          await grassTypesScreen.clickOnBackButton();
        };
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
