import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class MainProductListingScreen extends BaseScreen {
  final plp_screen_parent = find.byType('CustomScrollView');
  final plp_cancel_button = find.byValueKey('plp_cancel_icon');
  final search_input = find.byValueKey('search_input');
  final search_cancel_button = find.text('CANCEL');
  final search_button = find.byValueKey('plp_search_button');
  final insect_disease_control_label =
      find.byValueKey('insect_&_disease_control_option');
  final insect_disease_control_trailing_icon =
      find.byValueKey('insect_&_disease_control_trailing_icon');
  final weed_control_label = find.byValueKey('weed_control_option');
  final weed_control_trailing_icon =
      find.byValueKey('weed_control_trailing_icon');
  final lawn_food_label = find.byValueKey('lawn_food_option');
  final lawn_food_trailing_icon = find.byValueKey('lawn_food_trailing_icon');
  final grass_seeds_label = find.byValueKey('grass_seeds_option');
  final grass_seeds_trailing_icon =
      find.byValueKey('grass_seeds_trailing_icon');
  final need_help_with_finding_product_label =
      find.text('Need help with finding products?');
  final lawn_problems_button = find.text('LAWN PROBLEMS');
  final lawn_goals_button = find.text('LAWN GOALS');

  final bare_spots_label = find.byValueKey('bare_spots_option');
  final bare_spots_leading_icon = find.byValueKey('bare_spots_leading_icon');
  final bare_spots_trailing_icon = find.byValueKey('bare_spots_trailing_icon');

  final thin_lawn_leading_icon = find.byValueKey('thin_lawn_leading_icon');
  final thin_lawn_label = find.byValueKey('thin_lawn_option');
  final thin_lawn_trailing_icon = find.byValueKey('thin_lawn_trailing_icon');

  final crabgrass_label = find.byValueKey('crabgrass_option');
  final crabgrass_leading_icon = find.byValueKey('crabgrass_leading_icon');
  final crabgrass_trailing_icon = find.byValueKey('crabgrass_trailing_icon');

  final moss_leading_icon = find.byValueKey('moss_leading_icon');
  final moss_label = find.byValueKey('moss_option');
  final moss_trailing_icon = find.byValueKey('moss_trailing_icon');

  final dandelion_leading_icon = find.byValueKey('dandelion_leading_icon');
  final dandelion_label = find.byValueKey('dandelion_option');
  final dandelion_trailing_icon = find.byValueKey('dandelion_trailing_icon');

  final grubs_leading_icon = find.byValueKey('grubs_leading_icon');
  final grubs_label = find.byValueKey('grubs_option');
  final grubs_trailing_icon = find.byValueKey('grubs_trailing_icon');

  final drought_leading_icon = find.byValueKey('drought_leading_icon');
  final drought_label = find.byValueKey('drought_option');
  final drought_trailing_icon = find.byValueKey('drought_trailing_icon');

  //Lawn Goals items
  final grow_grass_quicker_label = find.byValueKey('grow_grass_quicker_option');
  final grow_grass_quicker_leading_icon =
      find.byValueKey('grow_grass_quicker_leading_icon');
  final grow_grass_quicker_trailing_icon =
      find.byValueKey('grow_grass_quicker_trailing_icon');

  final increase_thickness_label = find.byValueKey('increase_thickness_option');
  final increase_thickness_leading_icon =
      find.byValueKey('increase_thickness_leading_icon');
  final increase_thickness_trailing_icon =
      find.byValueKey('increase_thickness_trailing_icon');

  final feed_grass_label = find.byValueKey('feed_grass_option');
  final feed_grass_leading_icon = find.byValueKey('feed_grass_leading_icon');
  final feed_grass_trailing_icon = find.byValueKey('feed_grass_trailing_icon');

  final promote_root_development_label =
      find.byValueKey('promote_root_development_option');
  final promote_root_development_leading_icon =
      find.byValueKey('promote_root_development_leading_icon');
  final promote_root_development_trailing_icon =
      find.byValueKey('promote_root_development_trailing_icon');

  final strengthen_against_heat_label =
      find.byValueKey('strengthen_against_heat_option');
  final strengthen_against_heat_leading_icon =
      find.byValueKey('strengthen_against_heat_leading_icon');
  final strengthen_against_heat_trailing_icon =
      find.byValueKey('strengthen_against_heat_trailing_icon');

  final increase_water_absorption_label =
      find.byValueKey('increase_water_absorption_option');
  final increase_water_absorption_leading_icon =
      find.byValueKey('increase_water_absorption_leading_icon');
  final increase_water_absorption_trailing_icon =
      find.byValueKey('increase_water_absorption_trailing_icon');

  final recoup_from_summer_label = find.byValueKey('recoup_from_summer_option');
  final recoup_from_summer_leading_icon =
      find.byValueKey('recoup_from_summer_leading_icon');
  final recoup_from_summer_trailing_icon =
      find.byValueKey('recoup_from_summer_trailing_icon');

  MainProductListingScreen(FlutterDriver driver) : super(driver);

  final lawn_food = find.text('Lawn Food');
  final insect_and_disease_control = find.text('Insect & Disease Control');
  final product_of_lawn_food = find.text('Scotts® GrubEx® Season-Long Grub Killer');
  final product = find.text('Scotts® Turf Builder® Weed & Feed₃');
  final need_help_with_finding_products =
      find.text('Need help with finding products?');
  final find_product = find.byValueKey('find_product');
  final lawn_problems_text = find.text('LAWN PROBLEMS');
  final lawn_goals = find.text('LAWN GOALS');

  final products = [
    'Insect & Disease Control',
    'Weed Control',
    'Lawn Food',
    'Grass Seeds'
  ];

  final lawn_problems = [
    'Bare Spots',
    'Thin Lawn',
    'Crabgrass',
    'Moss',
    'Dandelion',
    'Grubs',
    'Drought'
  ];

  final lawn_goals_menu = [
    'Grow Grass Quicker',
    'Increase Thickness',
    'Feed Grass',
    'Promote Root Development',
    'Strengthen Against Heat',
    'Increase Water Absorption',
    'Recoup from Summer'
  ];



  Future<void> verifyMainProductListingScreen() async {
    await verifyElementIsDisplayed(plp_cancel_button);
    await verifyElementIsDisplayed(find_product);
    await verifyElementIsDisplayed(search_button);
    await verifyElementIsDisplayed(insect_disease_control_trailing_icon);
    await verifyElementIsDisplayed(weed_control_trailing_icon);
    await verifyElementIsDisplayed(lawn_food_trailing_icon);
    await verifyElementIsDisplayed(grass_seeds_trailing_icon);
    for (var item in products) {
      await verifyElementIsDisplayed(find.text(item));
    }
    await verifyElementIsDisplayed(need_help_with_finding_products);
    await verifyElementIsDisplayed(lawn_problems_text);
    await verifyElementIsDisplayed(lawn_goals);
    for (var item in lawn_problems) {
      await scrollTillElementIsVisible(find.text(item));
    }
    await scrollUpToCategory();
  }

  Future<void> scrollUpToCategory() async {
    await scrollElement(plp_screen_parent, dy: 700);
  }

  Future<void> scrollTillEnd() async {
    await scrollElement(need_help_with_finding_product_label, dy: -640);
  }

  Future<void> clickOnLawnFood() async {
    await clickOn(lawn_food);
  }

  Future<void> clickOnInsectAndDiseaseControl() async {
    await clickOn(insect_and_disease_control);
  }

  Future<void> clickOnProduct() async {
    await clickOn(product);
  }

  Future<void> clickOnProductFromCategory() async {
    await clickOn(product_of_lawn_food);
  }

  Future<void> verifyLawnProblemElementsAreDisplayed() async {
    await verifyElementIsDisplayed(need_help_with_finding_product_label);
    await verifyElementIsDisplayed(lawn_problems_button);
    await verifyElementIsDisplayed(lawn_goals_button);
    await verifyElementIsDisplayed(bare_spots_label);
    await verifyElementIsDisplayed(bare_spots_leading_icon);
    await verifyElementIsDisplayed(bare_spots_trailing_icon);
    await verifyElementIsDisplayed(thin_lawn_leading_icon);
    await verifyElementIsDisplayed(thin_lawn_label);
    await verifyElementIsDisplayed(thin_lawn_trailing_icon);
    await verifyElementIsDisplayed(crabgrass_label);
    await verifyElementIsDisplayed(crabgrass_leading_icon);
    await verifyElementIsDisplayed(crabgrass_trailing_icon);
    await verifyElementIsDisplayed(moss_leading_icon);
    await verifyElementIsDisplayed(moss_label);
    await verifyElementIsDisplayed(moss_trailing_icon);
    await verifyElementIsDisplayed(dandelion_leading_icon);
    await verifyElementIsDisplayed(dandelion_label);
    await verifyElementIsDisplayed(dandelion_trailing_icon);
    await verifyElementIsDisplayed(grubs_leading_icon);
    await verifyElementIsDisplayed(grubs_label);
    await verifyElementIsDisplayed(grubs_trailing_icon);
    await verifyElementIsDisplayed(drought_leading_icon);
    await verifyElementIsDisplayed(drought_label);
    await verifyElementIsDisplayed(drought_trailing_icon);
  }

  Future<void> verifyLawnGoalsElementsAreDisplayed() async {
    await verifyElementIsDisplayed(need_help_with_finding_product_label);
    await verifyElementIsDisplayed(lawn_problems_button);
    await verifyElementIsDisplayed(lawn_goals_button);
    await verifyElementIsDisplayed(grow_grass_quicker_label);
    await verifyElementIsDisplayed(grow_grass_quicker_leading_icon);
    await verifyElementIsDisplayed(grow_grass_quicker_trailing_icon);
    await verifyElementIsDisplayed(increase_thickness_leading_icon);
    await verifyElementIsDisplayed(increase_thickness_label);
    await verifyElementIsDisplayed(increase_thickness_trailing_icon);
    await verifyElementIsDisplayed(feed_grass_leading_icon);
    await verifyElementIsDisplayed(feed_grass_label);
    await verifyElementIsDisplayed(feed_grass_trailing_icon);
    await verifyElementIsDisplayed(promote_root_development_leading_icon);
    await verifyElementIsDisplayed(promote_root_development_label);
    await verifyElementIsDisplayed(promote_root_development_trailing_icon);
    await verifyElementIsDisplayed(strengthen_against_heat_leading_icon);
    await verifyElementIsDisplayed(strengthen_against_heat_label);
    await verifyElementIsDisplayed(strengthen_against_heat_trailing_icon);
    await verifyElementIsDisplayed(increase_water_absorption_leading_icon);
    await verifyElementIsDisplayed(increase_water_absorption_label);
    await verifyElementIsDisplayed(increase_water_absorption_trailing_icon);
    await verifyElementIsDisplayed(recoup_from_summer_leading_icon);
    await verifyElementIsDisplayed(recoup_from_summer_label);
    await verifyElementIsDisplayed(recoup_from_summer_trailing_icon);
  }

  Future<void> clickOnLawnProblemButton() async {
    await clickOn(lawn_problems_button);
  }

  Future<void> clickOnLawnGoalsButton() async {
    await scrollElement(plp_screen_parent, dy: 50);
    await clickOn(lawn_goals_button);
  }

  Future<void> clickOnSearchButton() async {
    await clickOn(find_product);
  }

  Future<void> clickOnPlpCancelButton() async {
    await clickOn(plp_cancel_button);
  }

  Future<void> clickOnProductCategory(var product) async {
    final productName = product;
    switch (productName) {
      case 'Insect & Disease Control':
        await clickOn(insect_disease_control_label);
        break;
      case 'Weed Control':
        await clickOn(weed_control_label);
        break;
      case 'Lawn Food':
        await clickOn(lawn_food_label);
        break;
      case 'Grass Seeds':
        await clickOn(grass_seeds_label);
        break;
    }
  }

  Future<void> clickOnLawnProblemMenu(var item) async {
    final itemName = item;
    switch (itemName) {
      case 'Bare Spots':
        await clickOn(bare_spots_label);

        break;

      case 'Thin Lawn':
        await clickOn(thin_lawn_label);
        break;

      case 'Crabgrass':
        await clickOn(crabgrass_label);
        break;

      case 'Moss':
        await clickOn(moss_label);
        break;

      case 'Dandelion':
        await clickOn(dandelion_label);
        break;

      case 'Grubs':
        await clickOn(grubs_label);
        break;

      case 'Drought':
        await clickOn(drought_label);
        break;
    }
  }

  Future<void> clickOnLawnGrowMenu(var item) async {
    final itemName = item;
    switch (itemName) {
      case 'Grow Grass Quicker':
        await clickOn(grow_grass_quicker_label);
        break;

      case 'Increase Thickness':
        await clickOn(increase_thickness_label);
        break;

      case 'Feed Grass':
        await clickOn(feed_grass_label);
        break;

      case 'Promote Root Development':
        await clickOn(promote_root_development_label);
        break;

      case 'Strengthen Against Heat':
        await clickOn(strengthen_against_heat_label);
        break;

      case 'Increase Water Absorption':
        await clickOn(increase_water_absorption_label);
        break;

      case 'Recoup from Summer':
        await scrollTillElementIsVisible(recoup_from_summer_label);
        await clickOn(recoup_from_summer_label);
        break;
    }
  }
}
