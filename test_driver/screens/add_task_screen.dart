import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class AddTaskScreen extends BaseScreen {
  final custom_scroll_view = find.byType('CustomScrollView');
  final screen_title = find.text('Add Task');
  final water_lawn_button = find.text('Water Lawn');
  final mow_lawn_button = find.text('Mow Lawn');
  final aerate_lawn_button = find.text('Aerate Lawn');
  final dethatch_lawn_button = find.text('Dethatch Lawn');
  final overseed_lawn_button = find.text('Overseed Lawn');
  final mulch_beds_button = find.text('Mulch Beds');
  final clean_deck_patio_button = find.text('Clean Deck / Patio');
  final winterize_sprinkler_system_button =
      find.text('Winterize Sprinkler System');
  final tune_up_mower_button = find.text('Tune up Mower');
  final create_your_own_button = find.text('Create Your Own');
  final cancel_button_task_screen =
      find.byValueKey('cancel_button_task_screen');

  AddTaskScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyAddTaskScreenCommonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(screen_title);
    await verifyElementIsDisplayed(water_lawn_button);
    await verifyElementIsDisplayed(mow_lawn_button);
    await verifyElementIsDisplayed(aerate_lawn_button);
    await verifyElementIsDisplayed(dethatch_lawn_button);
    await verifyElementIsDisplayed(overseed_lawn_button);
    await scrollTillElementIsVisible(mulch_beds_button,
        parent_finder: custom_scroll_view);
    await scrollTillElementIsVisible(clean_deck_patio_button,
        parent_finder: custom_scroll_view);
    await scrollTillElementIsVisible(winterize_sprinkler_system_button,
        parent_finder: custom_scroll_view);
    await scrollTillElementIsVisible(tune_up_mower_button,
        parent_finder: custom_scroll_view);
    await scrollTillElementIsVisible(create_your_own_button,
        parent_finder: custom_scroll_view);
  }

  Future<void> clickOnTask(String taskName) async {
    await scrollTillElementIsVisible(find.text(taskName),
        parent_finder: custom_scroll_view);
    await clickOn(find.text(taskName));
  }

  Future<void> clickOnOverseedLawnTaskButton() async {
    await clickOn(overseed_lawn_button);
  }

  //Click on Water Lawn Task button
  Future<void> clickOnWaterLawnTaskButton() async {
    await clickOn(water_lawn_button);
  }

  //Click on Mow Lawn Task button
  Future<void> clickOnMowLawnTaskButton() async {
    await clickOn(mow_lawn_button);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_button_task_screen);
  }
}
