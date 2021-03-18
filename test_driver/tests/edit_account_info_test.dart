import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
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
  var profileScreen;
  var myScottsAccountScreen;
  var loginScreen;

  var email1;
  var email2;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
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
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    loginScreen = LoginScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C95669: Edit Account Info',
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
        await grassTypesScreen.selectGrassType(grass);

        await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await locationSharingScreen.clickOnNotNow();

        // Sign up user
        await signUpScreen.waitForSignUpScreenLoading();
        await signUpScreen.clickOnContinueWithEmailButton();
        email1 = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email1);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify my scotts account
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnMyScottsAccount();
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();

        // Change the name
        await myScottsAccountScreen.clickOnNameLink();
        await myScottsAccountScreen.verifyChangeNameScreenIsDisplayed();
        await myScottsAccountScreen.enterName('Mayo', 'Cooper');
        await myScottsAccountScreen.clickOnSaveButton();
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen.verifyUpdatedName();

        // Verify email is changed and able to see my scotts account screen
        await myScottsAccountScreen.clickOnEmailValue();
        await myScottsAccountScreen.verifyChangeEmailAddressScreenIsDisplayed();
        email2 = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
        await myScottsAccountScreen.enterEmail(email2);
        await myScottsAccountScreen.clickOnSaveButton();
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen
            .verifyUpdatedEmail(email2);

        // Logout user
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerLogoutButton();

        // Log back in to verify your new email works
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await createAccountScreen.enterEmail(email2);
        await createAccountScreen.clickOnContinueButton();
        await loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await loginScreen.clickOnLoginButton();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
