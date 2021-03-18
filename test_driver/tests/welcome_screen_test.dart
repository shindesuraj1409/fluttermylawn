import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  SplashScreen splashScreenObject;
  var welcomeScreenObject;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
    await sleep(Duration(seconds: 1));
    splashScreenObject = SplashScreen(driver);
    welcomeScreenObject = WelcomeScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  group('description', () {
    test('user should be able to see splash screen', () async {
      await splashScreenObject.verifySplashScreenIsDisplayed();
    });

    test('C63780: user should be able to see welcome screen', () async {
      await welcomeScreenObject.verifyWelcomeScreenIsDisplayed();
    });

    test('analytic should be send', () async{
      
      await driver.requestData('trackAppState');
    });

    test('C65381: user should be able to see content of welcome screen',
        () async {
      await welcomeScreenObject.verifySliderIsDisplayed();
    });

    test(
        'C65907: user should be able to see "GET STARTED" button and tap on it',
        () async {
      await welcomeScreenObject.verifyGetStartedButtonIsDisplayed();
    });

    test(
        'C65908: user should be able to see "VIEW YOUR LAWN SUBSCRIPTION" button and tap on it',
        () async {
      await welcomeScreenObject
          .verifyViewYourLawnSubscriptionButtonIsDisplayed();
    });

    test('C65909: user should be able to see "LOG IN" button and tap on it',
        () async {
      await welcomeScreenObject.verifyLoginLinkIsDisplayed();
    });

    // TODO: Can't automate for now
    test(
        'C65910: user should be able to restart application and see welcome screen after splash screen',
        () async {
      await driver.requestData('restart');
    });
  });
}
