import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

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
  var homeScreen;
  var createTaskScreen;
  var calendarScreen;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final taskScreenName = 'Water Lawn';
  final lawnSizeToSelect = '2" | 606 mins';
  final task_note = 'Test Water Lawn Task';
  final dateToday = DateFormat('EE MMM dd').format(DateTime.now());
  final day = dateToday.split(' ')[2];
  final month = dateToday.split(' ')[1];

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
    homeScreen = HomeScreen(driver);
    createTaskScreen = CreateTaskScreen(driver);
    calendarScreen = CalenderScreen(driver);
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
      test('C83060: Add a Water Task', () async {
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

        // Click on Floating Action button
        await planScreen.clickOnFloatingActionButton();

        // Verify Floating Action button elements
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

        //Verify Water Lawn task screen
        await createTaskScreen
            .verifyTaskScreenCommonElementsAreDisplayed(taskScreenName);

        //Select Lawn Size
        await createTaskScreen.selectHowMuchLawnSize(lawnSizeToSelect);
        //Verify selected Lawn Size
        await createTaskScreen.verifySelectedLawnSize(lawnSizeToSelect);

        //Select Today's Date
        await createTaskScreen.selectDateForWhenField();
        //Verify Selected Day
        await createTaskScreen.verifyDateOnTaskScreen(dateToday);

        //Select RepeatDuration
        //await createTaskScreen.selectRepeatDuration(repeatDuration);
        //ToDo: Skipping verification till DMP-1201 is done

        //Enable or Disable Remind Me
        await createTaskScreen.enableRemindMe('ON');

        //Enter task notes
        await createTaskScreen.addTaskNotes(task_note);
        //Verify Added taskNote
        await createTaskScreen.verifyAddedTaskNoteOnTaskScreen(task_note);

        //Tap on Save button
        await createTaskScreen.clickOnSaveButton();

        //Verify ???Added to Calendar??? message is displayed.
        await createTaskScreen
            .verifyTaskSavedNotificationIsDisplayed('Added to Calendar');

        //Verify user is on Plan screen
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        //Verify Task is added in calendar
        // Click on calender tab
        await homeScreen.clickOnCalendarNavigationButton();

        // Verify Calendar Screen
        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();

        //Verify task on Calendar screen
        await calendarScreen.verifyTaskAddedOnCalenderScreen(
            1, taskScreenName, day, month, false,
            taskNote: task_note, remindMe: 'ON');

        // Verify Water Lawn task
        await calendarScreen.verifyTaskDetails(taskScreenName,
            taskNote: task_note);

        await calendarScreen.clickOnCancelButton();

        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();

        //ToDo: Below cases are blocked due to issue DMP-1446
        //Tap on How Much ???i??? tooltip icon
        //Sprinkler Flow rate slide-up card will appear
        //Tap Customize on the Sprinkler Flow card
        //User will be taken to the Sprinkler Nozzle options screen
      });
    },
    timeout: Timeout(
      Duration(minutes: 10),
    ),
  );
}
