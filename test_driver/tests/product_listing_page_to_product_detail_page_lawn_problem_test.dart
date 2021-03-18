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
  var productListingScreen;


  var email;

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
    productListingScreen = ProductListingScreen(driver);

  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('Product Listing Screen Tests', () {
    test(
        'C73706: Navigation from product listing page (PLP) to product detail page (PDP) Lawn Problems',
        () async {
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
      await grassTypeScreen.selectGrassType('I don\'t know my grass type');

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

      // Tap on Lawn Problems
      await mainProductListingScreen.scrollTillEnd();
      await mainProductListingScreen.clickOnLawnProblemButton();
      for (var menu in mainProductListingScreen.lawn_problems) {
        // Tap on Lawn Problems
        await mainProductListingScreen.clickOnLawnProblemMenu(menu);
        //Verify Product Listing Screen
        await productListingScreen.verifyProductScreen(menu);
        //Get the number of Items displayed
        var totalProductDisplayed =
            await productListingScreen.getNumberOfProductsDisplayed();
        //Check if "No items" should not be displayed on PLP
        await expect(true, totalProductDisplayed > 0);
        //Run test only for 5 items
        if (totalProductDisplayed > 5) {
          totalProductDisplayed = 5;
        }
        await productListingScreen.verifyProductDetails(
            totalProductDisplayed, menu, 'Lawn Problems');
        //Go back to Lawn Problems Main PLP screen
        await productListingScreen.goToBack();
        //Verify LawnProblems Elements on Main PLP screen
        await mainProductListingScreen.verifyLawnProblemElementsAreDisplayed();
      }
    }, timeout: Timeout(Duration(minutes: 10)));
  });
}
