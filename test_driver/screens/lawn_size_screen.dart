import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class LawnSizeScreen extends BaseScreen {
  final section_title = find.text('What size is your lawn?');
  final lawn_address_input =
      find.byValueKey('lawn_address_screen_address_input');
  final manually_enter_lawn_size_link =
      find.byValueKey('lawn_address_screen_square_footage_manually_link');
  final continue_button = find.text('CONTINUE');
  final location_icon_button =
      find.byValueKey('lawn_size_screen_location_icon_button');
  final address = find.byValueKey('165 North School Street, Honolulu, HI, USA');
  final measure_your_lawn = find.text(
      'To measure your lawn, start by tapping on each corner. This will create a basic outline.');
  final got_it = find.byValueKey('got_it');
  final tracing_gif = find.byValueKey('tracing_gif');
  final progress_bar_value = find.byValueKey('progress_bar_value_0.75');

  LawnSizeScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyLawnSizeScreenIsDisplayed({bool edit=false}) async {
    await verifyElementIsDisplayed(section_title);
    await verifyElementIsDisplayed(lawn_address_input);
    await verifyElementIsDisplayed(manually_enter_lawn_size_link);
    await verifyElementIsDisplayed(continue_button);
    await verifyElementIsDisplayed(back_button);
    if(!edit) {
      await verifyElementIsDisplayed(progress_bar_value);
    }
  }

  Future<void> typeInAddressInput(String address) async {
    await typeIn(lawn_address_input, address);
  }

  Future<void> verifyAddressIsDisplayedInAutoSuggestion(String address) async {
    await verifyElementIsDisplayed(find.text(address));
  }

  Future<void> clickOnManualEnterLawnSizeLink() async {
    await clickOn(manually_enter_lawn_size_link);
  }

  Future<void> clickOnLocationOrCancelButton() async {
    await clickOn(location_icon_button);
  }

  Future<void> clickOnAddress() async {
    await clickOn(address);
  }

  Future<void> verifyLawnSizeMeasuringInstruction() async {
    await verifyElementIsDisplayed(measure_your_lawn);
    await verifyElementIsDisplayed(got_it);
    await verifyElementIsDisplayed(tracing_gif);
  }

  Future<void> clickOnGotIt() async {
    await clickOn(got_it);
  }

  Future<void> clickOnBackButton() async
  {
    await clickOn(back_button);
  }
}

