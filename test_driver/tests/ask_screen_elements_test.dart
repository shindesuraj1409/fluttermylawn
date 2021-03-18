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

  var askScreen;

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
    askScreen = AskScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'complete the process till the plan screen',
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
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C81820: Verifying ask screen styling elements',
      () async {
        // change the index of bottom navigation bar to Ask screen
        await planScreen.changeIndexBottomNavigationBarForAsk();

        // verify Ask screen
        await askScreen.verifyAskScreenIsDisplayed();

        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C81821: Verifying email, call, and text buttons exist',
      () async {
        // verify email us button exists
        await askScreen.verifyEmailUs();

        // verify call us button exists
        await askScreen.verifyCallUs();

        // verify text us button exists
        await askScreen.verifyTextUs();

        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C81822: Verifying tap on any help article and article screen loads',
      () async {
        // verify my lawn care plan article
        await askScreen.clickOnMyLawnCarePlan();
        await askScreen.verifyMyLawnCarePlanArticleIsDispplayed();

        // Go back to ask screen
        await askScreen.goToAskScreen();
        sleep(Duration(seconds: 1));

        // verify feed & seed activities article
        await askScreen.clickOnFeedAndSeedActivities();
        await askScreen.verifyFeedAndSeedActivitiesIsDispplayed();

        // Go back to ask screen
        await askScreen.goToAskScreen();
        sleep(Duration(seconds: 1));

        // verify rainfall total article
        await askScreen.clickOnRainfallTotal();
        await askScreen.verifyRainfallTotalIsDispplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
