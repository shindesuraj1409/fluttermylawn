import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';
import 'package:test/test.dart';

class ProductDetailsScreen extends BaseScreen {
  final subscribed_label = find.text('SUBSCRIBED');
  final lawn_food_label = find.text('LAWN FOOD');
  final customScrollView = find.byType('CustomScrollView');

  ProductDetailsScreen(FlutterDriver driver) : super(driver);

  final increases_thickness = find.text('Increases Thickness');
  final insect_control = find.text('Insect Control');
  final insect_and_disease_control = find.text('INSECT & DISEASE CONTROL');
  final calculate_bag_size = find.text('Calculate Bag Size');
  final feed_grass = find.text('Feeds Grass');
  final promotes_root_development = find.text('Promotes Root Development');
  final buy_now_button = find.text('BUY NOW');
  final overview_text = find.text('OVERVIEW');
  final how_to_apply = find.text('HOW TO APPLY');
  final use_this_product = find.text('USE THIS PRODUCT');
  final use_this_product_button = find.byValueKey('use_this_product');
  final save_button = find.byValueKey('save_button');
  final back_button_of_product_detail_button =
      find.byValueKey('back_button_of_product_detail');
  final applied_button_label = find.text('APPLIED');
  final applied_button = find.byValueKey('applied_button');
  final skipped_button_label = find.text('SKIPPED');
  final youtube_video_url = find.byValueKey('youtube_video_url');
  final info_more = find.byValueKey('info_more');
  final remove_product = find.byValueKey('remove_product');
  final back_button_of_remove_product =
      find.byValueKey('back_button_of_remove_product');
  final remove_product_label =
      find.text('Remove this product from your lawn plan?');
  final undo_action = find.text('You cannot undo this action');
  final product_removed_label = find.text('Product Removed!');
  final cancel_button_of_product_removed_bottom_sheet =
      find.byValueKey('cancel_button_of_product_removed_bottom_sheet');
  final info_icon_product_detail = find.byValueKey('info_icon_product_detail');
  final bottom_sheet_text = find
      .text('We\'ve calculated the coverage amount based on your lawn size.');
  final got_it_button_product_detail =
      find.byValueKey('got_it_button_product_detail');
  final coverage_area_zero = find.text('0');
  final coverage_area_increment = find.text('5000');
  final coverage_add_icon = find.descendant(of: find.byValueKey('small_bag_container'), matching: find.byValueKey('coverage_add_icon'));
  final coverage_second_add_icon = find.descendant(of: find.byValueKey('large_bag_container'), matching: find.byValueKey('coverage_add_icon'));
  final coverage_area_second_time_increment = find.text('20000');
  final no_quibble_guarantee = find.byValueKey('no_quibble_guarantee');
  final bottom_sheet_of_no_quibble_guarantee = find.text(
      'If for any reason you, the consumer, are not satisfied after using this product, you are entitled to get your money back. Simply send us evidence of purchase and we will mail you a refund check promptly.');
  final got_it_of_no_quibble_guarantee =
      find.byValueKey('got_it_of_no_quibble_guarantee');
  final buy_online_button = find.text('BUY ONLINE');
  final find_local_store = find.byValueKey('find_local_store');
  final product_image = find.byValueKey('product_image');
  final descriptive_text = find.text(
      'Check your local ordinances for product & water application restrictions. Always read and follow label instructions.');

  final scotts_no_quibble_guarantee = find.text('Scotts\nNo-Quibble Guarantee');
  final product_details_category_label =
      find.byValueKey('product_details_category_label');
  final product_name = find.byValueKey('product_name');
  final product_benefits_text = find.text('Benefits');
  final product_screen_back_button = find.byValueKey('back_button');
  final product_details_category_text =
      find.byValueKey('product_category_text');
  final added_by_me = find.byValueKey('added_by_me');


  Future<void> verifyProductDetail() async {
    await verifyElementIsDisplayed(promotes_root_development);
    await verifyElementIsDisplayed(feed_grass);
    await verifyElementIsDisplayed(increases_thickness);
  }

  Future<void> waitForProudctDetailScreenLoading() async {
    await waitForElementToLoad('text', 'SKIPPED');
  }

  Future<void> clickOnBackButton() async {
    await clickOn(back_button_of_product_detail_button);
  }

  Future<void> clickOnUseThisProduct() async {
    // disable sync frame via runUnsynchronized as true
    await clickOn(use_this_product, runUnsynchronized: true);
  }

  Future<void> clickOnSaveButton() async {
    await clickOn(save_button);
  }

  Future<void> clickOnHowToApply() async {
    await scrollTillElementIsVisible(how_to_apply,
        parent_finder: customScrollView, dy: -100, runUnsynchronized: true);
    await clickOn(how_to_apply, runUnsynchronized: true);
  }

  Future<void> goToPlanScreen() async {
    await goToBack();
  }

  Future<void> verifyLabels() async {
    await verifyElementIsDisplayed(subscribed_label, runUnsynchronized: true);
  }

  Future<void> verifyYouTubeUrl() async {
    await verifyElementIsDisplayed(youtube_video_url, runUnsynchronized: true);
  }

  Future<void> playYouTubeUrl() async {
    await clickOn(youtube_video_url, runUnsynchronized: true);
  }

  Future<void> clickOnInfoMore() async {
    await clickOn(info_more, runUnsynchronized: true);
  }

