import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/src/driver/driver.dart';

import 'screens.dart';

class StoreLocator extends BaseScreen {
  StoreLocator(FlutterDriver driver) : super(driver);
  final parent_list_view = find.byType('ListView');
  final list_text = find.text('LIST');
  final map_text = find.text('MAP');
  final enter_zipcode = find.byValueKey('enter_zipcode');
  final no_store_found = find.text('No store found!');
  final enable_location = find.byValueKey('enable_location');
  final location_icon = find.byValueKey('location_icon_of_wal_mart');
  final phone_icon = find.byValueKey('phone_icon_of_wal_mart');
  final call_text = find.text('CALL');
  final cancel_text = find.text('CANCEL');

  Future<void> verifyStoreLocatorScreenIsDisplayed(
      List<String> store_list) async {
    await verifyElementIsDisplayed(list_text);
    await verifyElementIsDisplayed(map_text);
    await verifyElementIsDisplayed(enter_zipcode);
    await verifyElementIsDisplayed(enable_location);
    for (var item in store_list) {
      await scrollUntilElementIsVisible(element: find.text(item), scrollableView: parent_list_view, dy: -50);
      await verifyElementIsDisplayed(find.text(item));
    }
  }

  Future<void> enterZipCode(String zipCode) async {
    await typeIn(enter_zipcode, zipCode);
  }

  Future<void> clickOnEnableLocation() async {
    await clickOn(enable_location);
  }

  Future<void> verifyStoreList(
      List<String> store_list_after_zip_code_change) async {
    for (var item in store_list_after_zip_code_change) {
      await scrollUntilElementIsVisible(element: find.text(item), scrollableView: parent_list_view, dy: -50);
      await verifyElementIsDisplayed(find.text(item));
    }
  }

  Future<void> verifyDirectionIcon() async {
    await verifyElementIsDisplayed(location_icon);
  }

  Future<void> verifyPhoneIcon() async {
    await verifyElementIsDisplayed(phone_icon);
  }

  Future<void> clickOnPhoneIcon() async {
    await clickOn(phone_icon);
  }

  Future<void> verifyPhoneDialogue() async {
    await verifyElementIsDisplayed(call_text);
    await verifyElementIsDisplayed(cancel_text);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_text);
  }

  Future<void> clickOnMap() async {
    await clickOn(map_text);
  }

  Future<void> verifyNoStoreFoundText() async {
    await verifyElementIsDisplayed(no_store_found);
  }
}
