import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class ManualEntryScreen extends BaseScreen {
  final manual_entry_screen_title =
      find.text('Great! Tell us about the size of your lawn');
  final manual_entry_screen_subtitle =
      find.text('This helps us send you the right amount of products.');
  final zip_code_input = find.byValueKey('ScottsTextInput.zipCode');
  final lawn_size_input = find.byValueKey('ScottsTextInput.lawnSize');

  final continue_button = find.text('CONTINUE');
  final invalid_zip_code_error = find.text('Please enter a valid zip code');
  final progress_bar_value = find.byValueKey('progress_bar_value_0.75');


  ManualEntryScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyManualEntryScreenIsDisplayed({bool edit=false}) async {
    await verifyElementIsDisplayed(manual_entry_screen_title);
    await verifyElementIsDisplayed(manual_entry_screen_subtitle);
    await verifyElementIsDisplayed(zip_code_input);
    await verifyElementIsDisplayed(lawn_size_input);
    await verifyElementIsDisplayed(continue_button);
    await verifyElementIsDisplayed(back_button);
    if(!edit) {
      await verifyElementIsDisplayed(progress_bar_value);
    }
  }

  Future<void> setZipCodeAndLawnSizeData(
      String zipCode, String lawnSize) async {
    await typeInZipCodeInputField(zipCode);
    await typeInLawnSizeInputField(lawnSize);
  }

  Future<void> typeInZipCodeInputField(String zipCode) async {
    await typeIn(zip_code_input, zipCode);
  }

  Future<void> typeInLawnSizeInputField(String lawnSize) async {
    await typeIn(lawn_size_input, lawnSize);
  }

  Future<void> invalidZipCodeErrorIsDisplayed() async {
    await verifyElementIsDisplayed(invalid_zip_code_error);
  }

  Future<void> clickOnContinueButton() async {
    await clickOn(continue_button);
  }

  Future<void> clickOnBackButton() async
  {
    await clickOn(back_button);
  }
}
