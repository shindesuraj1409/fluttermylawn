import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';

import 'base_screen.dart';

class CreateTaskScreen extends BaseScreen {
  final task_screen_back_button = find.byValueKey('back_button');
  final task_screen_icon = find.byValueKey('task_screen_icon');
  final remind_me_switch = find.byType('CupertinoSwitch');
  final selected_middle_text = find.byValueKey('selected_middle_text');
  final task_saved_notification = find.byValueKey('task_saved_notification');
  final cupertino_picker = find.byType('CupertinoPicker');

  final overseed_task_screen_title = find.text('Overseed Lawn');
  final overseed_task_screen_description = find.text(
      'For your [cool]-season grass, the best time to overseed your lawn is in the [fall].');
  final when_edit_button = find.text('Edit');
  final enter_task_notes_input =
      find.byValueKey('enter_task_notes_input_field');
  final thumbsup_icon = find.byValueKey('create_task_screen_thumbsup_icon');
  final save_task_button = find.text('SAVE');

  //Water Lawn Elements
  final water_task_screen_title = find.text('Water Lawn');
  final water_task_screen_description =
      find.text('Water deeply and infrequently to grow deep, healthy roots.');
  final how_much_label = find.text('How much');
  final repeat_label = find.text('Repeat');
  final remind_me_label = find.text('Remind me');

  //Mow Lawn Elements
  final mow_lawn_screen_title = find.text('Mow Lawn');
  final mow_task_screen_description = find.text(
      'Limit yourself to cutting just the top ⅓ of the grass blades or less.');

  //Aerate Lawn Elements
  final aerate_lawn_screen_title = find.text('Aerate Lawn');
  final aerate_task_description = find.text(
      'Aerate the lawn when your grass is in its peeking growing period.');

  //Dethatch Lawn Elements
  final dethatch_lawn_screen_title = find.text('Dethatch Lawn');
  final dethatch_task_description = find.text(
      'Dethatch your lawn when the thatch layer is > ¾ inch thick.');

  //Mulch Beds Lawn Elements
  final mulch_lawn_screen_title = find.text('Mulch Beds');
  final mulch_task_description = find.text(
      'For best results, mulch should be 2 to 3 inches deep.');

  //Clean Deck / Patio Lawn Elements
  final clean_deck_screen_title = find.text('Clean Deck / Patio');
  final clean_deck_task_description = find.text(
      'Get simple tips that help keep your driveway and walkways looking great.');

  final winterize_screen_title = find.text('Winterize Sprinkler System');

  final creat_own_screen_title= find.text('Create Your Own');
  //Tune up Mower Elements
  final tune_up_screen_title = find.text('Tune up Mower');
  final tune_up_task_description = find.text(
      'Proper maintenance in the fall or winter makes starting your lawn mower in the spring a snap.');


  final picker_scrollable_widget = find.byType('PickerWidget');

  final how_much_lawn_sizes = [
    '1/8" | 37 mins',
    '1/4" | 75 mins',
    '1/2" | 151 mins',
    '1" | 303 mins',
    '1 1/2" | 454 mins',
    '2" | 606 mins'
  ];

  final repeat_duration = [
    'Never',
    'Every day',
    'Every 3 days',
    'Every week',
    'Every other week',
    'Every month'
  ];

  CreateTaskScreen(FlutterDriver driver) : super(driver);

  Future<void>
      verifyCreateOverseedTaskScreenCommonElementsAreDisplayed() async {
    final now = DateTime.now();
    await verifyElementIsDisplayed(overseed_task_screen_title);
    await verifyElementIsDisplayed(
        find.text(DateFormat('EE MMM dd').format(now)));
    await verifyElementIsDisplayed(when_edit_button);
    await verifyElementIsDisplayed(enter_task_notes_input);
    await verifyElementIsDisplayed(overseed_task_screen_description);
    await verifyElementIsDisplayed(thumbsup_icon);
    await verifyElementIsDisplayed(save_task_button);
  }

