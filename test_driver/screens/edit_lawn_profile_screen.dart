import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class EditLawnProfile extends BaseScreen {
  EditLawnProfile(FlutterDriver driver) : super(driver);

  final edit_lawn_profile = find.text('Edit Lawn Profile');

  final edit_lawn_desc_has_subscription = find.text(
      'Changing lawn conditions might result in getting products different from your current subscription.');
  final edit_lawn_desc_not_has_subscription = find.text(
      'Changing lawn conditions might result in getting different lawn product recommendations.');

  //lawn address section
  final lawn_address_has_subscription = find.byValueKey('lawn_address_label');
  final lawn_address_not_has_subscription = find.byValueKey('lawn_address');
  final lawn_address_value = find.byValueKey('lawn_address_value');

  //lawn size section
  final lawn_size_has_subscription = find.byValueKey('lawn_size_label');
  final lawn_size_not_has_subscription = find.byValueKey('lawn_size');
  final lawn_size_value = find.byValueKey('lawn_size_value');

  //Grass type section
  final grass_type = find.byValueKey('grass_type_label');
  final grass_type_value = find.byValueKey('grass_type_value');

  //Spreader type section
  final spreader_type = find.byValueKey('spreader_type_label');
  final spreader_type_value = find.byValueKey('spreader_type_value');

  //Lawn Condition section
  final lawn_condition = find.byValueKey('lawn_condition_label');
  final thickness = find.byValueKey('thickness_value');
  final color = find.byValueKey('color_value');
  final weeds_value = find.byValueKey('weeds_value');

  final bluegrass_rye_fescue = find.text('Bluegrass/Rye/Fescue');

  final wheeled_spreader = find.text('Wheeled Spreader');

  final retake_lawn_quiz = find.byValueKey('retake_lawn_quiz');
  final edit_lawn_profile_close_icon = find.byValueKey('close_icon');
  final just_moved_cancel_icon = find.byValueKey('cancel_icon');

  //Lawn Address Dialog/Alert
  final lawn_address_dialog_title =
      find.text('The lawn address is linked to your lawn data in your area.');
  final lawn_address_dialog_subtitle = find.text(
      'We recommend the right products based on your location, lawn conditions and grass type.');
  final lawn_address_dialog_i_have_moved_button = find.byValueKey('i_have_moved');
  final lawn_address_dialog_got_it_button = find.byValueKey('got_it');

//Just Moved dialog/alert
  final just_moved_dialog_title = find.text('Just moved?');
  final just_moved_dialog_sub_title = find.text(
      'When changing your lawn address, you would require to retake the lawn quiz for getting a new lawn plan.');
  final just_moved_dialog_retake_quiz_button = find.byValueKey('retake_quiz');

  Future<void> verifyEditProfileIsDisplayed(bool hasSubscription) async {

    await verifyElementIsDisplayed(edit_lawn_profile);
    hasSubscription
        ? await verifyElementIsDisplayed(edit_lawn_desc_has_subscription)
        : await verifyElementIsDisplayed(edit_lawn_desc_not_has_subscription);

    hasSubscription
    ? await verifyElementIsDisplayed(lawn_address_has_subscription)
    : await verifyElementIsDisplayed(lawn_address_not_has_subscription);
    await verifyElementIsDisplayed(lawn_address_value);

    hasSubscription
        ? await verifyElementIsDisplayed(lawn_size_has_subscription)
        : await verifyElementIsDisplayed(lawn_size_not_has_subscription);
    await verifyElementIsDisplayed(lawn_size_value);

    await verifyElementIsDisplayed(grass_type);
    await verifyElementIsDisplayed(grass_type_value);

    await verifyElementIsDisplayed(spreader_type);
    await verifyElementIsDisplayed(spreader_type_value);


    await verifyElementIsDisplayed(lawn_condition);
    await verifyElementIsDisplayed(thickness);
    await verifyElementIsDisplayed(color);
    await verifyElementIsDisplayed(weeds_value);

  }


  Future<void> validateLawnProfileValues(bool hasSubscription, {String grassType,
      String zipCode, var lawnSize, var spreaderType,
      var grassThickness, var grassColor, var weeds})async
  {
    if(grassType!=null) {
      await validate(
          (await getText(grass_type_value)), grassType);
    }

    if(zipCode!=null) {
      await validate(
          (await getText(lawn_address_value)), zipCode);
    }

    if(lawnSize!=null) {
      await validate(
          (await getText(lawn_size_value)), lawnSize.toString() + ' sqft');
    }


    if(spreaderType!=null) {
      await validate(
          (await getText(spreader_type_value)), spreaderType);
    }

    if(grassThickness!=null) {
      await validate(
          (await getText(thickness)), grassThickness);
    }

    if(grassColor!=null) {
      await validate(
          (await getText(color)), grassColor);
    }

    if(weeds!=null) {
      await validate(
          (await getText(weeds_value)), weeds);
    }

  }

  Future<void> clickOnRetakeLawnQuiz() async {
    await clickOn(retake_lawn_quiz);
  }

  //verify all elements of lawn address dialog/alert
  Future<void> verifyLawnAddressDialogElements() async {
    await verifyElementIsDisplayed(lawn_address_dialog_title);
    await verifyElementIsDisplayed(lawn_address_dialog_subtitle);
    await verifyElementIsDisplayed(lawn_address_dialog_i_have_moved_button);
    await verifyElementIsDisplayed(lawn_address_dialog_got_it_button);
  }


  //Verify all elements of Lawn address dialog/alert are not visible
  Future<void> verifyLawnAddressModalIsDismissed() async {
    await verifyElementIsNotDisplayed(lawn_address_dialog_title);
    await verifyElementIsNotDisplayed(lawn_address_dialog_subtitle);
    await verifyElementIsNotDisplayed(lawn_address_dialog_i_have_moved_button);
    await verifyElementIsNotDisplayed(lawn_address_dialog_got_it_button);
  }


  Future<void> clickOnGotItButton() async {
    await clickOn(lawn_address_dialog_got_it_button);
  }

  Future<void> clickOnIHaveMovedButton() async {
    await clickOn(lawn_address_dialog_i_have_moved_button);
  }

  Future<void> verifyJustMovedDialogElements() async {
    await verifyElementIsDisplayed(just_moved_cancel_icon);
    await verifyElementIsDisplayed(just_moved_dialog_title);
    await verifyElementIsDisplayed(just_moved_dialog_sub_title);
    await verifyElementIsDisplayed(just_moved_dialog_retake_quiz_button);
  }

  Future<void> verifyBottomSheetAfterClickingIHaveMovedIsDismissed() async {
    await verifyElementIsNotDisplayed(just_moved_dialog_title);
    await verifyElementIsNotDisplayed(just_moved_dialog_sub_title);
    await verifyElementIsNotDisplayed(just_moved_dialog_retake_quiz_button);
    await verifyElementIsNotDisplayed(just_moved_cancel_icon);
  }

  Future<void> clickOnJustMovedCloseIcon() async {
    await clickOn(just_moved_cancel_icon);
  }

  Future<void> clickOnRetakeQuizButton() async {
    await clickOn(just_moved_dialog_retake_quiz_button);
  }

  Future<void> clickOnEditLawnProfileSections(String sectionName, bool hasSubscription) async {
    var element;
    switch (sectionName) {
      case 'GrassType':
        element = grass_type;
        break;
      case 'LawnAddress':
         element = hasSubscription
            ? lawn_address_has_subscription
            : lawn_address_not_has_subscription;
        break;
      case 'LawnSize':
        element = hasSubscription
            ? lawn_size_has_subscription
            : lawn_size_not_has_subscription;
        break;
      case 'SpreaderType':
        element = spreader_type;
        break;
      case 'LawnCondition':
        element = lawn_condition;
        break;
      default:
        throw Exception('Option $sectionName not exists');
    }

    await clickOn(element);
  }


  Future<void> clickOnCloseIcon() async {
    await clickOn(edit_lawn_profile_close_icon);
  }



}
