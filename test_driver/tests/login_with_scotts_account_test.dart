import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../utils/getRecommondedProducts.dart';

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
  var signUpScreen;
  var profileScreen;
  var myScottsAccountScreen;
  var loginScreen;

  var email;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails =
        recommendedProducts.subscriptionCardProductDetails;

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
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    loginScreen = LoginScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  Future<void> logOut() async {
    // Verify my scotts account
    await planScreen.clickOnProfileIcon();
    await profileScreen.clickOnMyScottsAccount();
    await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();

    // Logout user
    await myScottsAccountScreen.clickOnLogoutButton();
    await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
    await myScottsAccountScreen.clickOnDrawerLogoutButton();
  }

  Future<void> completeQuiz() async {
    // Complete quiz

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
  }

  group('description', () {
    test(
      'C66006: Log in on Welcome Screen w/Existing Account',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await completeQuiz();

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

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }

        await logOut();

        // Log back in to verify your new email works
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await loginScreen.clickOnLoginButton();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }

        await logOut();
      },
      timeout: Timeout(
        Duration(
          minutes: 6,
        ),
      ),
    );

    test(
      'C81418: Login with invalid credentials',
      () async {
        // Log back in to verify your new email works
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await loginScreen.verifyWelcomeBackScreenIsDisplayed();

        // password is wrong for login failed
        await loginScreen.enterPassword('Pass123!@');
        await loginScreen.clickOnLoginButton();

        // User should get an error
        await loginScreen.verifyLoginErrorMessage();

        await loginScreen.goToBack();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C81417: A user logs in with a fresh account',
      () async {
        email = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        await completeQuiz();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );
  });
}
