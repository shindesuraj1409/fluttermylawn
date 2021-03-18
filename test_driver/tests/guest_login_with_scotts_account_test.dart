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
  var password;
  var signUpScreen;

  var profileScreen;
  var myScottsAccountScreen;
  var loginScreen;

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

  Future<void> completeQuiz() async {
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
  }

  group('Guest user login with scotts account from profile screen', () {
    test(
      'Create new user',
          () async {
        await completeQuiz();
        await signUpScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        password = 'Pass123!@#';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword(password);
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnMyScottsAccount();
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerLogoutButton();
        await completeQuiz();
        await signUpScreen.clickOnContinueWithGuestButton();
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnGetStarted();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await loginScreen.verifyLoginScreenIsDisplayed();
        await loginScreen.enterEmail(email);
        await loginScreen.clickOnContinueButton();

        await loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await loginScreen.clickOnLoginButton();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
          },
      timeout: Timeout(
        Duration(minutes: 10),
      ),);

    // TODO: This test is skipped for now because we need to register user in My Garden app
    test('C66004: Guest user logs in with an existing Scotts account from Profile screen (without Quiz ID)', () async {});

    // TODO: This test is skipped for now because of lawn plan Override pop up msg is not displayed
    test('C66009: Guest user logs in with an existing Scotts account from Profile screen (with Quiz ID)', () async {});
  });
}
