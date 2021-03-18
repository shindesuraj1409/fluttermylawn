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
  var loginScreen;
  var createAccountScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  var locationSharingScreen;
  var planScreen;
  var profileScreen;
  var myScottsAccountScreen;
  var createNewPasswordScreen;
  var email;
  var lawnSizeScreen;

  var homeScreen;

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
    loginScreen = LoginScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    planScreen = PlanScreen(driver);
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    createNewPasswordScreen = CreateNewPasswordScreen(driver);
    baseScreen = BaseScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    homeScreen = HomeScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C85702: Create an account and reset your password',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await loginScreen.verifyLoginScreenIsDisplayed();
        email = 'automation.mylawn+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await loginScreen.enterEmail(email);
        await loginScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.clickOnSignUpButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed(authStatus: true);
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

        // Update password
        await planScreen.waitForPlanScreenLoading();
        await planScreen.clickOnProfileIcon();

        await profileScreen.verifyProfileScreenIsDisplayed();
        await profileScreen.clickOnMyScottsAccount();

        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen.clickOnCreateNewPasswordButton();

        await createNewPasswordScreen
            .verifyCreateNewPasswordScreenIsDisplayed();
        await createNewPasswordScreen.enterOldPassword('Pass123!@#');
        await createNewPasswordScreen.enterNewPassword('Pass1234!!@@');
        await createNewPasswordScreen.clickOnSetNewPasswordButton();

        // Log out of the app
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerLogoutButton();

        // Sign in using the previous password
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();

        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await loginScreen.verifyLoginScreenIsDisplayed();
        await loginScreen.enterEmail(email);
        await loginScreen.clickOnContinueButton();

        await loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await loginScreen.clickOnLoginButton();

        // User should get an error
        await loginScreen.verifyLoginErrorMessage();

        // Sign in using the updated password
        await loginScreen.enterPassword('Pass1234!!@@');
        await loginScreen.clickOnLoginButton();

        // Verify user logged in
        await homeScreen.verifyHomeScreenElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
