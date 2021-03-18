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
  var addTaskScreen;
  var createTaskScreen;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final taskScreenName = [
    'Mow Lawn',
    'Aerate Lawn',
    'Dethatch Lawn',
    'Overseed Lawn',
    'Mulch Beds',
    'Clean Deck / Patio',
    'Winterize Sprinkler System',
    'Tune up Mower',
    'Create Your Own',
  ];

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
    addTaskScreen = AddTaskScreen(driver);
    createTaskScreen = CreateTaskScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group(
    'Water Lawn Task Test',
    () {
      test(
        'C83064: Verify Other Tasks',
        () async {
          // Create an account using an email
          email = 'automation.mylawn+' +
              DateTime.now().millisecondsSinceEpoch.toString() +
              '@gmail.com';
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
          await createAccountScreen.enterEmail(email);
          await createAccountScreen.clickOnContinueButton();
          await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
          await createAccountScreen.enterPassword('Pass123!@#');
          await createAccountScreen.waitForCreateAccountScreenLoading();
          await createAccountScreen.clickOnSignUpButton();

          // Click on Floating Action button
          await planScreen.clickOnFloatingActionButton();

          // Click on Task Button
          await planScreen.clickOnTaskButton();

          for (var item in taskScreenName) {
            // click on Task
            await addTaskScreen.clickOnTask(item);

            //Verify Water Lawn task screen
            await createTaskScreen
                .verifyTaskScreenCommonElementsAreDisplayed(item);
            sleep(Duration(seconds: 2));

            await createTaskScreen.goToBack();
          }
        },
        timeout: Timeout(
          Duration(minutes: 5),
        ),
      );
    },
  );
}
