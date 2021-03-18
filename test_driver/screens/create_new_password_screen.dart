import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class CreateNewPasswordScreen extends BaseScreen {
  final old_password_input = find.byValueKey('old_password_input');
  final new_password_input = find.byValueKey('new_password_input');
  final set_new_password = find.text('SET NEW PASSWORD');

  CreateNewPasswordScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyCreateNewPasswordScreenIsDisplayed() async {
    await validate(await getText(header_title), 'Create New Password');
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(old_password_input);
    await verifyElementIsDisplayed(new_password_input);
    await verifyElementIsDisplayed(set_new_password);
  }

  Future<void> enterOldPassword(String password) async {
    await typeIn(old_password_input, password);
  }

  Future<void> enterNewPassword(String password) async {
    await typeIn(new_password_input, password);
  }

  Future<void> clickOnSetNewPasswordButton() async {
    await sleep(Duration(seconds: 2));
    await clickOn(set_new_password);
  }
}
