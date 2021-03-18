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

  var addNoteScreen;
  var addTaskScreen;
  var mainProductListingScreen;

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
    addNoteScreen = AddNoteScreen(driver);
    addTaskScreen = AddTaskScreen(driver);
    mainProductListingScreen = MainProductListingScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('C83047: FAB on Homepage.', () {
    test(
      'process till plan screen',
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

    test('Verifying add a note screen', () async {
      await planScreen.clickOnFloatingActionButton();

      // click on note button
      await planScreen.clickOnNoteButton();

      // verify Note screen
      await addNoteScreen.verifyNoteScreenCommonElementsAreDisplayed();
      await addNoteScreen.clickOnCancelButton();
    });

    test('Verifying task options screen', () async {
      await planScreen.clickOnFloatingActionButton();

      sleep(Duration(seconds: 2));

      // click on Task screen
      await planScreen.clickOnTaskButton();

      // verify Task screen
      await addTaskScreen.verifyAddTaskScreenCommonElementsAreDisplayed();
      await addTaskScreen.clickOnCancelButton();
    });

    test('Verifying main PLP screen', () async {
      await planScreen.clickOnFloatingActionButton();

      sleep(Duration(seconds: 2));

      // click on product listing screen
      await planScreen.clickOnProductButton();

      // verify product listing screen
      await mainProductListingScreen.verifyMainProductListingScreen();
    });
  });
}
