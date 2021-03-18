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
  var profileScreen;
  var myScottsAccountScreen;

  final size = '25';
  final zip = '43203';
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
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    profileScreen = ProfileScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C69404: Name Change',
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

        await planScreen.clickOnProfileIcon();
        await profileScreen.verifyProfileScreenIsDisplayed();
        await profileScreen.clickOnMyScottsAccount();
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();

        await myScottsAccountScreen.clickOnNameLink();

        // change the name
        await myScottsAccountScreen.verifyChangeNameScreenIsDisplayed();
        await myScottsAccountScreen.enterName('Mayo', 'Cooper');
        await myScottsAccountScreen.clickOnSaveButton();
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen.verifyUpdatedName();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69405: Back navigation across all sections',
      () async {
        // verify chagne name screen
        await myScottsAccountScreen.clickOnNameLink();
        await myScottsAccountScreen.verifyChangeNameScreenIsDisplayed();
        await myScottsAccountScreen.goToBack();

        // verify my scotts account screen
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();

        // verify change email address screen
        await myScottsAccountScreen.clickOnEmailValue();
        await myScottsAccountScreen.verifyChangeEmailAddressScreenIsDisplayed();
        await myScottsAccountScreen.goToBack();

        // verify my scotts account screen
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69406: Change Email',
      () async {
        await myScottsAccountScreen.clickOnEmailValue();

        // verify change email address screen
        await myScottsAccountScreen.verifyChangeEmailAddressScreenIsDisplayed();
        await myScottsAccountScreen.enterEmail('automation.mylawn@gmail.com');
        await myScottsAccountScreen.clickOnSaveButton();

        // verify email is changed and able to see my scotts account screen
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        await myScottsAccountScreen
            .verifyUpdatedEmail('automation.mylawn@gmail.com');
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69410: Subscribe to Scotts Emails',
      () async {
        await myScottsAccountScreen.clickOnSubscribeToEmailToggle();
        await myScottsAccountScreen.verifySubscribeToEmailBottomSheet();
        await myScottsAccountScreen.clickOnSubscribe();

        // verify email is changed and able to see my scotts account screen
        await myScottsAccountScreen
            .verifySubscribeToEmailBottomSheetIsDissmissed();
        await myScottsAccountScreen.verifySnackBar();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69414: Cancel User Logout',
      () async {
        // Cancel log out functionality
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerGoToBackButton();

        // verify my scotts account screen
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69413: User Logout',
      () async {
        // Log out of the app
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerLogoutButton();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
