import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/src/driver/driver.dart';

import 'screens.dart';

class AddProductScreen extends BaseScreen {
  AddProductScreen(FlutterDriver driver) : super(driver);

  final add_product = find.byValueKey('add_product');
  final product_name = find.byValueKey('product_name');
  final product_image = find.byValueKey('product_image');
  //final product = find.text('Scotts® Turf Builder® Weed & Feed₃');
  final when = find.text('When');
  final add_product_image = find.byValueKey('add_product_image');
  final edit_button = find.byValueKey('edit_button');
  final date = find.byValueKey('selected_middle_text');
  final text_box = find.byValueKey('text_box');
  final characters_count = find.byValueKey('characters_count');
  final save_button = find.byValueKey('save');
  final product_added_notification = find.byValueKey('task_saved_notification');



  Future<void> verifyAddProductScreen(var productName) async {
    await verifyElementIsDisplayed(add_product);
    //await verifyElementIsDisplayed(product);
    await verifyElementIsDisplayed(product_name);
    await validate((await getText(product_name)).toString(), productName);
    await verifyElementIsDisplayed(product_image);
    await verifyElementIsDisplayed(when);
    await verifyElementIsDisplayed(add_product_image);
    await verifyElementIsDisplayed(edit_button);
    await verifyElementIsDisplayed(date);
    await verifyElementIsDisplayed(text_box);
    await verifyElementIsDisplayed(characters_count);
    await verifyElementIsDisplayed(save_button);
    await verifyElementIsDisplayed(back_button);
  }

  Future<void> clickOnEditButton() async
  {
    await clickOn(edit_button);
  }

  Future<void> clickOnSaveButton() async
  {
    await clickOn(save_button);
  }

  Future<void> enterTextInTextBox(String text) async
  {
    await typeIn(text_box, text);
  }

  Future<void> clickOnBackIcon() async
  {
    await clickOn(back_button);
  }

  Future<void> verifyProductAddedNotificationIsDisplayed(
      var notificationText) async {
    await verifyElementIsDisplayed(product_added_notification, runUnsynchronized: true);
    await driver.runUnsynchronized(() async {
      await validate(await getText(product_added_notification), notificationText);
    });
  }



}
