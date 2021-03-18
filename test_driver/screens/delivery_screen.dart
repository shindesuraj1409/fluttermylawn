import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class DeliveryScreen extends BaseScreen {
  final delivery_parent = find.byType('CustomScrollView');
  final screen_header = find.text('We deliver what you need when you need it');
  final screen_sub_header = find.text(
      "When your lawn needs something, you'll receive a shipment. When you get it, simply apply the product(s) to your lawn. Seriously, it's as simple as that.");
  final choose_subscription_label =
      find.text('Choose a subscription that works for you');
  final close_icon_button = find.byValueKey('close_icon_button');

  final carousel_section = find.byType('CarouselSection');
  final carousel_section_list_view = find.descendant(
      of: find.byType('CarouselSection'), matching: find.byType('ListView'));

  var carousal_product_parent;
  final carousal_product_image = find.byType('ProductImage');
  final carousal_product_fade_in_image = find.byValueKey('product_image');
  final carousal_first_bag_image = find.byValueKey('bag_image_0');
  final carousal_first_bag_text = find.byValueKey('bag_text_0');
  final carousal_second_bag_image = find.byValueKey('bag_image_1');
  final carousal_second_bag_text = find.byValueKey('bag_text_1');
  final carousal_product_price = find.byValueKey('carousal_product_price');

  final choose_subscription = find.byType('ChooseSubscriptionSection');

//  final select_subscription_type = find.byType('Radio');

  final annual_subscription_card = find.byType('AnnualSubscriptionCard');
  final annual_subscription_label = find.text('Annual Subscription');
  final annual_subscription_best_value_label = find.text('BEST VALUE');
  final annual_discount_label = find.text('Save 10% off MSRP');
  final annual_subscription_text_1 = find.text('Full amount charged now');
  final annual_subscription_text_2 =
      find.text('Products are delivered when it is time to apply');
  final annual_subscription_text_3 = find.text(
      'Subscription automatically renews for each shipment and then starts again the following year until canceled. Cancel anytime.');
  final annual_subscription_text_4 = find.text('Free shipping');

  final seasonal_subscription_card = find.byType('SeasonalSubscriptionCard');
  final seasonal_subscription_label = find.text('Seasonal Subscription');
  final seasonal_pay_per_shipment_label = find.text('Pay Per Shipment');

//  final seasonal_first_shipment_label = find.descendant(
//      of: find.byType('SeasonalSubscriptionCard'),
//      matching: find.text('1st shipment: early spring'));
  final seasonal_show_all_shipments_label = find.descendant(
      of: find.byType('SeasonalSubscriptionCard'),
      matching: find.text('Show all 4 shipments'));
  final seasonal_show_all_shipments_icon = find.descendant(
      of: find.byType('SeasonalSubscriptionCard'),
      matching: find.byValueKey('show_all_shipments'));
  final seasonal_hide_all_shipments_icon = find.descendant(
      of: find.byType('SeasonalSubscriptionCard'),
      matching: find.byValueKey('hide_all_shipments'));
  final seasonal_show_less_label = find.descendant(
      of: find.byType('SeasonalSubscriptionCard'),
      matching: find.text('Show less'));

//  final seasonal_second_shipment_label = find.descendant(
//      of: find.byType('SeasonalSubscriptionCard'),
//      matching: find.text('2nd shipment: late spring'));
//  final seasonal_third_shipment_label = find.descendant(
//      of: find.byType('SeasonalSubscriptionCard'),
//      matching: find.text('3rd shipment: early summer'));
//  final seasonal_fourth_shipment_label = find.descendant(
//      of: find.byType('SeasonalSubscriptionCard'),
//      matching: find.text('4th shipment: early fall'));

  final seasonal_subscription_text_1 =
      find.text('Make multiple payments throughout the year');
  final seasonal_subscription_text_2 =
      find.text('Products are delivered when it is time to apply');
  final seasonal_subscription_text_3 = find.text(
      'Subscription automatically renews for each shipment and then starts again the following year until canceled. Cancel anytime.');
  final seasonal_subscription_text_4 = find.text('Free shipping');

  final faq_section = find.byType('FaqSection');

  final continue_button = find.text('CONTINUE');
  final your_recommendation_udpated =
      find.text('Your recommendation has been updated');
  final billing_and_shipping = find.byValueKey('billing_and_shipping');

  DeliveryScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyDeliveryScreenCommonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(screen_header);
    await verifyElementIsDisplayed(screen_sub_header);
    await verifyElementIsDisplayed(choose_subscription_label);
    await verifyElementIsDisplayed(close_icon_button);
    await verifyElementIsDisplayed(carousel_section);
  }

  Future<void> verifyProductCardDetails(List productData, int index) async {
//    final productName = productData[index][0];
    final bigBagQuantity = productData[index][2];
    final smallBagQuantity = productData[index][6];
    final price = productData[index][4];
    carousal_product_parent =
        await find.byValueKey('carousal_product_el_$index');

    await scrollTillElementIsVisible(carousal_product_parent,
        parent_finder: carousel_section_list_view, dx: -10);

    await verifyElementIsDisplayed(find.descendant(
        of: carousal_product_parent, matching: carousal_product_image));
    await verifyElementIsDisplayed(find.descendant(
        of: carousal_product_parent, matching: carousal_product_fade_in_image));
    //  Todo:DTI-765:Products name is displayed different in carousal section
//    await verifyElementIsDisplayed(find.descendant(
//        of: carousal_product_parent, matching: find.text(productName)));

    if(bigBagQuantity != null && smallBagQuantity != null)
      {
        await verifyElementIsDisplayed(find.descendant(
            of: carousal_product_parent, matching: carousal_first_bag_image));
        await verifyElementIsDisplayed(find.descendant(
            of: carousal_product_parent, matching: carousal_first_bag_text));
        await validate(
            (await getText(await find.descendant(
                of: carousal_product_parent, matching: carousal_first_bag_text))),
            bigBagQuantity);
        await verifyElementIsDisplayed(await find.descendant(
            of: carousal_product_parent, matching: carousal_product_price));
        await validate(
            (await getText(await find.descendant(
                of: carousal_product_parent, matching: carousal_product_price))),
            price);
        await verifyElementIsDisplayed(find.descendant(
            of: carousal_product_parent, matching: carousal_second_bag_image));
        await verifyElementIsDisplayed(find.descendant(
            of: carousal_product_parent, matching: carousal_second_bag_text));
        await validate(
            (await getText(await find.descendant(
                of: carousal_product_parent, matching: carousal_second_bag_text))),
            smallBagQuantity);
      }else
        {
          await verifyElementIsDisplayed(find.descendant(
              of: carousal_product_parent, matching: carousal_first_bag_image));
          await verifyElementIsDisplayed(find.descendant(
              of: carousal_product_parent, matching: carousal_first_bag_text));
          await validate(
              (await getText(await find.descendant(
                  of: carousal_product_parent, matching: carousal_first_bag_text))),
              bigBagQuantity);
          await verifyElementIsDisplayed(await find.descendant(
              of: carousal_product_parent, matching: carousal_product_price));
          await validate(
              (await getText(await find.descendant(
                  of: carousal_product_parent, matching: carousal_product_price))),
              price);
        }

  }

  Future<void> verifyAnnualSubscriptionOption(
      String price, String discountedPrice) async {
    await verifyElementIsDisplayed(annual_subscription_card);
    await scrollTillElementIsVisible(annual_subscription_card,
        parent_finder: choose_subscription, dy: -20);
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_subscription_label));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_discount_label));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_subscription_text_1));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_subscription_text_2));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_subscription_text_3));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card, matching: annual_subscription_text_4));
//    await verifyElementIsDisplayed(await find.descendant(
//        of: annual_subscription_card,
//        matching: find.text(price + '   ' + discountedPrice)));
    await verifyElementIsDisplayed(find.descendant(
        of: annual_subscription_card,
        matching: annual_subscription_best_value_label));
