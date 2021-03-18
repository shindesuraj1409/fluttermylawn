import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/settings_screen/state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/welcome_screen/state.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  SplashScreen splashScreen;
  var welcomeScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  LocationSharingScreen locationSharingScreen;



  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';



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
    locationSharingScreen = LocationSharingScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C90271: Seasonal Subscription without Addon',
          () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();

        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();
        await driver.requestData('trackAppState|${OnBoardingState().type.toString()}');

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();
        await driver.requestData('trackAppState|${LawnLookState().type.toString()}');

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('no');
        await driver.requestData('trackAppState|${SpreaderScreenState().type.toString()}');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await driver.requestData('trackAppState|${LawnSizeState().type.toString()}');
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        await driver.requestData('trackAppState|${LawnSizeManualState().type.toString()}');

        await grassTypesScreen.selectGrassType(grass);
        await driver.requestData('trackAppState|${GrassTypeScreenState().type.toString()}');

        await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await driver.requestData('trackAppState|${SoftAskScreenAdobeState().type.toString()}');

        await locationSharingScreen.clickOnYesPlease();
        await driver.requestData('checkPermissionWithReaction');


      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
