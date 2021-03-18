import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  var splashScreen;
  var welcomeScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  var locationSharingScreen;
  var planScreen;
  var signUpScreen;
  var addNoteScreen;
  var loginScreen;
  var createAccountScreen;
  var homeScreen;
  var calendarScreen;

  var email;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final note = 'enter test note';

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
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    addNoteScreen = AddNoteScreen(driver);
    loginScreen = LoginScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    homeScreen = HomeScreen(driver);
    calendarScreen = CalenderScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C95811: Add a Note - Guest User',
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
        await signUpScreen.clickOnContinueWithGuestButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        //click on floating action button
        await planScreen.clickOnFloatingActionButton();

        //verify floating action button elements
        await planScreen.verifyFloatingActionButtonElementsAreDisplayed();

        // Click on Note Button
        await planScreen.clickOnNoteButton();

        // Verify Note screen
        await addNoteScreen.verifyNoteScreenCommonElementsAreDisplayed();

        // Enter test note
        await addNoteScreen.enterNote(note);

        //verify signUp bottom sheet
        await addNoteScreen.clickOnSave();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();

        await welcomeScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Click on calender tab
        await homeScreen.clickOnCalendarNavigationButton();

        // Verify Calendar Screen
        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();

        // Verify note
        await calendarScreen.verifyNote(note);
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
