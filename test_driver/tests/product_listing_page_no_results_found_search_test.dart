import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() {
  FlutterDriver driver;

  // Screen objects
  var splashScreen;
  var welcomeScreen;
  var lawnConditionScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypeScreen;

  var lawnTracingScreen;
  var signUpScreen;
  var planScreen;
  var homeScreen;
  var createAccountScreen;
  var mainProductListingScreen;
  var productSearchScreen;

  var email;

  final invalidSearchTestData = [
    '4333666634',
    '@@@####%%%%',
    'Quick1234',
  ];

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypeScreen = GrassTypesScreen(driver);
    signUpScreen = SignUpScreen(driver);
    planScreen = PlanScreen(driver);
    homeScreen = HomeScreen(driver);
    lawnTracingScreen = LawnTracingScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    mainProductListingScreen = MainProductListingScreen(driver);
    productSearchScreen = ProductSearchScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

    test('C73422: No results found', () async {
      //Quiz
      // Verify "Splash Screen" should be displayed
      await splashScreen.verifySplashScreenIsDisplayed();

      // Click on "GET STARTED" button on "Welcome Screen"
      await welcomeScreen.clickOnGetStartedButton();

      // Completing "Quiz" questions
      // Take all questions on "Lawn Condition" screen
      await lawnConditionScreen.verifyLawnConditionIsDisplayed();
      await lawnConditionScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
      await lawnConditionScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
      await lawnConditionScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
      await lawnConditionScreen.clickOnSaveButton();

      // Take all questions on "Spreader Types" screen
      await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
      await spreaderTypesScreen.selectSpreader('wheeled');

      // Take all questions on "Lawn Size" screen
      await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
      await lawnSizeScreen.clickOnManualEnterLawnSizeLink();

      // Take all questions on "Manual Entry" screen
      await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
      await manualEntryScreen.typeInZipCodeInputField('43203');
      await manualEntryScreen.typeInLawnSizeInputField('300');
      await manualEntryScreen.clickOnContinueButton();

      // Take all questions on "Grass Types" screen
      await grassTypeScreen.verifyGrassTypesScreenIsDisplayed();
      await grassTypeScreen.selectGrassType('Bermuda');

      // Take all questions on "Lawn Tracing" screen
      await lawnTracingScreen.verifyLawnTracingScreenElementsAreDisplayed();
      await lawnTracingScreen.selectYesNo(false);

      // Verify "Sign up Screen" should be displayed
      await signUpScreen.verifySignUpScreenIsDisplayed();

      // Verify "EmailScreen" should be displayed
      // Sign up user
      await signUpScreen.waitForSignUpScreenLoading();
      await signUpScreen.clickOnContinueWithEmailButton();
      email = 'automation.mylawn+' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '@gmail.com';
      await createAccountScreen.enterEmail(email);
      await createAccountScreen.clickOnContinueButton();
      await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
      await createAccountScreen.enterPassword('Pass123!@#');
      await createAccountScreen.waitForCreateAccountScreenLoading();
      await createAccountScreen.clickOnSignUpButton();
      // Verify "Home Screen" should be displayed
      await homeScreen.verifyHomeScreenElementsAreDisplayed();
      // Click on Floating Action button
      await planScreen.clickOnFloatingActionButton();
      // Verify Floating Action Button options
      await planScreen.verifyFloatingActionButtonElementsAreDisplayed();
      // Click on Product
      await planScreen.clickOnProductButton();
      // Verify Product Listing Page
      await mainProductListingScreen.verifyMainProductListingScreen();


      for (var searchData in invalidSearchTestData) {
        //Click on plp Search
        await mainProductListingScreen.clickOnSearchButton();
        //Verify Product Search Screen
        await productSearchScreen.verifyProductSearchScreen();
        //Enter Product name
        await productSearchScreen.enterProductName(searchData);
        //verify no result found screen
        await productSearchScreen.verifyNoResultFoundScreen();
        //Tap on Cancel button on Search Screen
        await productSearchScreen.clickOnSearchCancelButton();
      }
      //Verify Product Listing Main screen elements
      await mainProductListingScreen.verifyMainProductListingScreen();
    }, timeout: Timeout(Duration(minutes: 5)));
}
