import 'dart:io';

import 'package:flutter_driver/src/common/find.dart';
import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class SprinklerSettingsScreen extends BaseScreen {
  SprinklerSettingsScreen(FlutterDriver driver) : super(driver);
  final List<String> data = [
    'Sprinklers',
    'Rotors',
    'Drip',
    'Sprays',
    'Bubbler'
  ];

  final plan_screen_parent = find.byType('CustomScrollView');

  final showSprinklersDialogue = find.byValueKey('info_transparent');
  SerializableFinder sprinklersDialogue(inches) => find.text(
      'An average applies ${inches} inch of water every 30 minutes. You can modify this flow rate for your sprinkler nozzle. It\'s recommended to water a total of 1 inch per week');
  final cancelButton = find.byValueKey('cancel_button_of_sprinkler_flow_rate');
  final cancelButtonOfBottomSheet =
      find.byValueKey('cancel_button_of_sprinkler_flow_rate_bottom_sheet');
  final customizeButton =
      find.byValueKey('customize_button_of_sprinkler_flow_rate');
  final sprinklerScreenTitle = find.text('What\'s your nozzle type?');
  final sprinklerScreenDesc = find.text(
      'Select nozzle type to set your flow rate. It helps more accurate runtime for your sprinkler.');
  final gridViewOfSprinklerScreen =
      find.byValueKey('grid_view_of_sprinkler_flow_rate');
  final sprinklersGridViewItem =
      find.byValueKey('grid_view_item_of_sprinkler_flow_rate_Sprinklers');
  final weatherDataLoadedWidget = find.byType('WeatherDataLoaded');
  final afterSprinklerSelectedShowDesc = find.text(
      'Propelled in a circular motion by arm that repeatedly strikes the out going stream, spraying the water over a large area.');
  final useThisFlowRateButton = find.byValueKey('use_this_flow_rate');
  final back_button_sprinkler = find.byValueKey('back_button');
  final subscribe_now_button = find.text('SUBSCRIBE NOW');
  final sprinklerFlowRateText = find.text('Sprinklers Flow Rate');
  final cancelButtonOfSelectedNozzleType =
      find.byValueKey('cancel_button_of_selected_nozzle_type');

  Future<void> verifySprinklerDialog(inches) async {
    sleep(Duration(seconds: 1));
    await verifyElementIsDisplayed(sprinklersDialogue(inches));
  }

  Future<void> verifySprinklerScreenBottomSheet() async {
    sleep(Duration(seconds: 1));
    await verifyElementIsDisplayed(sprinklerScreenTitle);
    await verifyElementIsDisplayed(sprinklerScreenDesc);
    await verifyElementIsDisplayed(gridViewOfSprinklerScreen);
  }

  Future<void> scrollTillTheEndOfRainFallTrackWidget() async {
    final subscribe_now_button_coordinates =
        await driver.getCenter(subscribe_now_button);
    await scrollElement(plan_screen_parent,
        dy: (0 - subscribe_now_button_coordinates.dy), timeout: 1000);
  }

  Future<void> clickOnSprinklersGridViewItem() async {
    sleep(Duration(seconds: 1));
    await clickOn(sprinklersGridViewItem);
  }

  Future<bool> isInfoTransparentIconPresent() async {
    return await isPresent(showSprinklersDialogue);
  }

  Future<void> clickOnInfoTransparentIcon() async {
    sleep(Duration(seconds: 1));
    await clickOn(showSprinklersDialogue);
  }

  Future<void> clickOnCancelButtonOfSprinklersFlowRate() async {
    sleep(Duration(seconds: 1));
    await clickOn(cancelButton);
  }

  Future<void> clickOnCancelButtonOfSprinklersDialogue() async {
    sleep(Duration(seconds: 1));
    await clickOn(cancelButtonOfBottomSheet);
  }

  Future<void> clickOnCustomizedButton() async {
    sleep(Duration(seconds: 1));
    await clickOn(customizeButton);
  }

  Future<void> verifyBottomSheetAfterSprinklersSelected() async {
    await verifyElementIsDisplayed(sprinklerFlowRateText);
    await verifyElementIsDisplayed(afterSprinklerSelectedShowDesc);
  }

  Future<void> clickOnCancelButtonOfSelectedNozzleType() async {
    sleep(Duration(seconds: 1));
    await clickOn(cancelButtonOfSelectedNozzleType);
  }

  Future<void> clickOnUseThisFlowRateButton() async {
    sleep(Duration(seconds: 1));
    await clickOn(useThisFlowRateButton);
  }

  Future<void> clickOnBackButton() async {
    await clickOn(back_button_sprinkler);
  }
}
