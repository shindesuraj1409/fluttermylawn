import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class SpreaderTypesScreen extends BaseScreen {
  final screen_title = find.text('Do you have a spreader?');
  final screen_description = find.text(
      'A spreader helps evenly apply products to your lawn. Select the type of spreader you use most often.');
  final wheeled_spreader_option =
      find.byValueKey('yes__i_have_a_wheeled_spreader_option');
  final handheld_spreader_option =
      find.byValueKey('yes__i_have_a_handheld_spreader_option');
  final no_spreader_option =
      find.byValueKey('no__i_don_t_have_a_spreader_option');
  final progress_bar_value = find.byValueKey('progress_bar_value_0.5');
  final spreader_type_screen_info_icon_button =
      find.byValueKey('spreader_type_screen_info_icon_button');
  final why_need_spreader = find.text('Why do I need a spreader?');
  final spreader_desc = find.text(
      'A spreader helps you apply the right amount of lawn food, weed control, or grass seed uniformly to your entire lawn. Using one helps ensure you don\'t apply too much product (which could damage your lawn) or too little.');
  final got_it = find.byValueKey('got_it');

  SpreaderTypesScreen(FlutterDriver driver) : super(driver);

  Future<void> verifySpreaderTypeScreenIsDisplayed({bool edit = false}) async {
    await verifyElementIsDisplayed(screen_title);
    await verifyElementIsDisplayed(screen_description);
    await verifyElementIsDisplayed(wheeled_spreader_option);
    await verifyElementIsDisplayed(handheld_spreader_option);
    await verifyElementIsDisplayed(no_spreader_option);
    await verifyElementIsDisplayed(back_button);
    if (!edit) {
      await verifyElementIsDisplayed(progress_bar_value);
    }
  }

  Future<void> clickOnWheeledSpreaderOption() async {
    await clickOn(wheeled_spreader_option);
  }

  Future<void> selectSpreader(String spreaderType) async {
    switch (spreaderType) {
      case 'wheeled':
        await clickOn(wheeled_spreader_option);
        break;
      case 'handheld':
        await clickOn(handheld_spreader_option);
        break;
      case 'no':
        await clickOn(no_spreader_option);
        break;
    }
  }

  Future<void> clickOnBackButton() async {
    await clickOn(back_button);
  }

  Future<void> clickOnSpreaderTypeScreenInfoIconButton() async {
    await clickOn(spreader_type_screen_info_icon_button);
  }

  Future<void> verifyWhyNeedSpreaderBottomSheet() async {
    await verifyElementIsDisplayed(why_need_spreader);
    await verifyElementIsDisplayed(spreader_desc);
    await verifyElementIsDisplayed(got_it);
  }

  Future<void> clickOnGotIt() async {
    await clickOn(got_it);
  }
}
