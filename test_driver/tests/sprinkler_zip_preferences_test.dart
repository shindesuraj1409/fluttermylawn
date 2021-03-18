import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/zone_details.dart';
import '../utils/common.dart';

void main() {
  FlutterDriver driver;

  // Screens objects
  var baseScreen;
  var splashScreen;
  var welcomeScreen;
  var createAccountScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  var locationSharingScreen;
  var planScreen;
  var signUpScreen;
  var sprinklerScreen;

  var selectedGrassTypes = zoneWiseGrassTypes[0];
  var email;
  final size = '25';
  var zip = '43203';
  var grassType = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Get zip code
    for (var i = 0; i < zipCodes.length; i++) {
      if (await getWaterPrecipitationAmountInInches(zipCodes[i])) {
        zip = zipCodes[i];
        selectedGrassTypes = zoneWiseGrassTypes[i];
        grassType = selectedGrassTypes[0];
        break;
      }
    }

    await sleep(Duration(seconds: 1));
    baseScreen = BaseScreen(driver);
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    sprinklerScreen = SprinklerSettingsScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    await driver?.close();
  });

  group('Sprinkler Settings', () {
    test(
      'complete the process till the plan screen',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue(
            'mostly_green'); //passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue(
            'some_grass'); //passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue(
            'no_weeds'); //passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await manualEntryScreen.clickOnContinueButton();

        if (zip == '43203') {
          await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        } else {
          await grassTypesScreen.verifyGrassTypes(selectedGrassTypes);
        }
        await grassTypesScreen.selectGrassType(grassType);
        await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await locationSharingScreen.clickOnNotNow();

        // Sign up user
        await signUpScreen.waitForSignUpScreenLoading();
        await signUpScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        sleep(Duration(seconds: 2));
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C86537: Sprinkler ZIP and Preference',
      () async {
        await sprinklerScreen.scrollTillTheEndOfRainFallTrackWidget();

        // run the test if InfoTransparentIcon
        if (await sprinklerScreen.isInfoTransparentIconPresent()) {
          // click on `i` icon
          await sprinklerScreen.clickOnInfoTransparentIcon();

          // click on customize button
          await sprinklerScreen.verifySprinklerDialog('1/8"');
          await sprinklerScreen.clickOnCustomizedButton();
          await sprinklerScreen.verifySprinklerScreenBottomSheet();

          // click on cancel button
          await sprinklerScreen.clickOnCancelButtonOfSprinklersDialogue();

          // click on `i` icon
          await sprinklerScreen.clickOnInfoTransparentIcon();

          // click on customize button
          await sprinklerScreen.verifySprinklerDialog('1/8"');
          await sprinklerScreen.clickOnCustomizedButton();

          await sprinklerScreen.clickOnSprinklersGridViewItem();
          await sprinklerScreen.verifyBottomSheetAfterSprinklersSelected();
          await sprinklerScreen.clickOnCancelButtonOfSelectedNozzleType();

          // click on `i` icon
          await sprinklerScreen.clickOnInfoTransparentIcon();
          await sprinklerScreen.verifySprinklerDialog('1/8"');
          await sprinklerScreen.clickOnCustomizedButton();

          // click on Sprinklers setting
          await sprinklerScreen.clickOnSprinklersGridViewItem();
          await sprinklerScreen.verifyBottomSheetAfterSprinklersSelected();
          await sprinklerScreen.clickOnUseThisFlowRateButton();

          // click on `i` icon
          await sprinklerScreen.clickOnInfoTransparentIcon();
          await sprinklerScreen.verifySprinklerDialog('3/8"');
          await sprinklerScreen.clickOnCustomizedButton();
        }
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
