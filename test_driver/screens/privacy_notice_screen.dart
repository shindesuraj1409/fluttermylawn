import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class PrivacyNoticeScreen extends BaseScreen {
  final screen_header = find.byValueKey('privacy_notice');
  final privacy_notice_webview = find.byValueKey('privacy_notice_webview');

  PrivacyNoticeScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyPrivacyPolicyScreenElementsAreDisplayed() async {
    await verifyElementIsDisplayed(back_button);
    assert(await getText(screen_header) == 'Privacy Policy',
        'Header is not matched');
    await verifyElementIsDisplayed(privacy_notice_webview);
  }
}