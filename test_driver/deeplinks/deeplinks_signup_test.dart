import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../screens/signup_screen.dart';

void main() async {
  FlutterDriver driver;
  SplashScreen _splashScreen;
  WelcomeScreen _welcomeScreen;
  SignUpScreen _signUpScreen;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    _splashScreen = SplashScreen(driver);
    _welcomeScreen = WelcomeScreen(driver);
    _signUpScreen = SignUpScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  group('deep links tests', () {
    test('/signup', () async {
      // await driver.requestData('restart');
      await _splashScreen.verifySplashScreenIsDisplayed();

      await _welcomeScreen.verifyWelcomeScreenIsDisplayed();
      await driver.requestData('raiseDeepLink|/signup');
      await _signUpScreen.verifySignUpScreenIsDisplayed();
    });
  });
}
