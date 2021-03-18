import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class MyScottsAccountScreen extends BaseScreen {
  final name_row = find.byValueKey('name_row');
  final name_label = find.text('Name');
  final name_value = find.byValueKey('name_input');
  final name_icon = find.byValueKey('name_icon');
  final mayo_cooper = find.text('Mayo Cooper');

  final email_row = find.byValueKey('email_row');
  final email_label = find.text('Email');
  final email_value = find.byValueKey('email_input');
  final email_icon = find.byValueKey('email_icon');

  final subscribe_to_email_label = find.text('Subscribe to Scotts Emails');
  final subscribe_icon = find.byValueKey('subscribe_icon');
  final subscribe_to_email_toggle =
      find.byValueKey('subscribe_to_scotts_emails');
  final subscribe_button = find.byValueKey('subscribe_button');
  final go_back = find.byValueKey('go_back');
  final bottom_sheet_content = find.text(
    'By opting in, you are signing up to receive emails marketed '
    'by Scotts Miracle-Gro, its affiliates, and select partners '
    'with related tips, information, and promotions.',
  );
  final account_updated_text = find.text('Account updated successfully.');

  final create_password_row = find.byValueKey('create_new_password_row');
  final create_password_label = find.text('Create New Password');
  final create_new_pass_icon = find.byValueKey('create_new_pass_icon');
  final create_password_icon = find.byValueKey('create_new_password_icon');

  final logout_button = find.text('LOG OUT');

  // Bottom Drawer for Logout confirmation
  final drawer_title = find.text('Log Out?');
  final logout_confirmation_text = find
      .text("You'll need to log in again, to retrieve your lawn information.");
  final drawer_logout_button = find.byValueKey('drawer_logout_button');
  final drawer_go_back_button = find.byValueKey('go_back_button');

  // Change Name screen
  final first_name_input = find.byValueKey('first_name_input');
  final last_name_input = find.byValueKey('last_name_input');
  final save_button = find.byValueKey('save_button');

  MyScottsAccountScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyMyScottsAccountScreenIsDisplayed() async {
    await validate(await getText(header_title), 'My Scotts Account');
    await verifyElementIsDisplayed(back_button);

    await verifyElementIsDisplayed(name_row);
    await verifyElementIsDisplayed(name_label);

    await verifyElementIsDisplayed(email_row);
    await verifyElementIsDisplayed(email_label);
    await verifyElementIsDisplayed(email_icon);

    await verifyElementIsDisplayed(subscribe_to_email_label);
    await verifyElementIsDisplayed(subscribe_to_email_toggle);

    await verifyElementIsDisplayed(create_password_row);
    await verifyElementIsDisplayed(create_password_label);
    await verifyElementIsDisplayed(create_password_icon);

    await verifyElementIsDisplayed(logout_button);
  }

  Future<void> clickOnLogoutButton() async {
    await clickOn(logout_button);
  }

  Future<void> clickOnCreateNewPasswordButton() async {
    await clickOn(create_password_row);
  }

  Future<void> verifyLogoutDrawerIsDisplayed() async {
    await verifyElementIsDisplayed(drawer_title);
    await verifyElementIsDisplayed(logout_confirmation_text);
    await verifyElementIsDisplayed(drawer_logout_button);
    await verifyElementIsDisplayed(drawer_go_back_button);
  }

  Future<void> clickOnDrawerLogoutButton() async {
    await clickOn(drawer_logout_button);
  }

  Future<void> clickOnDrawerGoToBackButton() async {
    await clickOn(drawer_go_back_button);
  }

  Future<void> clickOnNameLink() async {
    await clickOn(name_value);
  }

  Future<void> enterName(String first_name, String last_name) async {
    await typeIn(first_name_input, first_name);
    await typeIn(last_name_input, last_name);
  }

  Future<void> verifyChangeNameScreenIsDisplayed() async {
    await validate(await getText(header_title), 'Change Name');
    await verifyElementIsDisplayed(first_name_input);
    await verifyElementIsDisplayed(last_name_input);
    await verifyElementIsDisplayed(save_button);
  }

  Future<void> clickOnSaveButton() async {
    await clickOn(save_button);
  }

  Future<void> verifyUpdatedName() async {
    await validate(
        (await getText(
            await find.descendant(of: name_row, matching: name_value))),
        'Mayo Cooper');
  }

  Future<void> clickOnSubscribeToEmailToggle() async {
    await clickOn(subscribe_to_email_toggle);
  }

  Future<void> verifySubscribeToEmailBottomSheet() async {
    await verifyElementIsDisplayed(subscribe_to_email_label);
    await verifyElementIsDisplayed(bottom_sheet_content);
    await verifyElementIsDisplayed(subscribe_button);
    await verifyElementIsDisplayed(go_back);
  }

  Future<void> clickOnSubscribe() async {
    await clickOn(subscribe_button);
  }

  Future<void> verifySnackBar() async {
    await verifyElementIsDisplayed(account_updated_text);
  }

  Future<void> verifySubscribeToEmailBottomSheetIsDissmissed() async {
    await verifyElementIsNotDisplayed(bottom_sheet_content);
    await verifyElementIsNotDisplayed(subscribe_button);
    await verifyElementIsNotDisplayed(go_back);
  }

  Future<void> clickOnEmailValue() async {
    await clickOn(email_value);
  }

  Future<void> enterEmail(String email) async {
    await typeIn(email_value, email);
  }

  Future<void> verifyChangeEmailAddressScreenIsDisplayed() async {
    await validate(await getText(header_title), 'Change Email Address');
    await verifyElementIsDisplayed(email_value);
    await verifyElementIsDisplayed(save_button);
  }

  Future<void> verifyUpdatedEmail(String email) async {
    await validate(
        (await getText(
            await find.descendant(of: email_row, matching: email_value))),
        email);
  }
}
