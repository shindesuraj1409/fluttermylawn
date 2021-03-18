import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

void main() {
  FlutterDriver driver;

  // Screen objects
  SplashScreen splashScreen;
  WelcomeScreen welcomeScreen;
  LawnConditionScreen lawnConditionScreen;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionScreen = LawnConditionScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  test('traverse to lawn condition screen', () async {
    await splashScreen.verifySplashScreenIsDisplayed();
    await welcomeScreen.verifyWelcomeScreenIsDisplayed();
    await welcomeScreen.clickOnGetStartedButton();
  });

  test('C68411: user should be able to see default slider value', () async {
    await lawnConditionScreen.verifyLawnConditionIsDisplayed();
  });

  test('C68412: user should be able to change default value of color slider',
      () async {
    await lawnConditionScreen.setColorSliderValue('mostly_green');
  });

  test(
      'C68413: user should be able to change default value of thickness slider',
      () async {
    await lawnConditionScreen.setThicknessSliderValue('some_grass');
  });

  test('C68414: user should be able to change default value of weeds slider',
      () async {
    await lawnConditionScreen.setWeedsSliderValue('no_weeds');
  });

  test('minimize and reopen the app', () async {
    await Process.run(
      'adb',
      <String>['shell', 'input', 'keyevent', 'KEYCODE_HOME'],
      runInShell: true,
    );

    await Process.run(
      'adb',
      <String>['shell', 'monkey', '-p', 'com.scotts.lawnapp', '-v', '1'],
      runInShell: true,
    );
  }, timeout: Timeout(Duration(minutes: 5)));

  test('C68410: user should be able to proceed with default value of slider',
      () async {
    await lawnConditionScreen.goToBack();
    await welcomeScreen.clickOnGetStartedButton();
    await lawnConditionScreen.clickOnSaveButton();
  }, timeout: Timeout(Duration(minutes: 5)));
}
