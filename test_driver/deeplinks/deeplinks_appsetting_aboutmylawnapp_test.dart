import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../test_data/deeplink_test_data.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;
  SplashScreen _splashScreen;
  WelcomeScreen _welcomeScreen;
  LoginScreen _loginScreen;
  PlanScreen _planScreen;
  AboutMyLawnAppScreen _aboutMylawnAppScree;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    _splashScreen = SplashScreen(driver);
    _welcomeScreen = WelcomeScreen(driver);
    _loginScreen = LoginScreen(driver);
    _planScreen = PlanScreen(driver);
    _aboutMylawnAppScree = AboutMyLawnAppScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('deep links tests', () {
    group('logged in', () {
      setUp(() async {
        await _splashScreen.verifySplashScreenIsDisplayed();

        await _welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await _welcomeScreen.clickOnLoginButton();
        await _welcomeScreen.verifyLoginBottomSheetIsDisplayed();
        await _welcomeScreen.clickOnContinueWithEmailButton();

        await _loginScreen.verifyLoginScreenIsDisplayed();
        await _loginScreen.enterEmail(deepLink_data['email']);
        await _loginScreen.clickOnContinueButton();

        await _loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await _loginScreen.enterPassword(deepLink_data['password']);
        await _loginScreen.clickOnLoginButton();
        await _planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      });

      test('/appSettings/aboutMyLawnApp', () async {
        await driver.requestData('raiseDeepLink|/appSettings/aboutMyLawnApp');
        await _aboutMylawnAppScree
            .verifyAboutMyLawnAppScreenElementsAreDisplayed();
      });
    });
  }, timeout: Timeout(Duration(minutes: 5)));
}