//    await verifyElementIsDisplayed(find.descendant(of: annual_subscription_card, matching: select_subscription_type));
  }

  Future<void> verifySeasonalSubscriptionOption(
      String price1, String price2, String price3, String price4, [var recommendedProductCount]) async {
    await verifyElementIsDisplayed(seasonal_subscription_card);
    await scrollTillElementIsVisible(seasonal_subscription_card,
        parent_finder: choose_subscription, dy: -20);
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card, matching: seasonal_subscription_label));
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_pay_per_shipment_label));
    if(recommendedProductCount != null)
      {
        final element = find.descendant(
            of: find.byType('SeasonalSubscriptionCard'),
            matching: find.text('Show all $recommendedProductCount shipments'));
        await verifyElementIsDisplayed(find.descendant(
            of: seasonal_subscription_card,
            matching: element));
      }else
        {
          await verifyElementIsDisplayed(find.descendant(
              of: seasonal_subscription_card,
              matching: seasonal_show_all_shipments_label));
        }

    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_show_all_shipments_icon));
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_subscription_text_1));
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_subscription_text_2));
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_subscription_text_3));
    await verifyElementIsDisplayed(find.descendant(
        of: seasonal_subscription_card,
        matching: seasonal_subscription_text_4));
//    await verifyElementIsDisplayed(find.descendant(of: seasonal_subscription_card, matching: select_subscription_type));
  }

  Future<void> selectAnnualSubscriptionOption() async {
    await scrollTillElementIsVisible(annual_subscription_card,
        parent_finder: choose_subscription, dy: -20);
    await clickOn(annual_subscription_card);
  }

  Future<void> selectSeasonalSubscriptionOption() async {
    await scrollTillElementIsVisible(seasonal_subscription_card,
        parent_finder: choose_subscription, dy: -20);
    await clickOn(seasonal_subscription_card);
  }

  Future<void> clickOnContinueButton() async {
    await clickOn(continue_button);
  }

  Future<void> clickOnCloseIcon() async {
    await clickOn(close_icon_button);
  }

  Future<void> verifyYourRecommendationUdpated() async {
    await verifyElementIsDisplayed(your_recommendation_udpated);
  }

  Future<void> clickOnbillingAndShipping() async {
    await clickOn(billing_and_shipping);
  }
}