  //Verify Task screen Elements
  Future<void> verifyTaskScreenCommonElementsAreDisplayed(
      String taskScreenName) async {
    if (taskScreenName.compareTo('Water Lawn') == 0) {
      await verifyElementIsDisplayed(water_task_screen_title);
      await verifyElementIsDisplayed(water_task_screen_description);

      //verify How Much field
      await verifyElementIsDisplayed(await find.descendant(
          of: form_field_parent, matching: how_much_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: find.ancestor(of: how_much_label, matching: form_field_parent),
          matching: edit_text));

      //Verify Remind Me field
      await verifyElementIsDisplayed(await find.descendant(
          of: form_field_parent, matching: remind_me_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: find.ancestor(of: remind_me_label, matching: form_field_parent),
          matching: remind_me_switch));

      await clickOnEditHowMuch();
      await verifyHowMuchLawnElements();
      await verifyElementIsDisplayed(thumbsup_icon);
    }

    if (taskScreenName.compareTo('Mow Lawn') == 0) {
      await verifyElementIsDisplayed(mow_lawn_screen_title);
      await verifyElementIsDisplayed(mow_task_screen_description);

      //Verify Remind Me field
      await verifyElementIsDisplayed(await find.descendant(
          of: form_field_parent, matching: remind_me_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: find.ancestor(of: remind_me_label, matching: form_field_parent),
          matching: remind_me_switch));
      await verifyElementIsDisplayed(thumbsup_icon);
    }
    if (taskScreenName.compareTo('Aerate Lawn') == 0) {
      await verifyElementIsDisplayed(aerate_lawn_screen_title);
      await verifyElementIsDisplayed(aerate_task_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }

    if (taskScreenName.compareTo('Clean Deck / Patio') == 0) {
      await verifyElementIsDisplayed(clean_deck_screen_title);
      await verifyElementIsDisplayed(clean_deck_task_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }

    if (taskScreenName.compareTo('Dethatch Lawn') == 0) {
      await verifyElementIsDisplayed(dethatch_lawn_screen_title);
      await verifyElementIsDisplayed(dethatch_task_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }
    if (taskScreenName.compareTo('Mulch Beds') == 0) {
      await verifyElementIsDisplayed(mulch_lawn_screen_title);
      await verifyElementIsDisplayed(mulch_task_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }

    if (taskScreenName.compareTo('Overseed Lawn') == 0) {
      await verifyElementIsDisplayed(overseed_task_screen_title);
      await verifyElementIsDisplayed(overseed_task_screen_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }

    if (taskScreenName.compareTo('Tune Up Mower') == 0) {
      await verifyElementIsDisplayed(tune_up_screen_title);
      await verifyElementIsDisplayed(tune_up_task_description);
      await verifyElementIsDisplayed(thumbsup_icon);
    }
    if (taskScreenName.compareTo('Winterize Sprinkler System') == 0) {
      await verifyElementIsDisplayed(winterize_screen_title);
    }

    await verifyElementIsDisplayed(task_screen_icon);
    //verify when field
    await verifyElementIsDisplayed(
        await find.descendant(of: form_field_parent, matching: when_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: find.ancestor(of: when_label, matching: form_field_parent),
        matching: selected_middle_text));
    await verifyElementIsDisplayed(await find.descendant(
        of: find.ancestor(of: when_label, matching: form_field_parent),
        matching: edit_text));

    //Verify Repeat Field
//    await verifyElementIsDisplayed(
//        await find.descendant(of: form_field_parent, matching: repeat_label));
//    await verifyElementIsDisplayed(await find.descendant(
//        of: find.ancestor(of: repeat_label, matching: form_field_parent),
//        matching: edit_text));
    //ToDo: Skipping verification till DMP-1201 is done

    await verifyElementIsDisplayed(save_task_button);
    //await clickOnEditRepeat();
    //await verifyRepeatDurationElements();
    //ToDo: Skipping verification till DMP-1201 is done

    await clickOnEditWhen();
    await verifyWhenFieldElements();
  }

  Future<void> fillOverseedTaskDetailsAndClickOnSave(taskNotes) async {
    await typeIn(enter_task_notes_input, taskNotes);
    await clickOnSaveButton();
  }

  Future<void> clickOnSaveButton() async {
    await clickOn(save_task_button);
  }

  //Click on Edit: How Much field
  Future<void> clickOnEditHowMuch() async {
    await clickOn(await find.descendant(
        of: find.ancestor(of: how_much_label, matching: form_field_parent),
        matching: edit_text));
  }

  //Click on Edit: Repeat
  Future<void> clickOnEditRepeat() async {
    await clickOn(await find.descendant(
        of: find.ancestor(of: repeat_label, matching: form_field_parent),
        matching: edit_text));
  }

  //Verify How_much_edit elements
  Future<void> verifyHowMuchLawnElements() async {
    await verifyElementIsDisplayed(cancel_button);
    await verifyElementIsDisplayed(select_button);
    await scrollElement(picker_scrollable_widget, dy: 700);
    for (var size in how_much_lawn_sizes) {
      final lawn_size = find.descendant(
          of: picker_scrollable_widget, matching: find.text(size));
      await verifyElementIsDisplayed(lawn_size);
      await scrollElement(lawn_size, dy: -50);
    }
    await clickOnCancelButton();
  }

  Future<void> verifyWhenFieldElements() async {
    await verifyElementIsDisplayed(cancel_button);
    await verifyElementIsDisplayed(select_button);
    await clickOnCancelButton();
  }

  //Verify Repeat elements
  Future<void> verifyRepeatDurationElements() async {
    await verifyElementIsDisplayed(cancel_button);
    await verifyElementIsDisplayed(select_button);
    await scrollElement(picker_scrollable_widget, dy: 700);
    for (var duration in repeat_duration) {
      final element = find.descendant(
          of: picker_scrollable_widget, matching: find.text(duration));
      await verifyElementIsDisplayed(element);
      await scrollElement(element, dy: -50);
    }
    await clickOnCancelButton();
  }

  //Click on cancel button
  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_button);
  }

  //Select How much lawn
  Future<void> selectHowMuchLawnSize(var lawnSize, {isGuest = false}) async {
    await clickOnEditHowMuch();
    await scrollElement(picker_scrollable_widget, dy: 700);
    if (!isGuest) {
      for (var size in how_much_lawn_sizes) {
        final lawn_size = find.descendant(
            of: picker_scrollable_widget, matching: find.text(size));
        await verifyElementIsDisplayed(lawn_size);
        if (size.contains(lawnSize)) {
          break;
        }
        await scrollElement(lawn_size, dy: -50);
      }
    }
    await clickOnSelectButton();
  }

  //Update How much lawn Size
  Future<void> updateHowMuchLawnSize(var lawnSizeToSelect) async {
    final currentLawnSize = await getText(await find.descendant(
        of: find.ancestor(of: how_much_label, matching: form_field_parent),
        matching: selected_middle_text));
    final indexOfCurrentSize = how_much_lawn_sizes.indexOf(currentLawnSize);
    final indexOfExpectedSize = how_much_lawn_sizes.indexOf(lawnSizeToSelect);
    if (indexOfCurrentSize.compareTo(indexOfExpectedSize) == 0) {
      null; //No change required
    } else if (indexOfCurrentSize.compareTo(indexOfExpectedSize) < 0) {
      await clickOnEditHowMuch();
      for (var i = indexOfCurrentSize; i < indexOfExpectedSize; i++) {
        final element = find.text(how_much_lawn_sizes.elementAt(i));
        final lawn_size =
            find.descendant(of: cupertino_picker, matching: element);
        await verifyElementIsDisplayed(lawn_size);
        await scrollElement(lawn_size, dy: -50);
      }
      await clickOnSelectButton();
    } else {
      await clickOnEditHowMuch();
      for (var i = indexOfCurrentSize; i > indexOfExpectedSize; i--) {
        final element = find.text(how_much_lawn_sizes.elementAt(i));
        final lawn_size =
            find.descendant(of: cupertino_picker, matching: element);
        await verifyElementIsDisplayed(lawn_size);
        await scrollElement(lawn_size, dy: 50);
      }
      await clickOnSelectButton();
    }
  }

  //Select Repeat Duration
  Future<void> selectRepeatDuration(var duration) async {
    await clickOnEditRepeat();
    await scrollElement(picker_scrollable_widget, dy: 700);
    for (var rep_duration in repeat_duration) {
      final element = find.descendant(
          of: picker_scrollable_widget, matching: find.text(rep_duration));
      await verifyElementIsDisplayed(element);
      if (rep_duration.contains(duration)) {
        break;
      }
      await scrollElement(element, dy: -50);
    }
    await clickOnSelectButton();
  }

  Future<void> enableRemindMe(var enable) async {
    switch (enable) {
      case 'ON':
        {
          await clickOn(remind_me_switch);
          break;
        }
      case 'OFF':
        {
          break;
        }
      default:
        {
          throw Exception('Invalid test Data: $enable.  Should be On/OFF');
        }
    }
  }

  Future<void> addTaskNotes(var taskNotes) async {
    await typeIn(enter_task_notes_input, taskNotes);
  }

  Future<String> selectFutureDate() async {
    await clickOnEditWhen();
    //Scroll to Future Month
    final currentMonth = find.text(currentDate.split(' ')[0]);
    await verifyElementIsDisplayed(currentMonth);
    await scrollElement(currentMonth, dy: -50);

    //Scroll to Future Day
    final currentDay = find.text(currentDate.split(' ')[1]);
    await verifyElementIsDisplayed(currentDay);
    await scrollElement(currentDay, dy: -50);
    await clickOnSelectButton();
    final dateSelectedOnTaskScreen = await getText(await find.descendant(
        of: find.ancestor(of: when_label, matching: form_field_parent),
        matching: selected_middle_text));
    return dateSelectedOnTaskScreen;
  }

  Future<void> selectTodayDate() async {
    await clickOnEditWhen();
    //Scroll to Previous Month
    final currentMonth = find.text(currentDate.split(' ')[0]);
    await verifyElementIsDisplayed(currentMonth);
    await scrollElement(currentMonth, dy: 50);

    //Scroll to Previous Day
    final currentDay = find.text(currentDate.split(' ')[1]);
    await verifyElementIsDisplayed(currentDay);
    await scrollElement(currentDay, dy: 50);

    await clickOnSelectButton();
  }

  Future<void> verifyDateOnTaskScreen(var expectedDate) async {
    final dateSelectedOnTaskScreen = await getText(await find.descendant(
        of: find.ancestor(of: when_label, matching: form_field_parent),
        matching: selected_middle_text));

    await validate(dateSelectedOnTaskScreen, expectedDate);
  }

  Future<void> verifySelectedLawnSize(var expectedLawnSize) async {
    final lawnSizeDisplayed = await getText(await find.descendant(
        of: find.ancestor(of: how_much_label, matching: form_field_parent),
        matching: selected_middle_text));

    await validate(lawnSizeDisplayed, expectedLawnSize);
  }

  Future<void> verifySelectedRepeatDuration(var expectedRepeatDuration) async {
    final repeatDurationDisplayed = await getText(await find.descendant(
        of: find.ancestor(of: repeat_label, matching: form_field_parent),
        matching: selected_middle_text));

    await validate(repeatDurationDisplayed, expectedRepeatDuration);
  }

  Future<void> verifyAddedTaskNoteOnTaskScreen(var expectedTaskNote) async {
    final enteredTaskNote = await getText(enter_task_notes_input);

    await validate(enteredTaskNote, expectedTaskNote);
  }

  Future<void> verifyTaskSavedNotificationIsDisplayed(
      var notificationText) async {
    await verifyElementIsDisplayed(task_saved_notification, runUnsynchronized: true);
    await driver.runUnsynchronized(() async {
      await validate(await getText(task_saved_notification), notificationText);
    });
  }
}
