import 'package:flutter_driver/flutter_driver.dart';
import 'base_screen.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

class ProductListingScreen extends BaseScreen {
  final product_search = find.byValueKey('product_search');
  final filters_button = find.byValueKey('filter_button');
  final product_count = find.byValueKey('Items_count');
  final filter_text = find.byValueKey('filter_text');

// Filter sections
  final filter_grass_type_section = find.text('Grass Type');
  final filter_sunlight_section = find.text('Sunlight');
  final filter_type_of_control_section = find.text('Type of Control');
  final filter_weed_type_section = find.text('Weed Type');

  // Filter options
  final bermuda_option_label = find.text('Bermuda');
  final bluegrass_option_label = find.text('Bluegrass/Rye/Fescue');
  final buffalo_grass_option_label = find.text('Buffalo grass');
  final fine_fescue_option_label = find.text('Fine Fescue');
  final kentucky_option_label = find.text('Kentucky bluegrass');
  final ryegrass_option_label = find.text('Ryegrass');
  final tall_fescue_option_label = find.text('Tall Fescue');
  final zoysia_option_label = find.text('Zoysia');
  final shade_option_label = find.text('Shade');
  final full_sun_option_label = find.text('Full Sun');
  final partial_sun_option_label = find.text('Partial Sun');
  final insects_option_label = find.text('Insects');
  final diseases_option_label = find.text('Diseases');
  final crabgrass_option_label = find.text('Crabgrass');
  final moss_option_label = find.text('Moss');
  final dandelion_option_label = find.text('Dandelion');
  final clover_option_label = find.text('Clover');

// Checkboxes on filter box
  final bermuda_option_checkbox = find.byValueKey('filter_checkbox_bermuda');
  final bluegrass_option_checkbox =
      find.byValueKey('filter_checkbox_bluegrass/rye/fescue');
  final buffalo_grass_option_checkbox =
      find.byValueKey('filter_checkbox_buffalo_grass');
  final fine_fescue_option_checkbox =
      find.byValueKey('filter_checkbox_fine_fescue');
  final kentucky_option_checkbox =
      find.byValueKey('filter_checkbox_kentucky_bluegrass');
  final ryegrass_option_checkbox = find.byValueKey('filter_checkbox_ryegrass');
  final tall_fescue_option_checkbox =
      find.byValueKey('filter_checkbox_tall_fescue');
  final zoysia_option_checkbox = find.byValueKey('filter_checkbox_zoysia');
  final shade_option_checkbox = find.byValueKey('filter_checkbox_shade');
  final full_sun_option_checkbox = find.byValueKey('filter_checkbox_full_sun');
  final partial_sun_option_checkbox =
      find.byValueKey('filter_checkbox_partial_sun');
  final insects_option_checkbox = find.byValueKey('filter_checkbox_insects');
  final diseases_option_checkbox = find.byValueKey('filter_checkbox_diseases');
  final crabgrass_option_checkbox =
      find.byValueKey('filter_checkbox_crabgrass');
  final moss_option_checkbox = find.byValueKey('filter_checkbox_moss');
  final dandelion_option_checkbox =
      find.byValueKey('filter_checkbox_dandelion');
  final clover_option_checkbox = find.byValueKey('filter_checkbox_clover');

  final clear_filter_button = find.byValueKey('clear_filter_button');
  final filter_box_title = find.text('Filters');
  final filter_box_cancel_button = find.text('CANCEL');
  final show_product_button = find.byValueKey('show_product_button');

  // Select Deselect all buttons
  final grass_type_select_deselect_all_button =
      find.byValueKey('grass_type_filter_checkbox_select_deselect_all');
  final sunlight_select_deselect_all_button =
      find.byValueKey('sunlight_filter_checkbox_select_deselect_all');
  final type_of_control_select_deselect_all_button =
      find.byValueKey('type_of_control_filter_checkbox_select_deselect_all');
  final weed_type_select_deselect_all_button =
      find.byValueKey('weed_type_filter_checkbox_select_deselect_all');

// Show more and less
  final grass_type_show_more_and_show_less_button =
      find.byValueKey('grass_type_filter_options_show_more_and_show_less');

  //no result found screen
  final not_found_icon = find.byValueKey('not_found_icon');
  final no_result_found_label = find.text('No Results found');
  final please_try_different_keyword_label =
      find.text('Please try different keywords.');

  var plp_title_card;
  var productDetailsScreen;

  ProductListingScreen(FlutterDriver driver) : super(driver);

