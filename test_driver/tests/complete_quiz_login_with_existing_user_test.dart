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
  var email;
  var signUpScreen;
  var myScottsAccountScreen;
  var loginScreen;

  var profileScreen;
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
    createAccountScreen = CreateAccountScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    loginScreen = LoginScreen(driver);
    profileScreen = ProfileScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test('C90043: Take the quiz and log in as existing user', () async {
      // Create an account using an email
      email = 'automation.mylawn+' + DateTime.now().millisecondsSinceEpoch.toString() + '@gmail.com';
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
      await createAccountScreen.enterEmail(email);
      await createAccountScreen.clickOnContinueButton();
      await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
      await createAccountScreen.enterPassword('Pass123!@#');
      await createAccountScreen.waitForCreateAccountScreenLoading();
      await createAccountScreen.clickOnSignUpButton();

      // Log out of the app
      await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      await planScreen.clickOnProfileIcon();
      await profileScreen.verifyProfileScreenIsDisplayed();
      await profileScreen.clickOnMyScottsAccount();
      await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
      await myScottsAccountScreen.clickOnLogoutButton();
      await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
      await myScottsAccountScreen.clickOnDrawerLogoutButton();

      // Complete quiz
      await splashScreen.verifySplashScreenIsDisplayed();
      await welcomeScreen.verifyWelcomeScreenIsDisplayed();
      await welcomeScreen.clickOnGetStartedButton();
      await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
      await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
      await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
      await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
      await lawnConditionsScreen.clickOnSaveButton();

      await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
      await spreaderTypesScreen.clickOnWheeledSpreaderOption();

      await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
      await lawnSizeScreen.clickOnManualEnterLawnSizeLink();

      await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
      await manualEntryScreen.setZipCodeAndLawnSizeData('43212', '25');
      await manualEntryScreen.clickOnContinueButton();

      await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
      await grassTypesScreen.selectGrassType('Bermuda');

      await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
      await locationSharingScreen.clickOnNotNow();

      await signUpScreen.verifySignUpScreenIsDisplayed();
      await signUpScreen.clickOnContinueWithEmailButton();

      await loginScreen.verifyLoginScreenIsDisplayed();
      await loginScreen.enterEmail(email);
      await loginScreen.clickOnContinueButton();

      await loginScreen.verifyWelcomeBackScreenIsDisplayed();
      await loginScreen.enterPassword('Pass123!@#');
      await loginScreen.clickOnLoginButton();
      await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
    });
  },
    timeout: Timeout(
        Duration(minutes: 10),
      ),
  );
}

    // test('user should be able to take the quiz', () async {
    //   await lawnConditionScreen.clickOnSaveButton();
    //   await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
    //   await spreaderTypesScreen.clickOnWheeledSpreaderOption();
    //   await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
    //   await manualEntryScreen.setZipCodeAndLawnSizeData(UserData['zipCode'], UserData['lawnSize']);
    //   await manualEntryScreen.clickOnContinueButton();
    //   await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
    //   await grassTypesScreen.clickOnBermudaGrassType();
    // });
    //
    // test('existing user should be able to login', () async {
    //   await lawnTracingScreen.verifyLawnTracingScreenDisplayed();
    //   await lawnTracingScreen.clickNotNowButton();
    //   await signUpScreen.verifySignUpScreenIsDisplayed();
    //   await signUpScreen.clickOnContinueWithEmail();
    //   await enterEmailScreen.verifyEmailScreenIsDisplayed();
    //   await enterEmailScreen.enterEmail(AccountData[0]['email']);
    //   await enterEmailScreen.clickOnContinueButton();
    //   await loginScreen.enterPassword(AccountData[0]['password']);
    //   await loginScreen.clickOnLogInButton();
    // });
    //
    // test('existing user should be able to see home screen after login', () async  {
    //   await homeScreen.verifyHomeScreenIsDisplayed();
    // });