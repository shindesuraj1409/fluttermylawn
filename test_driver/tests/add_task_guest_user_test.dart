import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';
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
  var addTaskScreen;
  var signUpScreen;
  var createTaskScreen;
  var loginScreen;
  var createAccountScreen;
  var homeScreen;
  var calendarScreen;

  var email;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final lawnSizeToSelect = '1/8" | 11 mins';
  final dateToday = DateFormat('EE MMM dd').format(DateTime.now());
  final day = dateToday.split(' ')[2];
  final month = dateToday.split(' ')[1];
  final taskScreenName = 'Water Lawn';
  final task_note = 'Test Water Lawn Task';

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
    addTaskScreen = AddTaskScreen(driver);
    createTaskScreen = CreateTaskScreen(driver);
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
      'C95809: Add a Task - Guest User',
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

        // Click on Task Button
        await planScreen.clickOnTaskButton();

        // Verify add task screen
        await addTaskScreen.verifyAddTaskScreenCommonElementsAreDisplayed();

        //Click on Close button
        await addTaskScreen.clickOnCancelButton();

        //Verify Plan screen
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Click on Floating Action button
        await planScreen.clickOnFloatingActionButton();

        // Click on Task Button
        await planScreen.clickOnTaskButton();

        //Click on Water Lawn icon
        await addTaskScreen.clickOnWaterLawnTaskButton();

        //Select Lawn Size
        await createTaskScreen.selectHowMuchLawnSize(lawnSizeToSelect,
            isGuest: true);

        //Verify selected Lawn Size
        await createTaskScreen.verifySelectedLawnSize(lawnSizeToSelect);

        //Select Today's Date
        await createTaskScreen.selectDateForWhenField();

        //Verify Selected Day
        await createTaskScreen.verifyDateOnTaskScreen(dateToday);

        //Enable or Disable Remind Me
        await createTaskScreen.enableRemindMe('OFF');

        //Enter task notes
        await createTaskScreen.addTaskNotes(task_note);

        //Tap on Save button
        await createTaskScreen.clickOnSaveButton();
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

        //Verify “Added to Calendar” message is displayed.
        await createTaskScreen
            .verifyTaskSavedNotificationIsDisplayed('Added to Calendar');
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        //Verify Task is added in calendar
        // Click on calender tab
        await homeScreen.clickOnCalendarNavigationButton();

        // Verify Calendar Screen
        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();

        //Verify task on Calendar screen
        await calendarScreen.verifyTaskAddedOnCalenderScreen(
            1, taskScreenName, day, month, false,
            taskNote: task_note, remindMe: 'OFF');

        // Verify Water Lawn task
        await calendarScreen.verifyTaskDetails(taskScreenName,
            taskNote: task_note);
        await calendarScreen.clickOnCancelButton();
        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
