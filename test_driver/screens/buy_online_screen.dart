import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class BuyOnlineScreen extends BaseScreen {
  final custom_scroll_view = find.byType('CustomScrollView');
  final not_found_icon = find.byValueKey('not_found_icon');
  final not_found_text1 =
      find.text('Product cannot be found online at moment.');
  final not_found_text2 =
      find.text('Try another product or see what’s popular in your area');
  final partner_retailers = find.text('Partner Retailers');
  final retailer_card = 'retailer_card_el_';

  BuyOnlineScreen(FlutterDriver driver) : super(driver);


  //Verify Buy Online Screen
  Future<void> verifyBuyOnlineScreenIsDisplayed({bool isInStock}) async {
    await validate(await getText(header_title), 'Buy Online');
    await verifyElementIsDisplayed(back_button);
    if(isInStock!=null){
      if(isInStock) {
        await verifyElementIsDisplayed(partner_retailers);
      } else
      {
        await verifyElementIsDisplayed(not_found_icon);
        await verifyElementIsDisplayed(not_found_text1);
        await verifyElementIsDisplayed(not_found_text2);
      }
    }

  }


  //Verify Scotts and Other retailer elements
  Future<void> verifyBuyOnlineScreenRetailerElements(var noOfRetailers) async {
    for (var index = 0; index <= noOfRetailers; index++) {
      final parent_card = find.byValueKey(retailer_card + index.toString());
      if (index == 0) {
        await verifyElementIsDisplayed(find.descendant(
            of: parent_card, matching: find.byValueKey('The Scotts Company')));
      }
      final in_stock_website = find.byValueKey('in_stock_see_website_$index');
      await verifyElementIsDisplayed(
          find.descendant(of: parent_card, matching: in_stock_website));
      await getText(in_stock_website) == 'In Stock'
          ? await validate(await getText(in_stock_website), 'In Stock')
          : await validate(await getText(in_stock_website), 'See Website');

      final trailing_icon = find.byValueKey('trailing_icon_$index');
      await verifyElementIsDisplayed(
          find.descendant(of: parent_card, matching: trailing_icon));
      await scrollUntilElementIsVisible(
          element: parent_card, scrollableView: custom_scroll_view, dy: -100);
    }
  }




  Future<void> verifyRetailersOnBuyOnlineScreen(List retailerNames, {bool isInStock}) async
  {
    await scrollElement(custom_scroll_view,dy: 500);
    for (var retailer in retailerNames) {
      var index = 0;
      var retailerFound = 0;

      while (retailerFound == 0) {
        final parentElement = find.byValueKey(retailer_card + index.toString());
        try {
          try {
            if (index > 6) {
              await scrollTillElementIsVisible(parentElement, dy: -100);
            }
            await verifyElementIsDisplayed(parentElement);
          }
          catch (e) {
            retailerFound = 1;
            throw Exception('Retailer: $retailer not present in the list');
          }

          await verifyElementIsDisplayed(find.descendant(
              of: parentElement, matching: find.byValueKey(retailer)),
              timeout: 5);
          if(isInStock!=null){
            isInStock ? await verifyElementIsDisplayed(find.descendant(
                of: parentElement, matching: find.text('In Stock')), timeout: 5)
                : await verifyElementIsDisplayed(find.descendant(
                of: parentElement, matching: find.text('See Website')),
                timeout: 5);
          }
          retailerFound = 1;
          break;
        }
        catch (e) {
          index++;
          if (retailerFound == 0) {
            continue;
          }
          else {
            throw Exception('Retailer: $retailer not present in the list');
          }
        }
      }
    }
  }
}