  Future<void> clickOnSelectAllOption() async {
    await clickOn(grass_type_select_deselect_all_button);
    await clickOn(sunlight_select_deselect_all_button);
    await clickOn(type_of_control_select_deselect_all_button);
    await clickOn(weed_type_select_deselect_all_button);
  }

  //Scroll Filter Screen Up
  Future<void> scrollUpFilterScreen() async {
    await scrollElement(filter_type_of_control_section, dy: 300);
  }

  //Scroll Filter Screen Down
  Future<void> scrollDownFilterScreen() async {
    await scrollElement(filter_type_of_control_section, dy: -200);
  }

  Future<void> verifyPageTitle(var expectedTitle) async {
    await validate(await getText(header_title), expectedTitle);
  }

  Future<void> clickOnFilterButton() async {
    await clickOn(filters_button);
  }

  Future<void> verifyDeselectAllisDisplayed() async {
    await validate(
        await getText(grass_type_select_deselect_all_button), 'Deselect all');
    await validate(
        await getText(sunlight_select_deselect_all_button), 'Deselect all');
    await validate(await getText(type_of_control_select_deselect_all_button),
        'Deselect all');
    await validate(
        await getText(weed_type_select_deselect_all_button), 'Deselect all');
  }

  Future<void> verifySelectAllisDisplayed() async {
    await validate(
        await getText(grass_type_select_deselect_all_button), 'Select All');
    await validate(
        await getText(sunlight_select_deselect_all_button), 'Select All');
    await validate(await getText(type_of_control_select_deselect_all_button),
        'Select All');
    await validate(
        await getText(weed_type_select_deselect_all_button), 'Select All');
  }

  Future<void> clickOnClearFiltersButton() async {
    await clickOn(clear_filter_button);
  }

  Future<void> clickOnFiltersBoxCancelButton() async {
    await clickOn(filter_box_cancel_button);
  }

  Future<void> verifyProductScreen(var product) async {
    final productName = product;
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(product_search);
    await validate(await getText(header_title), productName);
    await verifyElementIsDisplayed(product_count);
    await verifyElementIsDisplayed(filters_button);
    final itemCount = await getNumberOfProductsDisplayed();
    await verifyProductsAreDisplayedInProductScreen(itemCount);
  }

  Future<void> verifyProductsAreDisplayedInProductScreen(var totalItems) async {
    //Verify only top 5 products on Product listing Screen
    if (totalItems > 5) {
      totalItems = 5;
    }
    for (var i = 0; i < totalItems; i++) {
      plp_title_card = await find.byValueKey('plp_tile_card_' + i.toString());
      await verifyElementIsDisplayed(plp_title_card);
    }
  }

  Future<void> verifyFilterBox() async {
    await verifyElementIsDisplayed(filter_box_title);
    await verifyElementIsDisplayed(filter_box_cancel_button);
    await verifyElementIsDisplayed(filter_grass_type_section);
    await verifyElementIsDisplayed(bermuda_option_label);
    await verifyElementIsDisplayed(bermuda_option_checkbox);
    await clickOn(grass_type_show_more_and_show_less_button);
    await verifyElementIsDisplayed(bluegrass_option_label);
    await verifyElementIsDisplayed(bluegrass_option_checkbox);
    await verifyElementIsDisplayed(buffalo_grass_option_label);
    await verifyElementIsDisplayed(buffalo_grass_option_checkbox);
    await verifyElementIsDisplayed(fine_fescue_option_label);
    await verifyElementIsDisplayed(fine_fescue_option_checkbox);
    await verifyElementIsDisplayed(kentucky_option_label);
    await verifyElementIsDisplayed(kentucky_option_checkbox);
    await verifyElementIsDisplayed(ryegrass_option_label);
    await verifyElementIsDisplayed(ryegrass_option_checkbox);
    await verifyElementIsDisplayed(tall_fescue_option_label);
    await verifyElementIsDisplayed(tall_fescue_option_checkbox);
    await verifyElementIsDisplayed(zoysia_option_label);
    await verifyElementIsDisplayed(zoysia_option_checkbox);
    await scrollTillElementIsVisible(grass_type_show_more_and_show_less_button);
    await clickOn(grass_type_show_more_and_show_less_button);
    await verifyElementIsDisplayed(filter_sunlight_section);
    await verifyElementIsDisplayed(shade_option_label);
    await verifyElementIsDisplayed(shade_option_checkbox);
    await verifyElementIsDisplayed(full_sun_option_label);
    await verifyElementIsDisplayed(full_sun_option_checkbox);
    await verifyElementIsDisplayed(partial_sun_option_label);
    await verifyElementIsDisplayed(partial_sun_option_checkbox);
    await verifyElementIsDisplayed(filter_type_of_control_section);
    await verifyElementIsDisplayed(insects_option_label);
    await verifyElementIsDisplayed(insects_option_checkbox);
    await verifyElementIsDisplayed(diseases_option_label);
    await verifyElementIsDisplayed(diseases_option_checkbox);
    await scrollDownFilterScreen();
    await verifyElementIsDisplayed(filter_weed_type_section);
    await verifyElementIsDisplayed(crabgrass_option_label);
    await verifyElementIsDisplayed(crabgrass_option_checkbox);
    await verifyElementIsDisplayed(moss_option_label);
    await verifyElementIsDisplayed(moss_option_checkbox);
    await verifyElementIsDisplayed(dandelion_option_label);
    await verifyElementIsDisplayed(dandelion_option_checkbox);
    await verifyElementIsDisplayed(clover_option_label);
    await verifyElementIsDisplayed(clover_option_checkbox);
    await verifyElementIsDisplayed(show_product_button);
    await verifyElementIsDisplayed(clear_filter_button);
    await scrollUpFilterScreen();
  }

