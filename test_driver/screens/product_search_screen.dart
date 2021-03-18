import 'package:flutter_driver/flutter_driver.dart';
import 'base_screen.dart';

class ProductSearchScreen extends BaseScreen {
  final parent_list_view = find.byType('ListView');
  final not_found_icon = find.byValueKey('not_found_icon');
  final no_result_found_label = find.text('No Results found');
  final please_try_different_keyword_label =
      find.text('Please try different keywords.');
  final search_input = find.byValueKey('search_input');
  final search_cancel_button = find.text('CANCEL');
  final product_image = find.byValueKey('product_image');
  var plp_tile_card;
  var product_text;

  ProductSearchScreen(FlutterDriver driver) : super(driver);

  Future<void> enterProductName(String product) async {
    await typeIn(search_input, product);
  }

  Future<void> verifyProductSearchScreen() async {
    await verifyElementIsDisplayed(search_input);
    await verifyElementIsDisplayed(search_cancel_button);
  }

  Future<void> verifySearchResult(var productName) async {
    //Verify plp_tile_card is displayed
    product_text = find.byValueKey(productName
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '_')
            .replaceAll("'", '') +
        '_option');
    //Verify Product text is displayed
    await scrollUntilElementIsVisible(element: product_text, scrollableView: parent_list_view);
    //Validate Product Name
    await validate(await getText(product_text), productName);
    //Verify Product image is displayed
    await verifyElementIsDisplayed(product_image);
  }

  Future<void> clickOnSearchCancelButton() async {
    await clickOn(search_cancel_button);
  }

  Future<void> verifyNoResultFoundScreen() async {
    await waitForElementToLoad('key', 'not_found_icon');
    await verifyElementIsDisplayed(not_found_icon);
    await verifyElementIsDisplayed(no_result_found_label);
    await verifyElementIsDisplayed(please_try_different_keyword_label);
  }
}
