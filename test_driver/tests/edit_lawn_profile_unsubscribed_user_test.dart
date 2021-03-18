import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
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
  var email;
  var signUpScreen;
  var editLawnProfile;
  var profileScreen;

  final size = '25';
  final zip = '43203';
  final zip_update = '43215';
  final size_update = '50';
  final grass = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

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
    editLawnProfile = EditLawnProfile(driver);
    profileScreen = ProfileScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('Edit Lawn Profile', () {
    test(
      'C69416: Edit Lawn Address :Manual entry - Unsubscribed user',
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

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        await grassTypesScreen.selectGrassType(grass);

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
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        //Tap on Profile Icon
        await planScreen.clickOnProfileIcon();
        //Tap on Edit link
        await profileScreen.clickOnEditButton();
        //Verify Lawn Profile screen
        await editLawnProfile.validateLawnProfileValues(false,
            grassType: grass,
            zipCode: zip,
            lawnSize: size,
            spreaderType: 'None',
            grassThickness: 'Some Grass',
            grassColor: 'Mostly Green',
            weeds: 'No Weeds');

        //Tap on Lawn Address
        await editLawnProfile.clickOnEditLawnProfileSections(
            'LawnAddress', false);

        //Verify Lawn Lawn Size screen
        await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed(edit: true);
        //Tap on Enter Size link
        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        //Verify Manual Entry Screen
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed(edit: true);
        //Update Zip code and Lawn Size
        await manualEntryScreen.setZipCodeAndLawnSizeData(
            zip_update, size_update);
        //Tap on Continue button
        await manualEntryScreen.clickOnContinueButton();

        //Verify Edit Profile screen
        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        //Verify Updated values
        await editLawnProfile.validateLawnProfileValues(false,
            grassType: grass,
            zipCode: zip_update,
            lawnSize: size_update,
            spreaderType: 'None',
            grassThickness: 'Some Grass',
            grassColor: 'Mostly Green',
            weeds: 'No Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