  Future<int> getNumberOfProductsDisplayed() async {
    final countText = await getText(product_count);
    final count = int.parse(countText.split(' ')[0]);
    return count;
  }

  Future<void> clickOnProduct(var index) async {
    plp_title_card = await find.byValueKey('plp_tile_card_' + index.toString());
    await clickOn(plp_title_card);
  }

  Future<void> clickOnProductUsingName(var productName) async
  {
    final productCount = await getNumberOfProductsDisplayed();
    for(var i=0;i<productCount;i++)
      {
        final listedProductName = await getProductName(i);
        if(listedProductName == productName)
          {
            await clickOnProduct(i);
            break;
          }
        else if(i==productCount-1)
        {
          throw Exception('Product $productName not listed here');
        }

      }

  }

  Future<String> getProductName(var index) async {
    plp_title_card = find.byValueKey('plp_tile_card_' + index.toString());
    final productName = await getText(find.descendant(
        of: plp_title_card,
        matching: find.byType('Text'),
        firstMatchOnly: true));
    return productName;
  }

  Future<void> verifyProductDetails(
      var totalProductDisplayed, var subCategory, var mainCategory) async {
    productDetailsScreen = ProductDetailsScreen(driver);
    for (var i = 0; i < totalProductDisplayed; i++) {
      //get the product Name
      final productName = await getProductName(i);
      //Click on Product
      await clickOnProduct(i);
      //Verify Products on Product Detail screen
      await productDetailsScreen.verifyProductDetailsCommonElements(
          productName, subCategory, 'Lawn Goals');
      //Tap on Back key of Product Details screen
      await productDetailsScreen.goToBack();
    }
  }

  Future<void> verifySelectAllFilterFunctionality(
      SerializableFinder filterOption) async {
    //Get the Number of Products On Page
    final defaultNumberOfProductsDisplayed =
        await getNumberOfProductsDisplayed();
    //Tap on Filter button
    await clickOnFilterButton();
    //Verify Filter Screen
    await verifyFilterBox();
    //Uncheck Bermuda Option
    await clickOn(bermuda_option_checkbox);
    //Tap on Filter Option
    if (filterOption == weed_type_select_deselect_all_button) {
      await scrollDownFilterScreen();
    }
    await validate(await getText(filterOption), 'Select All');
    //Click on Filter Option
    await clickOn(filterOption);
    // Verify DeSelectAll is displayed for the clicked filter
    await validate(await getText(filterOption), 'Deselect all');
    //Get number of Products filtered
    final filteredProductCount = int.parse(
        (await getText(show_product_button)).toString().split(' ')[1]);
    //Check filterProductCount is greater than 0
    if (filteredProductCount > 0) {
      await clickOn(show_product_button);
      final noOfProductsDisplayedAfterApplyingFilter =
          await getNumberOfProductsDisplayed();
      //Validate if Item Count is same as Filter Products
      await expect(
        filteredProductCount,
        noOfProductsDisplayedAfterApplyingFilter,
      );
      //Validate filter Count
      if (filterOption == grass_type_select_deselect_all_button) {
        await validate(await getText(filter_text), 'FILTERS 8');
      }
      if (filterOption == sunlight_select_deselect_all_button) {
        await validate(await getText(filter_text), 'FILTERS 3');
      }
      if (filterOption == type_of_control_select_deselect_all_button) {
        await validate(await getText(filter_text), 'FILTERS 2');
      }
      if (filterOption == weed_type_select_deselect_all_button) {
        await validate(await getText(filter_text), 'FILTERS 4');
      }
      //Verify Products on Product Screen
      await verifyProductsAreDisplayedInProductScreen(filteredProductCount);
      //Tap on Filter button
      await clickOnFilterButton();

      if (filterOption == weed_type_select_deselect_all_button) {
        await scrollDownFilterScreen();
      }
      //Verify Select all is displayed
      await validate(await getText(filterOption), 'Deselect all');
      //Clear the filter
      await clickOnClearFiltersButton();

      final currentDisplayedProducts = await getNumberOfProductsDisplayed();
      await expect(currentDisplayedProducts, defaultNumberOfProductsDisplayed);
    } else {
      //Tap on Clear Filter button
      await clickOnClearFiltersButton();
      final currentDisplayedProducts = await getNumberOfProductsDisplayed();
      await expect(currentDisplayedProducts, defaultNumberOfProductsDisplayed);
    }
  }

