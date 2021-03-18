import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';

class BaseScreen {
  final screen_scrollable_view = find.byType('CustomScrollView');
  final scotts_logo = find.byValueKey('scotts_logo');
  final my_lawn_image = find.byValueKey('my_lawn_image');
  final by_word = find.text('by');
  final back_button = find.byValueKey('back_button');
  final header_title = find.byValueKey('header_title');
  var result;
  final python = 'python3';
  final emailParser = 'test_driver/utils/email_parser.py';
  final currentDate = DateFormat('MMMM d yyyy').format(DateTime.now());
  final monthList = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  final when_label = find.text('When');
  final form_field_parent = find.byType('FormFieldContent');
  final edit_text = find.text('Edit');
  final select_button = find.text('SELECT');
  final cancel_button = find.text('CANCEL');
  final date_picker = find.byValueKey('date_picker');


  FlutterDriver driver;

  BaseScreen(FlutterDriver driver) {
    this.driver = driver;
  }

  Future<void> verifyElementIsDisplayed(SerializableFinder finder,
      {int timeout = 30, bool runUnsynchronized = false}) async {
    if (runUnsynchronized) {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(finder, timeout: Duration(seconds: timeout));
      });
    } else {
      await driver.waitFor(finder, timeout: Duration(seconds: timeout));
    }
  }

  Future<void> verifyElementIsNotDisplayed(SerializableFinder finder,
      {int timeout = 30, bool runUnsynchronized = false}) async {
    if (runUnsynchronized) {
      await driver.runUnsynchronized(() async {
        await driver.waitForAbsent(finder, timeout: Duration(seconds: timeout));
      });
    } else {
      await driver.waitForAbsent(finder, timeout: Duration(seconds: timeout));
    }
  }

  Future<void> typeIn(SerializableFinder finder, String text) async {
    await clickOn(finder);
    await sleep(Duration(seconds: 1));
    await driver.enterText(text);
    await sleep(Duration(seconds: 1));
  }

  // set runUnsynchronized as true to disable frame sync
  Future<void> clickOn(SerializableFinder finder,
      {bool runUnsynchronized = false}) async {
    if (runUnsynchronized) {
      await driver.runUnsynchronized(() async {
        await verifyElementIsDisplayed(finder);
        await driver.tap(finder);
      });
    } else {
      await verifyElementIsDisplayed(finder);
      await driver.tap(finder);
    }
  }

  Future<String> getText(SerializableFinder finder) async {
    return await driver.getText(finder);
  }

  Future<void> scrollElement(SerializableFinder finder,
      {double dx = 0, double dy = 0, int timeout = 500}) async {
    final dim = await driver.getBottomRight(await find.byType('MaterialApp'));

    await (dx != 0) ? dx = dim.dx * (dx / 100) : 0;
    await (dy != 0) ? dx = dim.dy * (dy / 100) : 0;

    await driver.scroll(finder, dx, dy, Duration(milliseconds: timeout));
  }

  Future<void> goToBack() async {
    return await driver.tap(find.pageBack());
  }

  Future<String> getFormattedTimeStamp() async {
    return await DateTime.now()
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w]'), '_');
  }

  Future<bool> waitForElementToLoad(String locatorType, String locator) async {
    var counter = 10;

    while (counter > 0) {
      try {
        switch (locatorType) {
          case 'key':
            await find.byValueKey(locator);
            break;

          case 'text':
            await find.text(locator);
            break;
        }

        await sleep(Duration(seconds: 1));
        return true;
      } on Exception {
        await sleep(Duration(seconds: 1));
      }

      counter--;
    }

    throw Exception(
        'Failed to find the element $locatorType:$locator within 150 seconds');
  }

  Future<void> scrollTillElementIsVisible(SerializableFinder element_finder,
      {SerializableFinder parent_finder,
      double alignmentVal = 0.0,
      double dx = 0,
      double dy = 0,
      int timeoutVal = 60,
      runUnsynchronized = false}) async {
    parent_finder = (parent_finder != null)
        ? await find.byType('MaterialApp')
        : parent_finder;

    if (runUnsynchronized) {
      await driver.runUnsynchronized(() async {
        await driver.scrollUntilVisible(parent_finder, element_finder,
            alignment: alignmentVal,
            dxScroll: dx,
            dyScroll: dy,
            timeout: Duration(seconds: timeoutVal));
      });
    } else {
      await driver.scrollUntilVisible(parent_finder, element_finder,
          alignment: alignmentVal,
          dxScroll: dx,
          dyScroll: dy,
          timeout: Duration(seconds: timeoutVal));
    }
    await sleep(Duration(seconds: 1));
  }

  Future<void> validate(String actual, String expected,
      {String message = '', bool op = true}) async {
    if (expected != actual) {
      if (op) {
        throw await Exception(
            'Validation failed Expected: --$expected--, Actual: --$actual--: Message:$message');
      }
    }
  }

  Future<bool> isPresent(SerializableFinder finder) async {
    try {
      await driver.waitFor(finder, timeout: Duration(seconds: 10));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> readingEmail(String email,String emailSubject, String text) async {
    try {
      var ts = await email.toString().substring(
            email.toString().indexOf('+') + 1,
            email.toString().indexOf('@'),
          );
      await print(ts);
      result = await Process.run(
        python,
        [emailParser, ts,emailSubject,email,text],
        runInShell: true,
      );
      stderr.write(result.stderr);
      stdout.write(result.stdout);
    } catch (e) {
      result = '';
    }
  }

  //Click on Edit: When
  Future<void> clickOnEditWhen() async {
    await clickOn(await find.descendant(
        of: find.ancestor(of: when_label, matching: form_field_parent),
        matching: edit_text));
  }

  //Click on select button
  Future<void> clickOnSelectButton() async {
    await clickOn(select_button);
  }

//Select Date
  Future<void> selectDateForWhenField({var day, var month, var year, DateTime alreadySelectedDate}) async {
    final selectedDay = (alreadySelectedDate != null) ? alreadySelectedDate.day : int.parse(currentDate.split(' ')[1]);
    final selectedYear = (alreadySelectedDate != null) ? alreadySelectedDate.year : int.parse(currentDate.split(' ')[2]);
    final selectedMonth = (alreadySelectedDate != null) ? alreadySelectedDate.month : monthList[currentDate.split(' ')[0]];
    await clickOnEditWhen();
    //Select Month
    if (month != null) {
      if (selectedMonth.compareTo(month) == 0) {
        null; //No change in Month
      } else if (selectedMonth.compareTo(month) < 0) {
        for (var i = 0; i < (selectedMonth - month).abs(); i++) {
          final elementToScroll =
          find.text(monthList.keys.elementAt(selectedMonth + i));
          await scrollElement(elementToScroll, dy: -50);
        }
      } else {
        for (var i = 0; i < (selectedMonth - month).abs(); i++) {
          final elementToScroll =
          find.text(monthList.keys.elementAt(selectedMonth - i));
          await scrollElement(elementToScroll, dy: 50);
        }
      }
    }

    if (day != null) {
      if (selectedDay.compareTo(day) == 0) {
        null; //No change in Day
      } else if (selectedDay.compareTo(day) < 0) {
        for (var i = 0; i < (selectedDay - day).abs(); i++) {
          final elementToScroll = find.text((selectedDay + i).toString());
          await scrollElement(elementToScroll, dy: -50);
        }
      } else {
        for (var i = 0; i < (selectedDay - day).abs(); i++) {
          final elementToScroll = find.text((selectedDay - i).toString());
          await scrollElement(elementToScroll, dy: 50);
        }
      }
    }

    //Check Year
    if (year != null) {
      if (selectedYear.compareTo(year) == 0) {
        null; //No Change in Year
      } else if (selectedYear.compareTo(year) < 0) {
        for (var i = 0; i < (selectedYear - year).abs(); i++) {
          final elementToScroll = find.text((selectedYear + i).toString());
          await scrollElement(elementToScroll, dy: -50);
        }
      } else {
        for (var i = 0; i < (selectedYear - year).abs(); i++) {
          final elementToScroll = find.text((selectedYear - i).toString());
          await scrollElement(elementToScroll, dy: 50);
        }
      }
    }
    await clickOnSelectButton();
  }


  Future<void> verifyDatePickerDialog() async
  {
    await verifyElementIsDisplayed(cancel_button);
    await verifyElementIsDisplayed(select_button);
    await verifyElementIsDisplayed(date_picker);
  }

  Future<void> clickOnDatePickerCancelButton() async
  {
    await clickOn(cancel_button);
  }

  Future<bool> isNotProd() async {
    return await driver.requestData('env') != 'prod';
  }

  Future<void> scrollUntilElementIsVisible({ SerializableFinder element, SerializableFinder scrollableView, int retry=10, int timeout=5, double dy=-50, double dx=0 }) async {
    scrollableView ??= screen_scrollable_view;
    for(var i=retry ; i >=0 ; i--) {
      await scrollElement(scrollableView, dy: dy, dx: dx);
      if(await isPresent(element)) {
        break;
      }
    }
  }
}
