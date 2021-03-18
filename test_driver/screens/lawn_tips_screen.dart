
import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class LawnTipsScreen extends BaseScreen {

  final screen_header = find.text('Lawn Tips');
  final screen_sub_header = find.text('Ideas, inspirations, and other tips for your lawn');
  final FILTER_BUTTON = find.text('Filters ');

  // Tab buttons
  final LATEST_TAB_BUTTON = find.descendant(of: find.byType('TabBar'), matching: find.text('LATEST'));
  final ARTICLES_TAB_BUTTON = find.descendant(of: find.byType('TabBar'), matching: find.text('ARTICLES'));
  final VIDEOS_TAB_BUTTON = find.descendant(of: find.byType('TabBar'), matching: find.text('VIDEOS'));

  // Filter sections
  final FILTER_LAWN_CARE_SECTION = find.text('Lawn Care');
  final FILTER_LAWN_PROBLEMS_SECTION = find.text('Lawn Problems');
  final FILTER_LIFESTYLE_SECTION = find.text('Lifestyle');

  // Filter options
  final LAWN_CARE_BASIC_OPTION_LABEL = find.text('Lawn Care Basic');
  final SUMMER_LAWN_CARE_OPTION_LABEL = find.text('Summer Lawn Care');
  final WATERING_OPTION_LABEL = find.text('Watering');
  final SPREADER_MOVING_AND_TOOLS_OPTION_LABEL = find.text('Spreader, Mowing & Tools');
  final LAWN_FOOD_OPTION_LABEL = find.text('Lawn Food');
  final GRASS_AND_GRASS_SEED_OPTION_LABEL = find.text('Grass & Grass Seed');
  final WEED_CONTROL_OPTION_LABEL = find.text('Weed Control');
  final INSECT_CONTROL_OPTION_LABEL = find.text('Insect Control');
  final DISEASE_CONTROL_OPTION_LABEL = find.text('Disease Control');
  final OTHER_LAWN_PROBLEMS_OPTION_LABEL = find.text('Other Lawn Problems');
  final MULCH_AND_GARDEN_OPTION_LABEL = find.text('Mulch & Garden');
  final BACKYARD_TRANSFORMATION_OPTION_LABEL = find.text('Backyard Transformation');
  final LAWNS_MATTER_OPTION_LABEL = find.descendant(of: find.byType('FilterOptionWidget'), matching: find.text('Lawns Matter'));
  final OUTSIDE_ADVENTURES_OPTION_LABEL = find.text('Outside Adventures');
  final FILTER_CONTAINER = find.byType('FilterScreen');

  // Checkboxes on tips filter box
  final LAWN_CARE_BASIC_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_lawn_care_basic');
  final SUMMER_LAWN_CARE_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_summer_lawn_care');
  final WATERING_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_watering');
  final SPREADER_MOVING_AND_TOOLS_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_spreader,_mowing_&_tools');
  final LAWN_FOOD_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_lawn_food');
  final GRASS_AND_GRASS_SEED_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_grass_&_grass_seed');
  final WEED_CONTROL_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_weed_control');
  final INSECT_CONTROL_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_insect_control');
  final DISEASE_CONTROL_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_disease_control');
  final OTHER_LAWN_PROBLEMS_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_other_lawn_problems');
  final MULCH_AND_GARDEN_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_mulch_&_garden');
  final BACKYARD_TRANSFORMATION_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_backyard_transformation');
  final LAWNS_MATTER_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_lawns_matter');
  final OUTSIDE_ADVENTURES_OPTION_CHECKBOX = find.byValueKey('filter_checkbox_outside_adventures');

  final SHOW_ARTICLES_BUTTON = find.descendant(of: find.byType('RaisedButton'), matching: find.byType('Text'));
  final CLEAR_FILTERS_BUTTON = find.text('Clear Filters');
  final FILTER_BOX_TITLE = find.text('Filters');
  final FILTER_BOX_CANCEL_BUTTON = find.text('CANCEL');

  // Select Deselect all buttons
  final LAWN_CARE_SELECT_DESELECT_ALL_BUTTON = find.byValueKey('lawn_care_filter_checkbox_select_deselect_all');
  final LAWN_PROBLEMS_SELECT_DESELECT_ALL_BUTTON = find.byValueKey('lawn_problems_filter_checkbox_select_deselect_all');
  final LIFESTYLE_SELECT_DESELECT_ALL_BUTTON = find.byValueKey('lifestyle_filter_checkbox_select_deselect_all');

  // Show more and less
  final LAWN_CARE_SHOW_MORE_SHOW_LESS_BUTTON = find.byValueKey('lawn_care_filter_options_show_more_and_show_less');
  final LAWN_PROBLEMS_SHOW_MORE_SHOW_LESS_BUTTON = find.byValueKey('lawn_problems_filter_options_show_more_and_show_less');
  final LIFESTYLE_SHOW_MORE_SHOW_LESS_BUTTON = find.byValueKey('lifestyle_filter_options_show_more_and_show_less');

  LawnTipsScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyLawnTipsScreenIsDisplayed() async {
    await verifyElementIsDisplayed(screen_header);
    await verifyElementIsDisplayed(screen_sub_header);
    await verifyTabButtons();
    await verifyElementIsDisplayed(FILTER_BUTTON);
  }

  Future<void> verifyTipsSliderOnScreen(tipsData, index) async {
    final lawn_tips_card = find.byValueKey('lawn_tips_carousel_card_${index}');
    assert(await getText(await find.descendant(of: lawn_tips_card, matching: find.byValueKey('lawn_tips_carousel_tips_type_${index}'))) == tipsData['tip_type']);
    await verifyElementIsDisplayed(find.descendant(of: lawn_tips_card, matching: find.byValueKey('lawn_tips_carousel_card_image_${index}')));
    assert(await getText(await find.descendant(of: lawn_tips_card, matching: find.byValueKey('lawn_tips_carousel_card_title_${index}'))) == tipsData['tip_title']);
    assert(await getText(await find.descendant(of: find.descendant(of: lawn_tips_card, matching: find.byType('GradientText')), matching: find.byType('Text'))) == tipsData['tip_description']);
    (tipsData['reading_time'] != null) ? await verifyElementIsDisplayed(find.descendant(of: lawn_tips_card, matching: find.text(tipsData['reading_time']))) : '';
    final sub_card_parent_coordinates = await driver.getCenter(lawn_tips_card);
    await scrollElement(lawn_tips_card,
        dy: ((0 - sub_card_parent_coordinates.dy) / 2), timeout: 100);
  }

  Future<void> verifyTabButtons() async {
    await verifyElementIsDisplayed(LATEST_TAB_BUTTON);
    await verifyElementIsDisplayed(ARTICLES_TAB_BUTTON);
    await verifyElementIsDisplayed(VIDEOS_TAB_BUTTON);
  }

  Future<void> verifyFilterBox() async {
    await verifyElementIsDisplayed(FILTER_BOX_TITLE);
    await verifyElementIsDisplayed(FILTER_BOX_CANCEL_BUTTON);
    await verifyElementIsDisplayed(FILTER_LAWN_CARE_SECTION);
    await verifyElementIsDisplayed(FILTER_LAWN_PROBLEMS_SECTION);
    await verifyElementIsDisplayed(FILTER_LIFESTYLE_SECTION);

    await verifyElementIsDisplayed(LAWN_CARE_BASIC_OPTION_LABEL);
    await verifyElementIsDisplayed(LAWN_CARE_BASIC_OPTION_CHECKBOX);
    await verifyElementIsDisplayed(SUMMER_LAWN_CARE_OPTION_LABEL);
    await verifyElementIsDisplayed(SUMMER_LAWN_CARE_OPTION_CHECKBOX);
    await clickOn(LAWN_CARE_SHOW_MORE_SHOW_LESS_BUTTON);
    await verifyElementIsDisplayed(WATERING_OPTION_LABEL);
    await verifyElementIsDisplayed(WATERING_OPTION_CHECKBOX);
    await verifyElementIsDisplayed(SPREADER_MOVING_AND_TOOLS_OPTION_LABEL);
    await verifyElementIsDisplayed(SPREADER_MOVING_AND_TOOLS_OPTION_CHECKBOX);
    await verifyElementIsDisplayed(LAWN_FOOD_OPTION_LABEL);
    await verifyElementIsDisplayed(LAWN_FOOD_OPTION_CHECKBOX);
    await verifyElementIsDisplayed(GRASS_AND_GRASS_SEED_OPTION_LABEL);
    await verifyElementIsDisplayed(GRASS_AND_GRASS_SEED_OPTION_CHECKBOX);
    await clickOn(LAWN_CARE_SHOW_MORE_SHOW_LESS_BUTTON);
    await verifyElementIsDisplayed(WEED_CONTROL_OPTION_LABEL);
    await verifyElementIsDisplayed(WEED_CONTROL_OPTION_CHECKBOX);
    await verifyElementIsDisplayed(INSECT_CONTROL_OPTION_LABEL);
    await verifyElementIsDisplayed(INSECT_CONTROL_OPTION_CHECKBOX);
    await clickOn(LAWN_PROBLEMS_SHOW_MORE_SHOW_LESS_BUTTON);
    await scrollTillElementIsVisible(DISEASE_CONTROL_OPTION_LABEL);
    await scrollTillElementIsVisible(DISEASE_CONTROL_OPTION_CHECKBOX);
    await scrollTillElementIsVisible(OTHER_LAWN_PROBLEMS_OPTION_LABEL);
    await scrollTillElementIsVisible(OTHER_LAWN_PROBLEMS_OPTION_CHECKBOX);
    await clickOn(LAWN_PROBLEMS_SHOW_MORE_SHOW_LESS_BUTTON);
    await scrollTillElementIsVisible(MULCH_AND_GARDEN_OPTION_LABEL);
    await scrollTillElementIsVisible(MULCH_AND_GARDEN_OPTION_CHECKBOX);
    await scrollTillElementIsVisible(BACKYARD_TRANSFORMATION_OPTION_LABEL);
    await scrollTillElementIsVisible(BACKYARD_TRANSFORMATION_OPTION_CHECKBOX);
    await clickOn(LIFESTYLE_SHOW_MORE_SHOW_LESS_BUTTON);
    await scrollTillElementIsVisible(LAWNS_MATTER_OPTION_CHECKBOX);
    await scrollTillElementIsVisible(LAWNS_MATTER_OPTION_LABEL);
    await scrollTillElementIsVisible(OUTSIDE_ADVENTURES_OPTION_LABEL);
    await scrollTillElementIsVisible(OUTSIDE_ADVENTURES_OPTION_CHECKBOX);
    await scrollTillElementIsVisible(SHOW_ARTICLES_BUTTON);
    await scrollTillElementIsVisible(CLEAR_FILTERS_BUTTON);
  }

  Future<void> selectWeedControlArticleOnFilterBox() async {
    await clickOn(WEED_CONTROL_OPTION_CHECKBOX);
  }

  Future<void> verifyWeedControlArticles(tipsListData, index) async {
    await verifyElementIsDisplayed(find.descendant(of: find.byType('TipsListElement'), matching: find.text(tipsListData['tip_type'])));
    await verifyElementIsDisplayed(find.descendant(of: find.byType('TipsListElement'), matching: find.text(tipsListData['tip_title'])));
    (tipsListData['reading_time'] != null) ? await verifyElementIsDisplayed(find.descendant(of: find.byType('TipsListElement'), matching: find.text(tipsListData['reading_time']))) : '';
  }

  Future<void> clickOnArticle(articleDetailData) async {
    await clickOn(find.descendant(of: find.byType('TipsListElement'), matching: find.text(articleDetailData['tip_title'])));
  }

  Future<void> verifyArticlePage(articleDetailData) async {
    await verifyElementIsDisplayed(find.text(articleDetailData['tip_title']));
    await verifyElementIsDisplayed(find.text(articleDetailData['tip_description']));
    await verifyElementIsDisplayed(find.text(articleDetailData['reading_time']));
  }


  Future<void> verifyArticleCount() async {
    final regExp = RegExp(r'[\d]+');
    var buttonText = await getText(SHOW_ARTICLES_BUTTON);
    buttonText = await regExp.stringMatch(buttonText);

  }

  Future<void> clickOnFiltersButton() async {
    await clickOn(FILTER_BUTTON);
  }

  Future<void> clickOnVideosTabButton() async {
    await clickOn(VIDEOS_TAB_BUTTON);
  }

  Future<void> clickOnLatestTabButton() async {
    await clickOn(LATEST_TAB_BUTTON);
  }

  Future<void> clickOnArticlesTabButton() async {
    await clickOn(ARTICLES_TAB_BUTTON);
  }

  Future<void> clickOnShowArticlesButton() async {
    await clickOn(SHOW_ARTICLES_BUTTON);
  }
}