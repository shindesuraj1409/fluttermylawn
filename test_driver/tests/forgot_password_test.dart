import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../utils/getRecommondedProducts.dart';

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
  var loginScreen;
  var forgotPasswordScreen;
  var emailSentScreen;


  final text =['Reset your MyLawn password','Please click the link to reset your password'];

//  TODO to enable these after integating the email parser code
//  var result;
//  final python = 'python3';
//  final emailParser = 'test_driver/utils/email_parser.py';

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails = recommendedProducts.subscriptionCardProductDetails;

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
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    loginScreen = LoginScreen(driver);
    forgotPasswordScreen = ForgotPasswordScreen(driver);
    emailSentScreen = EmailSentScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('User should be able to forgot account password', () {
    test(
      'C66059:	Forgot Password functionality',
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
//        email = 'automation.mylawn+' +
//            await baseScreen.getFormattedTimeStamp() +
//            '@gmail.com';
        email = 'nick.j.taksande+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
//        await planScreen.waitForPlanScreenLoading();
//
//        // Verify subscription card details
//        for (var productID = 0; productID < 4; productID++) {
//          await planScreen.verifyProductElementsAreDisplayed(
//              subscriptionCardProductDetails, productID);
//        }

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        // Open My Subscription
        await profileScreen.clickOnMyScottsAccount();

        // Logout
        await myScottsAccountScreen.clickOnLogoutButton();

        // Logout confirm
        await myScottsAccountScreen.clickOnDrawerLogoutButton();

        // Verify welcome screen
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();

        // Navigate to Forgot password screen
        await welcomeScreen.clickOnLoginButton();
        await welcomeScreen.clickOnContinueWithEmailButton();
        await loginScreen.enterEmail(email);
        await loginScreen.clickOnContinueButton();
        await loginScreen.verifyWelcomeBackScreenIsDisplayed();

        await loginScreen.clickOnForgotPasswordButton();

        // Verify forgot password screen
        await forgotPasswordScreen.verifyForgotPasswordScreenElements();
        await forgotPasswordScreen.clickOnSendResetPasswordEmail();

        // Verify email sent screen
        await emailSentScreen.verifyEmailSentScreenElements();

        await sleep(Duration(seconds: 30));
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

//    TODO: Add method to do email verification
    test('verify password reset email', () async {
      await baseScreen.readingEmail(email,'Reset your MyLawn password','Please click the link to reset your password');

    });

//    test('Verify send reset password email again', () async {
//      await emailSentScreen.clickOnSendAgain();
//    });
//
////    TODO: Add method to do email verification
//    test('verify password reset email', () async {});
//
//    test('Verify send reset password email again', () async {
//      await emailSentScreen.clickOnBackToLogin();
//
//      // Verify Login Screen
//      await loginScreen.verifyWelcomeBackScreenIsDisplayed();
//    });
  });
}
