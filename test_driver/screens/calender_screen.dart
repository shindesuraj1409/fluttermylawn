import 'package:flutter_driver/src/driver/driver.dart';
import 'package:intl/intl.dart';

import 'base_screen.dart';

class CalenderScreen extends BaseScreen {
  CalenderScreen(FlutterDriver driver) : super(driver);

  final added_by_me = find.byValueKey('added_by_me');
  final arrow_button = find.byValueKey('arrow_button');
  final today_label = find.text('TODAY');
  final product_button = find.text('PRODUCTS');
  final tasks_button = find.text('TASKS');
  final notes_button = find.text('NOTES');
  final water_button = find.text('WATER');
  final search_button = find.byValueKey('search_icon');
  final date_month_label = find.byValueKey('event_month');
  final event_date = find.byValueKey('event_date');
  final note_description = find.byValueKey('note_description');
  final edit_button = find.text('EDIT');
  final bottom_sheet_cancel_button = find.byValueKey('cancel_button');
  final delete_icon = find.byValueKey('delete_icon');
  final task_date_details = find.byValueKey('task_date_details');
  final details_screen_icon = find.byValueKey('details_screen_icon');
  final parent_taskDetails = find.byType('TaskDetails');
  final calendar_event_parent = 'calendar_event_item_';

  Future<void> verifyAddedByMeCalender(DateTime date, var productName) async {
    final _monthFormat = DateFormat('MMM');
    var i = 0;
    var event_found = 0;

    while(event_found==0)
      {
        try{
          final parentElement = find.byValueKey(calendar_event_parent+i.toString());
          await verifyElementIsDisplayed(parentElement);
          final event_day = find.descendant(of: parentElement, matching: event_date);
          final event_month = find.descendant(of: parentElement, matching: date_month_label);

          final cardDay = await getText(event_day);
          final day = date.day.toString();
          final cardMonth = await getText(event_month);
          final month = _monthFormat.format(date);
          if(cardDay==day && cardMonth == month)
            {
              await verifyElementIsDisplayed(find.descendant(of: parentElement, matching: find.text(productName)));
              await verifyElementIsDisplayed(find.descendant(of: parentElement, matching: added_by_me));
              await verifyElementIsDisplayed(event_day);
              await verifyElementIsDisplayed(event_month);
              event_found = 1;
              break;
            }
        }
        catch(e)
    {
      throw Exception('Product $productName not found in the list');

    }
    i++;
      }

  }

  Future<void> verifyCalenderScreenCommonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(arrow_button);
    await verifyElementIsDisplayed(today_label);
    await verifyElementIsDisplayed(product_button);
    await verifyElementIsDisplayed(tasks_button);
    await verifyElementIsDisplayed(notes_button);
    await verifyElementIsDisplayed(water_button);
    await verifyElementIsDisplayed(search_button);
    await verifyElementIsDisplayed(date_month_label);
  }

  Future<void> verifyNote(String note) async {
    await validate(await getText(note_description), note);
  }

  Future<void> verifyTask(String task_note) async {
    await validate(await getText(find.text(task_note)), task_note);
  }

  Future<void> verifyTaskDetails(String taskTitle,
      {String taskNote, String repeatDuration}) async {
    //Click on task added
    await clickOn(find.text(taskNote));
    //Delete button
    await verifyElementIsDisplayed(delete_icon);
    //Close button
    await verifyElementIsDisplayed(bottom_sheet_cancel_button);
    //Verify icon
    await verifyElementIsDisplayed(details_screen_icon);
    //Verify Title
    await verifyElementIsDisplayed(find.text(taskTitle));
    //Verify Date
    await verifyElementIsDisplayed(task_date_details);

    //Verify repeat duration
    if (repeatDuration != null) {
      await verifyElementIsDisplayed(find.text('Repeat'));
      await verifyElementIsDisplayed(
          find.text(repeatDuration.toLowerCase().replaceAll(' ', '_')));
    }

    //Verify Notes
    if (taskNote != null) {
      await verifyElementIsDisplayed(find.text('Notes'));
      await validate(
          await getText(find.descendant(
              of: parent_taskDetails, matching: find.text(taskNote))),
          taskNote);
    }

    //Edit button
    await verifyElementIsDisplayed(edit_button);
  }

  //Tap on Edit button
  Future<void> clickOnEditTaskButton() async {
    await clickOn(edit_button);
  }

  //Tap on close button of Task Details pop up
  Future<void> clickOnCancelButton() async {
    await clickOn(bottom_sheet_cancel_button);
  }

  //Verify task is displayed on Calendar Screen
  Future<void> verifyTaskAddedOnCalenderScreen(
      var taskIndex, var taskName, var day, var month, bool isFutureTask,
      {var repeatDuration, var taskNote, String remindMe}) async {
    taskIndex = taskIndex - 1;
    day = int.parse(day).toString();
    final task_parent_card = find.byValueKey('calendar_event_item_$taskIndex');
    await verifyElementIsDisplayed(task_parent_card);
    await verifyElementIsDisplayed(
        find.descendant(of: task_parent_card, matching: find.text(taskName)));
    //Verify Month is displayed
    final monthDisplayed =
        find.descendant(of: task_parent_card, matching: date_month_label);
    await verifyElementIsDisplayed(monthDisplayed);
    await validate(await getText(monthDisplayed), month);
    //Verify Date displayed
    final dayDisplayed =
        find.descendant(of: task_parent_card, matching: event_date);
    await verifyElementIsDisplayed(monthDisplayed);
    await validate(await getText(dayDisplayed), day);

    if (isFutureTask) {
      if (remindMe.compareTo('ON') == 0) {
        await verifyElementIsDisplayed(find.descendant(
            of: task_parent_card, matching: find.text('Remind me')));
      }
      await verifyElementIsDisplayed(
          find.descendant(of: task_parent_card, matching: find.text('MARK AS DONE')));
    } else {
      await verifyElementIsDisplayed(
          find.descendant(of: task_parent_card, matching: find.text('Done')));
    }

    if (repeatDuration != null) {
      repeatDuration =
          repeatDuration.toString().toLowerCase().replaceAll(' ', '_');
      await verifyElementIsDisplayed(find.descendant(
          of: task_parent_card, matching: find.text(repeatDuration)));
    }

    if (taskNote != null) {
      await verifyElementIsDisplayed(
          find.descendant(of: task_parent_card, matching: find.text(taskNote)));
    }
  }
}