  Future<void> verifyBottomSheet() async {
    await verifyElementIsDisplayed(remove_product_label,
        runUnsynchronized: true);
    await verifyElementIsDisplayed(undo_action, runUnsynchronized: true);
    await verifyElementIsDisplayed(remove_product, runUnsynchronized: true);
    await verifyElementIsDisplayed(back_button_of_remove_product,
        runUnsynchronized: true);
  }

  Future<void> verifyBottomSheetIsDissmissed() async {
    await verifyElementIsNotDisplayed(remove_product_label,
        runUnsynchronized: true);
    await verifyElementIsNotDisplayed(undo_action, runUnsynchronized: true);
    await verifyElementIsNotDisplayed(remove_product, runUnsynchronized: true);
    await verifyElementIsNotDisplayed(back_button_of_remove_product,
        runUnsynchronized: true);
  }

  Future<void> clickOnRemoveProduct() async {
    await clickOn(remove_product);
  }

  Future<void> clickOnBackButtonOfRemoveProduct() async {
    await clickOn(back_button_of_remove_product, runUnsynchronized: true);
  }

  Future<void> verifyProductRemovedSuccessfully() async {
    await clickOn(product_removed_label, runUnsynchronized: true);
  }

  Future<void> clickOnCancelButtonOfProductRemovedBottomSheet() async {
    await clickOn(cancel_button_of_product_removed_bottom_sheet,
        runUnsynchronized: true);
  }

  Future<void> clickOnInfoIconProductDetail() async {
    await clickOn(info_icon_product_detail);
  }

  Future<void> verifyBottomSheetOfCoverage() async {
    await verifyElementIsDisplayed(bottom_sheet_text);
  }

  Future<void> verifyBottomSheetOfCoverageIsDissmissed() async {
    await verifyElementIsNotDisplayed(bottom_sheet_text);
  }

  Future<void> clickOnGotItButtonProductDetail() async {
    await clickOn(got_it_button_product_detail);
  }

  Future<void> verifyCoverageZero() async {
    await verifyElementIsDisplayed(coverage_area_zero);
  }

  Future<void> verifyCoverageIncrement(totalCoverageArea) async {
    await verifyElementIsDisplayed(find.text(totalCoverageArea));
  }

  Future<void> clickOnAddIcon() async {
    await clickOn(coverage_add_icon);
  }

  Future<void> clickOnSecondAddIcon() async {
    await scrollTillElementIsVisible(coverage_second_add_icon);
    await clickOn(coverage_second_add_icon);
  }

  Future<void> clickOnNoQuibbleGuarantee() async {
    await scrollElement(coverage_add_icon, dy: 700);
    await clickOn(no_quibble_guarantee);
  }

  Future<void> verifyBottomSheetOfNoQuibbleGuarantee() async {
    await verifyElementIsDisplayed(bottom_sheet_of_no_quibble_guarantee);
  }

  Future<void> verifyBottomSheetOfNoQuibbleGuaranteeIsDissmissed() async {
    await verifyElementIsNotDisplayed(bottom_sheet_of_no_quibble_guarantee);
  }

  Future<void> clickOnGotItOfNoQuibbleGuarantee() async {
    await clickOn(got_it_of_no_quibble_guarantee);
  }

  Future<void> clickOnBuyNow() async {
    await scrollTillElementIsVisible(buy_now_button, parent_finder: customScrollView);
    await clickOn(buy_now_button);
  }

  Future<void> verifyBottomSheetOfBuyNow() async {
    await verifyElementIsDisplayed(buy_online_button);
    await verifyElementIsDisplayed(find_local_store);
    await verifyElementIsDisplayed(cancel_button);
  }

  Future<void> verifyBottomSheetOfBuyNowIsDissmissed() async {
    await verifyElementIsNotDisplayed(buy_online_button);
    await verifyElementIsNotDisplayed(find_local_store);
    await verifyElementIsNotDisplayed(cancel_button);
  }

  Future<void> clickOnFindLocalStore() async {
    await clickOn(find_local_store);
  }

  Future<void> clickOnBuyOnline() async {
    await clickOn(buy_online_button);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_button);
  }

  Future<void> verifyProductDetailsCommonElements(var productName,
      [var subCategory, var mainCategory]) async {
    await verifyElementIsDisplayed(product_screen_back_button);
    await verifyElementIsDisplayed(scotts_no_quibble_guarantee);
    await clickOnNoQuibbleGuarantee();
    await clickOnGotItOfNoQuibbleGuarantee();
    await verifyElementIsDisplayed(product_image);
    if (mainCategory == 'Main Category') {
      await verifyElementIsDisplayed(product_details_category_text);
      //Validate Product selected is from same category
      final product_category =
          (await getText(product_details_category_text)).toString();
      await expect(
          product_category.contains(subCategory.toString().toUpperCase()),
          true);
    }
    await verifyElementIsDisplayed(product_name);
    //Verify Product name on Pdp screen matches with product name on PLP screen
    await validate(await getText(product_name), productName);

    await verifyElementIsDisplayed(calculate_bag_size);
    await verifyElementIsDisplayed(info_icon_product_detail);
    await clickOnInfoIconProductDetail();
    await verifyElementIsDisplayed(bottom_sheet_text);
    await clickOn(got_it_button_product_detail);
    await verifyElementIsDisplayed(buy_now_button);
    await verifyElementIsDisplayed(overview_text);
    await verifyElementIsDisplayed(how_to_apply);
    await clickOnHowToApply();
    await verifyElementIsDisplayed(descriptive_text);
    await verifyElementIsDisplayed(use_this_product);
  }

  Future<void> verifyAddedByMe() async
  {
    await verifyElementIsDisplayed(added_by_me);
  }


}
