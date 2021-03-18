import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class SplashScreen extends BaseScreen {
  SplashScreen(FlutterDriver driver) : super(driver);

  Future<void> verifySplashScreenIsDisplayed() async {
    await verifyElementIsDisplayed(scotts_logo);
    await verifyElementIsDisplayed(my_lawn_image);
    await verifyElementIsDisplayed(by_word);
  }
}
