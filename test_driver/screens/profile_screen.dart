import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class ProfileScreen extends BaseScreen {
  final grass_type_image = find.byValueKey('grass_type_image');
  final grass_name_label = find.byValueKey('grass_name_label');
  final lawn_size_value_label = find.byValueKey('lawn_size_value');
  final zip_code_label = find.byValueKey('zip_code');
  final spreader_type_label = find.byValueKey('spreader_type_label');

  final thickness_label = find.text('Thickness');
  final thickness_value = find.byValueKey('thickness_value');
  final color_label = find.text('Color');
  final color_value = find.byValueKey('color_value');
  final weeds_label = find.text('Weeds');
  final weeds_value = find.byValueKey('weeds_value');

  final edit_button = find.byValueKey('edit_button');

  final my_subscription_bloc = find.byValueKey('my_subscription');
  final get_products_delivered_bloc = find.byValueKey('get_products_delivered');
  final my_account_bloc = find.byValueKey('my_scotts_account');
  final app_settings_bloc = find.byValueKey('app_settings');
  final edit_your_lawn_profile = find.text('Edit your lawn profile?');
  final bottom_sheet_desc_for_edit_profile = find.text(
      'Changing lawn conditions might result in getting products different from your current subscription');
  final edit_profile_bottom_sheet_cancel_button =
      find.byValueKey('cancel_button');
  final edit_anyway_button = find.byValueKey('edit_anyway_button');
  final get_started = find.byValueKey('get_started');
  final continue_with_email = find.text('CONTINUE WITH EMAIL');

  ProfileScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyProfileScreenIsDisplayed({bool isGuest = false}) async {
    await validate(await getText(header_title), 'Profile');
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(grass_type_image);
    await verifyElementIsDisplayed(lawn_size_value_label);
    await verifyElementIsDisplayed(grass_name_label);
    await verifyElementIsDisplayed(zip_code_label);
    await verifyElementIsDisplayed(spreader_type_label);
    await verifyElementIsDisplayed(thickness_label);
    await verifyElementIsDisplayed(thickness_value);
    await verifyElementIsDisplayed(color_label);
    await verifyElementIsDisplayed(color_value);
    await verifyElementIsDisplayed(weeds_label);
    await verifyElementIsDisplayed(weeds_value);
    await verifyElementIsDisplayed(edit_button);
    if (!isGuest) {
      await verifyElementIsDisplayed(my_account_bloc);
    }
    await verifyElementIsDisplayed(app_settings_bloc);
  }

  Future<void> verifySelectedAnswerOnProfile(
      String size,
      String zip,
      String grass,
      String spreaderType,
      String thickness,
      String color,
      String weeds) async {
    await validate(await driver.getText(grass_name_label), grass);
    await validate(await driver.getText(lawn_size_value_label), '$size sqft');
    await validate(await driver.getText(zip_code_label), zip);
    await validate(await driver.getText(spreader_type_label), spreaderType);
    await validate(await driver.getText(thickness_value), thickness);
    await validate(await driver.getText(color_value), color);
    await validate(await driver.getText(weeds_value), weeds);
  }

  Future<void> clickOnMyScottsAccount() async {
    await clickOn(my_account_bloc);
  }

  Future<void> clickOnMySubscriptionAccount() async {
    await clickOn(my_subscription_bloc);
  }

  Future<void> clickOnEditButton() async {
    await clickOn(edit_button);
  }

  Future<void> clickOnEditAnywayButton() async {
    await clickOn(edit_anyway_button);
  }

  Future<void> verifyEditProfileBottomSheet() async {
    await verifyElementIsDisplayed(edit_your_lawn_profile);
    await verifyElementIsDisplayed(bottom_sheet_desc_for_edit_profile);
    await verifyElementIsDisplayed(edit_anyway_button);
    await verifyElementIsDisplayed(edit_profile_bottom_sheet_cancel_button);
  }

  Future<void> clickOnAppSettingsButton() async {
    await clickOn(app_settings_bloc);
  }

  Future<void> clickOnGetStarted() async {
    await clickOn(get_started);
  }

  Future<void> clickOnContinueWithEmail() async {
    await clickOn(continue_with_email);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(edit_profile_bottom_sheet_cancel_button);
  }

  Future<void> verifyEditProfileBottomSheetIsDismissed() async {
    await verifyElementIsNotDisplayed(edit_your_lawn_profile);
    await verifyElementIsNotDisplayed(bottom_sheet_desc_for_edit_profile);
    await verifyElementIsNotDisplayed(edit_profile_bottom_sheet_cancel_button);
  }

  Future<void> clickOnBackButton() async {
    await clickOn(back_button);
  }

  Future<void> clickOnGetProductsDeliveredBloc() async {
    await clickOn(get_products_delivered_bloc);
  }
}
