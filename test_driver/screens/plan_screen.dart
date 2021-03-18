import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';

import 'base_screen.dart';

class PlanScreen extends BaseScreen {
  final plan_screen_parent = find.byType('CustomScrollView');
  final profile_button = find.byValueKey('plan_screen_profile_icon_button');
  final more_button = find.byValueKey('plan_screen_more_icon_button');
  final screen_header = find.text('My Lawn');
  final cancel_button_of_lawn_name =
      find.byValueKey('cancel_button_of_lawn_name');
  final name_your_lawn_text = find.text('Name Your Lawn');
  final lawn_name = find.byValueKey('lawn_name');
  final save_button_of_lawn_name = find.byValueKey('save_button_of_lawn_name');
  final lawn_text_as_screen_header = find.text('Lawn');
  final screen_sub_header =
      find.text('Get ready to grow a thick, strong, green lawn!');
  final subscribe_to_your_plan_label =
      find.text('Subscribe to your plan today');
  final subscribe_to_your_plan_sub_text = find.text(
      "Get your personalized lawn care plan delivered straight to your door. It's that easy!");
  final subscribe_now_button = find.text('SUBSCRIBE NOW');
  final remind_me_next_year_button = find.text('REMIND ME NEXT YEAR');
  final rainfall_track_widget = find.byType('RainfallTrackWidget');

  final your_plan_label =
      'Your plan contains everything you need to take care of your replace_lawn_size replace_size_unit replace_lawn_grass_type lawn!';

  // Subscription card locators
  var sub_card_parent;
  final sub_card_apply_label = find.text('Apply');
  final sub_card_apply_from_date = find.byValueKey('sub_card_apply_from_date');
  final sub_card_apply_from_date_con =
      find.byValueKey('sub_card_apply_from_date');
  final sub_card_apply_from_month =
      find.byValueKey('sub_card_apply_from_month');
  final sub_card_apply_to_date = find.byValueKey('sub_card_apply_to_date');
  final sub_card_apply_to_month = find.byValueKey('sub_card_apply_to_month');
  final sub_card_product_image = find.byValueKey('sub_card_product_image');
  final sub_card_product_name = find.byValueKey('sub_card_product_name');
  final sub_card_view_details = find.text('VIEW DETAILS');
  final sub_card_collapse = find.byValueKey('sub_card_collapse');
  final sub_card_expand = find.byValueKey('sub_card_expand');
  final sub_card_small_package_image =
      find.byValueKey('sub_card_small_package_image');
  final sub_card_small_bag_quantity_text =
      find.byValueKey('small_bag_quantity_text');
  final sub_card_small_bag_size_text = find.byValueKey('small_bag_size_text');
  final parent_bag_details_small = find.byValueKey('bag_details_small');

  final sub_card_big_package_image =
      find.byValueKey('sub_card_big_package_image');
  final sub_card_big_bag_quantity_text =
      find.byValueKey('big_bag_quantity_text');
  final sub_card_big_bag_size_text = find.byValueKey('big_bag_size_text');
  final parent_bag_details_big = find.byValueKey('bag_details_big');

  final floating_action_button = find.byValueKey('floating_action_button');
  final product_text = find.text('Product');
  final product_icon = find.byValueKey('product_icon');
  final added_by_me = find.text('Added by me');
  final bottom_navigation_bar = find.byValueKey('bottom_navigation_bar');
  final task_icon = find.byValueKey('task_icon');
  final note_icon = find.byValueKey('note_icon');
  final first_view_detail = find.byValueKey('view_details_1');
  final second_view_details = find.byValueKey('view_details_2');
  final third_view_details = find.byValueKey('view_details_3');
  final applied_text = find.text('APPLIED');
  final skipped_text = find.text('SKIPPED');
  final product_name = find.text('Scotts® Turf Builder® Lawn Food');
  final product_name_key = find.byValueKey('Scotts® Turf Builder® Lawn Food');
  final feeds_grass = find.text('Feeds Grass');
  final promotes_root_development = find.text('Promotes Root Development');
  final increases_water_absorption = find.text('Increases Water Absorption');
  final divider_line = find.byValueKey('divider_line');
  final learn_more = find.byValueKey('learn_more');
  final get_plan_delivered =
      find.text('Get your plan delivered straight to your door');
  final product_card_parent = 'sub_card_column_el_';
  final check_image = find.byValueKey('check_image');

  PlanScreen(FlutterDriver driver) : super(driver);

  Future<void> clickOnProfileIcon() async {
    await clickOn(profile_button);
  }

  Future<void> verifyPlanScreenCommonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(profile_button);
    await verifyElementIsDisplayed(more_button);
    await verifyElementIsDisplayed(screen_header);
    await verifyElementIsDisplayed(subscribe_to_your_plan_label);
    await verifyElementIsDisplayed(subscribe_to_your_plan_sub_text);
    await verifyElementIsDisplayed(subscribe_now_button);
    await verifyElementIsDisplayed(remind_me_next_year_button);
    await verifyElementIsDisplayed(rainfall_track_widget);
  }

  Future<void> verifyPlanScreenCommonElementsAreDisplayedAfterLogIn() async {
    await verifyElementIsDisplayed(profile_button);
    await verifyElementIsDisplayed(more_button);
    await verifyElementIsDisplayed(rainfall_track_widget);
  }

  Future<void> verifyPlanScreeIsDisplayed() async {
    await verifyElementIsDisplayed(profile_button);
    await verifyElementIsDisplayed(more_button);
    await verifyElementIsDisplayed(screen_header);
  }

  Future<void> verifyYourPlanLabel(
      String size, String grassType, String unit) async {
    await verifyElementIsDisplayed(find.text(your_plan_label
        .replaceAll('replace_lawn_size', size)
        .replaceAll('replace_lawn_grass_type', grassType)
        .replaceAll('replace_size_unit', unit)));
  }

  Future<void> verifyProductElementsAreDisplayed(var productData, var index,
      {bool isNeedToScroll = false}) async {
    final productName = productData[index][0];
    final bool isExpanded = productData[index][1];
    final bigBagQuantity = productData[index][2];
    final bigBagSize = productData[index][3];
    final smallBagQuantity = productData[index][6];
    final smallBagSize = productData[index][7];
    final productCategories = productData[index][5];

    // Find card parent
    sub_card_parent =
        await find.byValueKey('sub_card_column_el_' + index.toString());
    final sub_card_parent_coordinates = await driver.getCenter(sub_card_parent);
    await scrollElement(sub_card_parent,
        dy: ((0 - sub_card_parent_coordinates.dy) / 2), timeout: 100);

    if (isNeedToScroll) {
      if (index == 0) {
        await scrollTillElementIsVisible(sub_card_parent,
            parent_finder: plan_screen_parent, dy: 500);
      }
    }
    // Verify Apply label
    await find.descendant(of: sub_card_parent, matching: sub_card_apply_label);

    // Verify product image
    await find.descendant(
        of: sub_card_parent, matching: sub_card_product_image);

    // Verify product name
    await verifyProductName(sub_card_parent, productName);

    // Verify View Details link
    await find.descendant(of: sub_card_parent, matching: sub_card_view_details);

    // Verify expand/collapse icon
    isExpanded
        ? await find.descendant(
            of: sub_card_parent, matching: sub_card_collapse)
        : await find.descendant(of: sub_card_parent, matching: sub_card_expand);

    // Verify dates are not blank
    await verifyApplyDates(sub_card_parent, '', '', '', '');

    // Expand card
    if (!isExpanded) {
      await clickOn(
          find.descendant(of: sub_card_parent, matching: sub_card_expand));
    }

    //Verify Product Categories
    for (var category in productCategories) {
      final product_card_category = find.text(category);
      await verifyElementIsDisplayed(await find.descendant(
          of: sub_card_parent, matching: product_card_category));
    }

    if (smallBagSize != null && smallBagQuantity != null) {
      // Verify bag image
      await find.descendant(
          of: sub_card_parent, matching: sub_card_small_package_image);

      // Verify bag size
      await validate(
          (await getText(await find.descendant(
              of: sub_card_parent,
              matching: find.descendant(
                  of: parent_bag_details_small,
                  matching: find.text(smallBagSize))))),
          smallBagSize);

      // Verify bag quantity
      await validate(
          (await getText(await find.descendant(
              of: sub_card_parent,
              matching: find.descendant(
                  of: parent_bag_details_small,
                  matching: find.text(smallBagQuantity))))),
          smallBagQuantity);
    }

    if (bigBagSize != null && bigBagQuantity != null) {
      // Verify bag image
      await find.descendant(
          of: sub_card_parent, matching: sub_card_big_package_image);

      // Verify bag size
      await validate(
          (await getText(await find.descendant(
              of: sub_card_parent,
              matching: find.descendant(
                  of: parent_bag_details_big,
                  matching: find.text(bigBagSize))))),
          bigBagSize);

      // Verify bag quantity
      await validate(
          (await getText(await find.descendant(
              of: sub_card_parent,
              matching: find.descendant(
                  of: parent_bag_details_big,
                  matching: find.text(bigBagQuantity))))),
          bigBagQuantity);
    }

    await clickOn(
        find.descendant(of: sub_card_parent, matching: sub_card_collapse));
  }

  Future<void> verifyProductName(
      SerializableFinder sub_card_parent, String productName) async {
    await validate(
        (await getText(await find.descendant(
            of: sub_card_parent, matching: sub_card_product_name))),
        productName);
  }

  Future<void> verifyApplyDates(SerializableFinder sub_card_parent,
      String fromDate, String fromMonth, String toDate, String toMonth) async {
    //    TODO To add a code to read zone sheet and figure out the zone from zip code -> considering present date -> calculate Application start date

    await validate(
        (await getText(await find.descendant(
            of: sub_card_parent, matching: sub_card_apply_from_date))),
        '',
        op: false);

    await validate(
        (await getText(await find.descendant(
            of: sub_card_parent, matching: sub_card_apply_from_month))),
        '',
        op: false);

    await validate(
        (await getText(await find.descendant(
            of: sub_card_parent, matching: sub_card_apply_to_date))),
        '',
        op: false);

    await validate(
        (await getText(await find.descendant(
            of: sub_card_parent, matching: sub_card_apply_to_month))),
        '',
        op: false);
  }

  Future<void> clickOnSubscribeNow() async {
    final subscribe_now_button_coordinates =
        await driver.getCenter(subscribe_now_button);
    await scrollElement(plan_screen_parent,
        dy: (0 - subscribe_now_button_coordinates.dy) * 0.7, timeout: 1000);
    await clickOn(subscribe_now_button);
  }

  Future<void> clickOnRemindMeNextYear() async {
    final subscribe_now_button_coordinates =
        await driver.getCenter(subscribe_now_button);
    await scrollElement(screen_sub_header,
        dy: (0 - subscribe_now_button_coordinates.dy), timeout: 1000);
    await clickOn(remind_me_next_year_button);
  }

  Future<void> verifySubscribeNow() async {
    await verifyElementIsDisplayed(subscribe_now_button);
  }

  Future<void> waitForPlanScreenLoading() async {
    await waitForElementToLoad('text', 'My Lawn');
  }

  Future<void> clickOnFloatingActionButton() async {
    await clickOn(floating_action_button);
  }

  Future<void> verifyAddedByMe(DateTime date, var productName) async {
    final _monthFormat = DateFormat('MMM');
    final currentDate = DateTime.now();
    final currentDateMonth = _monthFormat.format(currentDate);
    final currentDateDay = currentDate.day;

    if (date.day == currentDateDay &&
        _monthFormat.format(date) == currentDateMonth) {
      var i = 0;
      var product_found = 0;

      while (product_found == 0) {
        try {
          final parentElement =
              find.byValueKey(product_card_parent + i.toString());
          await verifyElementIsDisplayed(parentElement);
          await verifyElementIsDisplayed(
              find.descendant(of: parentElement, matching: check_image));
          await verifyElementIsDisplayed(find.descendant(
              of: parentElement, matching: find.text(productName)));
          product_found = 1;
          break;
        } catch (e) {
          throw Exception('Product $productName not found in the list');
        }
        i++;
      }
    } else {
      var i = 0;
      var product_found = 0;

      while (product_found == 0) {
        try {
          final parentElement =
              find.byValueKey(product_card_parent + i.toString());
          await verifyElementIsDisplayed(parentElement);
          if (i > 0) {
            await scrollUntilElementIsVisible(element: parentElement, dy: -100);
          }

          var day;
          if (date.day < 10) {
            day = '0' + date.day.toString();
          } else {
            day = date.day.toString();
          }
          final event_day = find.descendant(
              of: parentElement, matching: sub_card_apply_from_date);
          final event_month = find.descendant(
              of: parentElement, matching: sub_card_apply_from_month);

          final cardDay = await getText(event_day);
          final cardMonth = await getText(event_month);
          final month = _monthFormat.format(date);

          if (cardDay == day && cardMonth == month) {
            if (i > 0) {
              await clickOn(find.descendant(
                  of: parentElement, matching: sub_card_expand));
            }
            await verifyElementIsDisplayed(find.descendant(
                of: parentElement, matching: find.text(productName)));
            await verifyElementIsDisplayed(
                find.descendant(of: parentElement, matching: added_by_me));
            await verifyElementIsDisplayed(event_day);
            await verifyElementIsDisplayed(event_month);
            await verifyElementIsDisplayed(find.descendant(
                of: parentElement, matching: sub_card_apply_label));
            await verifyElementIsDisplayed(find.descendant(
                of: parentElement, matching: sub_card_big_package_image));

            product_found = 1;
            break;
          }
        } catch (e) {
          throw Exception('Product $productName not found in the list');
        }
        i++;
      }
    }
  }

  Future<void> clickOnManuallyAddedProduct(
      DateTime date, var productName) async {
    final _monthFormat = DateFormat('MMM');
    final currentDate = DateTime.now();
    final currentDateMonth = _monthFormat.format(currentDate);
    final currentDateDay = currentDate.day;

    if (date.day == currentDateDay &&
        _monthFormat.format(date) == currentDateMonth) {
      var i = 0;
      var product_found = 0;

      while (product_found == 0) {
        try {
          final parentElement =
              find.byValueKey(product_card_parent + i.toString());
          await verifyElementIsDisplayed(parentElement);
          await clickOn(find.descendant(
              of: parentElement, matching: find.text(productName)));
          product_found = 1;
          break;
        } catch (e) {
          throw Exception('Product $productName not found in the list');
        }
        i++;
      }
    } else {
      var i = 0;
      var product_found = 0;

      while (product_found == 0) {
        try {
          final parentElement =
              find.byValueKey(product_card_parent + i.toString());
          await verifyElementIsDisplayed(parentElement);
          if (i > 0) {
            await scrollUntilElementIsVisible(element: parentElement, dy: -100);
          }
          var day;
          if (date.day < 10) {
            day = '0' + date.day.toString();
          } else {
            day = date.day.toString();
          }
          final event_day = find.descendant(
              of: parentElement, matching: sub_card_apply_from_date);
          final event_month = find.descendant(
              of: parentElement, matching: sub_card_apply_from_month);

          final cardDay = await getText(event_day);
          final cardMonth = await getText(event_month);
          final month = _monthFormat.format(date);
          if (cardDay == day && cardMonth == month) {
            await clickOn(find.descendant(
                of: parentElement, matching: find.text(productName)));

            product_found = 1;
            break;
          }
        } catch (e) {
          throw Exception('Product $productName not found in the list');
        }
        i++;
      }
    }
  }

  Future<void> changeIndexBottomNavigationBar() async {
    await verifyElementIsDisplayed(find.byValueKey('bottom_navigation_bar'));
    await clickOn(find.text('Calendar'));
  }

  Future<void> changeIndexBottomNavigationBarForAsk() async {
    await verifyElementIsDisplayed(find.byValueKey('bottom_navigation_bar'));
    await clickOn(find.text('Ask'));
  }

  Future<void> clickOnNoteButton() async {
    await clickOn(note_icon);
  }

  Future<void> clickOnTaskButton() async {
    await clickOn(task_icon);
  }

  Future<void> clickOnProductButton() async {
    await clickOn(product_icon);
  }

  Future<void> clickOnViewDetails() async {
    final subscribe_now_button_coordinates =
        await driver.getCenter(third_view_details);
    await scrollElement(screen_sub_header,
        dy: (0 - subscribe_now_button_coordinates.dy), timeout: 1000);
    await clickOn(third_view_details);
  }

  Future<void> clickOnSecondViewDetails() async {
    await clickOn(sub_card_collapse);
    await clickOn(second_view_details);
  }

  Future<void> verifyFloatingActionButtonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(product_icon);
    await verifyElementIsDisplayed(task_icon);
    await verifyElementIsDisplayed(note_icon);
    await verifyElementIsDisplayed(floating_action_button);
  }

  Future<void> clickOnScreenHeader() async {
    await clickOn(screen_header);
  }

  Future<void> verifyLawnNameChangedBottomSheet() async {
    await verifyElementIsDisplayed(name_your_lawn_text);
    await verifyElementIsDisplayed(cancel_button_of_lawn_name);
  }

  Future<void> verifyLawnNameChangedBottomSheetIsDissmissed() async {
    await verifyElementIsNotDisplayed(name_your_lawn_text);
    await verifyElementIsNotDisplayed(cancel_button_of_lawn_name);
  }

  Future<void> clickOnCancelButtonOfLanwName() async {
    await clickOn(cancel_button_of_lawn_name);
  }

  Future<void> changeLawnName(String text) async {
    await typeIn(lawn_name, text);
  }

  Future<void> clickOnSaveButtonOfLawnName() async {
    await clickOn(save_button_of_lawn_name);
  }

  Future<void> verifyLawnNameIsChanged() async {
    await verifyElementIsDisplayed(lawn_text_as_screen_header);
  }

  Future<void> verifyActiveApplicationWindowProduct() async {
    await verifyElementIsDisplayed(product_name);
    await verifyElementIsDisplayed(feeds_grass);
    await verifyElementIsDisplayed(promotes_root_development);
    await verifyElementIsDisplayed(increases_water_absorption);
  }

  Future<void> clickOnFirstViewDetail() async {
    await clickOn(first_view_detail);
  }

  Future<void> subscribedNowIsNotDisplayed() async {
    await verifyElementIsNotDisplayed(subscribe_now_button);
  }

  Future<void> clickOnAppliedButton() async {
    await clickOn(applied_text);
  }

  int convertMonthNameToNumber(String month) {
    switch (month) {
      case 'Jan':
        return 1;
        break;
      case 'Feb':
        return 2;
        break;
      case 'Mar':
        return 3;
        break;
      case 'Apr':
        return 4;
        break;
      case 'May':
        return 5;
        break;
      case 'Jun':
        return 6;
        break;
      case 'Jul':
        return 7;
        break;
      case 'Aug':
        return 8;
        break;
      case 'Sep':
        return 9;
        break;
      case 'Oct':
        return 10;
        break;
      case 'Nov':
        return 11;
        break;
      case 'Dec':
        return 12;
        break;
      default:
        return 0;
        break;
    }
  }

  Future<void> verify12MonthsDifference() async {
    sub_card_parent = await find.byValueKey('sub_card_column_el_0');
    final startDate = await getText(await find.descendant(
        of: sub_card_parent, matching: sub_card_apply_from_month));

    await scrollTillElementIsVisible(third_view_details,
        parent_finder: plan_screen_parent);

    sub_card_parent = await find.byValueKey('sub_card_column_el_3');

    final endDate = await getText(await find.descendant(
        of: sub_card_parent, matching: sub_card_apply_to_month));

    if (!await isPresent(divider_line)) {
      if ((convertMonthNameToNumber(startDate) -
              convertMonthNameToNumber(endDate).abs()) <=
          12) {
        stdout.write('covers 12 months');
      } else {
        stdout.write('not covers 12 months');
      }
    } else {
      if (((convertMonthNameToNumber(startDate) + 12) -
              convertMonthNameToNumber(endDate).abs()) <=
          12) {
        stdout.write('covers 12 months');
      } else {
        stdout.write('not covers 12 months');
      }
    }
  }

  Future<void> appliedButtonIsNotDisplayed() async {
    await verifyElementIsNotDisplayed(applied_text);
  }

  Future<void> skippedButtonIsNotDisplayed() async {
    await verifyElementIsNotDisplayed(skipped_text);
  }

  Future<void> verifySmallCardOfLearnMore() async {
    await verifyElementIsDisplayed(get_plan_delivered);
    await verifyElementIsDisplayed(learn_more);
  }

  Future<void> clickOnLearnMore() async {
    await clickOn(learn_more);
  }

  Future<void> verifyProductOnPlanScreen(var productName, var index) async {
    await verifyElementIsDisplayed(find.descendant(
        of: find.byValueKey('sub_card_column_el_' + index.toString()),
        matching: find.text(productName)));
  }

  Future<bool> verifySubscribeNowIsPresent() async {
    return await isPresent(subscribe_now_button);
  }

  Future<void> clickOnCalendarIcon() async {
    await clickOn(learn_more);
  }

  Future<void> clickOnProduct(var productName, var index) async {
    await scrollUntilElementIsVisible(element: plan_screen_parent, dy: 500);
    for (var i = 0; i <= index; i++) {
      if (i == index) {
        final product_card =
            find.byValueKey('sub_card_column_el_' + i.toString());
        await verifyElementIsDisplayed(find.descendant(
            of: product_card, matching: find.text(productName)));
        await clickOn(find.descendant(
            of: product_card, matching: find.text(productName)));
      } else {
        final product_card =
            find.byValueKey('sub_card_column_el_' + i.toString());
        final sub_card_parent_coordinates =
            await driver.getCenter(product_card);
        await scrollElement(product_card,
            dy: ((0 - sub_card_parent_coordinates.dy) / 2), timeout: 100);
      }
    }
  }
}