  Future<void> checkClearFilter(var filterType) async {
    switch (filterType) {
      case 'Grass Type':
        await verifyClearFilterFunctionality(
            grass_type_select_deselect_all_button);
        break;
      case 'Sunlight':
        await verifyClearFilterFunctionality(
            sunlight_select_deselect_all_button);
        break;
      case 'Type of Control':
        await verifyClearFilterFunctionality(
            type_of_control_select_deselect_all_button);
        break;
      case 'Weed Type':
        await verifyClearFilterFunctionality(
            weed_type_select_deselect_all_button);
    }
  }

  Future<void> verifyClearFilterFunctionality(
      SerializableFinder filterOption) async {
    //Get the Number of Products On Page
    final defaultnumberOfProductsDisplayed =
        await getNumberOfProductsDisplayed();
    //Tap on Filter button
    await clickOnFilterButton();
    //Verify Filter Screen
    await verifyFilterBox();
    //Uncheck Bermuda Option
    await clickOn(bermuda_option_checkbox);
    //Tap on Filter Option
    if (filterOption == weed_type_select_deselect_all_button) {
      await scrollDownFilterScreen();
    }
    await clickOn(filterOption);
    // Verify DeSelectAll is displayed for the clicked filter
    await validate(await getText(filterOption), 'Deselect all');
    //Get number of Products filtered
    final filteredProductCount = int.parse(
        (await getText(show_product_button)).toString().split(' ')[1]);
    //Check filterProductCount is greater than 0
    if (filteredProductCount > 0) {
      await clickOn(show_product_button);
      final noOfProductsDisplayedAfterApplyingFilter =
          await getNumberOfProductsDisplayed();
      //Validate if Item Count is same as Filter Products
      await expect(
        filteredProductCount,
        noOfProductsDisplayedAfterApplyingFilter,
      );
      //Verify Products on Product Screen
      await verifyProductsAreDisplayedInProductScreen(filteredProductCount);
      //Tap on Filter button
      await clickOnFilterButton();

      //Tap on Clear Filter button
      await clickOnClearFiltersButton();
      final numberOfProductsAfterTappingClearFilterButton =
          await getNumberOfProductsDisplayed();
      //Validate Filter is cleared and Default ItemCounts are displayed
      await expect(numberOfProductsAfterTappingClearFilterButton,
          defaultnumberOfProductsDisplayed);

      //Tap on Filter button
      await clickOnFilterButton();
      if (filterOption == weed_type_select_deselect_all_button) {
        await scrollDownFilterScreen();
      }
      //Verify Select all is displayed
      await validate(await getText(filterOption), 'Select All');
      //Close the Filter Screen
      await clickOn(filter_box_cancel_button);
    } else {
      //Tap on Clear Filter button
      await clickOnClearFiltersButton();
      final numberOfProductsAfterTappingClearFilterButton =
          await getNumberOfProductsDisplayed();
      //Validate Filter is cleared and Default ItemCounts are displayed
      await expect(numberOfProductsAfterTappingClearFilterButton,
          defaultnumberOfProductsDisplayed);
      //Tap on Filter button
      await clickOnFilterButton();
      if (filterOption == weed_type_select_deselect_all_button) {
        await scrollDownFilterScreen();
      }
      //Verify Select all is displayed
      await validate(await getText(filterOption), 'Select All');
      //Close the Filter Screen
      await clickOn(filter_box_cancel_button);
    }
  }
}
