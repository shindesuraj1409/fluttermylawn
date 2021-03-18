import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class ConditionOfUseScreen extends BaseScreen {
// All elements of Terms & Conditions screen
    final screen_header = find.byValueKey('conditions_of_use');
  final condition_of_use_webview =
      find.byValueKey('conditions_of_use_webview');

    ConditionOfUseScreen(FlutterDriver driver) : super(driver);

  // Verify "Terms & Conditions Screen" is displayed
  Future<void> verifyConditionsOfUseScreenElementsAreDisplayed() async {
//    await verifyElementIsDisplayed(back_button);
    assert(await getText(screen_header) == 'Conditions of Use',
        'Screen header is not displayed');
    await verifyElementIsDisplayed(condition_of_use_webview);
  }
}
