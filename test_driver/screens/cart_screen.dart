import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class CartScreen extends BaseScreen {
  // subscription_product_bundle
  final cart_screen_parent = find.byType('CustomScrollView');
  final subscription_product_bundle = find.byType('SubscriptionProductBundle');
  final annual_subscription_label = find.text('Annual Subscription');
  final subscription_products_price =
      find.byValueKey('subscription_products_price');
  final subscription_products_discounted_price =
      find.byValueKey('subscription_products_discounted_price');
  final annual_subscription_sub_label = find.text('You will be charged today');
  final seasonal_subscription_label = find.text('Seasonal Subscription');
  final seasonal_subscription_sub_label =
      find.text('You will be charged [before each shipment]');
  var subscription_bundle_product_image_container =
      'subscription_bundle_product_image_replace_index';
  var subscription_bundle_product_image = find.byValueKey('product_image');

  // addons
  final addons_section = find.byType('AddonsSection');
  final addons_label = find.text('One Time Add-ons');
  var addons_count = 'replace_quantity items';
  final addons_sub_label_for_annual_subscription =
      find.text('You will be charged today');
  final addons_sub_label_for_seasonal_subscription =
      find.text('You will be charged at the time of the first shipment');
  final addons_bag_image = find.byValueKey('bag_image_0');
  final addons_bag_text = find.byValueKey('bag_text_0');

  final addons_carousel = find.descendant(
      of: find.byType('AddonsSection'),
      matching: find.byType('AddonsCarousel'));
  var addon_card = 'addons_card_index';
  final addon_card_image = find.byValueKey('product_image');
  final addon_card_add_to_cart = find.text('ADD TO CART');
  final addon_card_remove_from_cart = find.text('REMOVE');
  final addon_card_add_to_cart_image = find.byValueKey('add_image');
  final addon_card_remove_from_cart_image = find.byValueKey('remove_image');

  // order summary card
  final order_summary_card = find.byType('OrderSummaryCard');
  final order_summary_label = find.text('Order Summary');
  final order_summary_show_all = find.byValueKey('view_all');
  final order_summary_show_less = find.byValueKey('view_less');

  final cart_item_list = find.byType('_CartItemList');
  final order_summary_annual_subscription_label =
      find.text('Annual Subscription');
  final order_summary_seasonal_subscription_label =
      find.text('Seasonal Subscription');
  final order_summary_promo_label = find.text('Promo Code: Annual Discount');

  final sub_total_row = find.byType('_TotalRow');
  final sub_total_row_subtotal_label = find.text('Subtotal');
  final sub_total_row_shipping_label = find.text('Shipping');

  final checkout_button = find.text('CHECKOUT');

  CartScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyCartScreenIsDisplayed(
      {bool isAnnualSubscription = true}) async {
    await verifyElementIsDisplayed(subscription_product_bundle);
    (isAnnualSubscription)
        ? await verifyElementIsDisplayed(annual_subscription_label)
        : await verifyElementIsDisplayed(seasonal_subscription_label);
    await verifyElementIsDisplayed(back_button);
    await validate(await getText(header_title), 'Your Cart');
    await verifyElementIsDisplayed(checkout_button);
    await verifyElementIsDisplayed(addons_section);
    await scrollTillElementIsVisible(order_summary_card,
        parent_finder: cart_screen_parent, dy: -30);
    await verifyElementIsDisplayed(order_summary_card);
  }

  Future<void> verifyAnnualSubscriptionIsDisplayed(
      String price, String discountedPrice, int imagesCount) async {
    await scrollTillElementIsVisible(
        find.descendant(
            of: subscription_product_bundle,
            matching: annual_subscription_label),
        parent_finder: cart_screen_parent,
        dy: 50);
    await verifyElementIsDisplayed(find.descendant(
        of: subscription_product_bundle,
        matching: subscription_products_price));
    await verifyElementIsDisplayed(find.descendant(
        of: subscription_product_bundle,
        matching: subscription_products_discounted_price));
    await verifyElementIsDisplayed(find.descendant(
        of: subscription_product_bundle,
        matching: annual_subscription_sub_label));
    await validate(
        await getText(await find.descendant(
            of: subscription_product_bundle,
            matching: subscription_products_price)),
        price);
    await validate(
        await getText(await find.descendant(
            of: subscription_product_bundle,
            matching: subscription_products_discounted_price)),
        discountedPrice);

    for (var i = 0; i < imagesCount; i++) {
      await verifyElementIsDisplayed(find.byValueKey(
          subscription_bundle_product_image_container.replaceAll(
              'replace_index', i.toString())));

      await verifyElementIsDisplayed(find.descendant(
          of: (await find.byValueKey(subscription_bundle_product_image_container
              .replaceAll('replace_index', i.toString()))),
          matching: subscription_bundle_product_image));
    }
  }

  Future<void> verifySeasonalSubscriptionIsDisplayed(
      String price, int imagesCount) async {
    await scrollTillElementIsVisible(
        find.descendant(
            of: subscription_product_bundle,
            matching: seasonal_subscription_label),
        parent_finder: cart_screen_parent,
        dy: 50);
    await verifyElementIsDisplayed(find.descendant(
        of: subscription_product_bundle,
        matching: seasonal_subscription_sub_label));

    for (var i = 0; i < imagesCount; i++) {
      await verifyElementIsDisplayed(find.byValueKey(
          subscription_bundle_product_image_container.replaceAll(
              'replace_index', i.toString())));

      await verifyElementIsDisplayed(find.descendant(
          of: (await find.byValueKey(subscription_bundle_product_image_container
              .replaceAll('replace_index', i.toString()))),
          matching: subscription_bundle_product_image));
    }
  }

  Future<void> clickOnaddonCardAddToCartImage() async {
    await clickOn(addon_card_add_to_cart_image);
  }

  Future<void> clickOnaddonCardRemoveFromCartImage() async {
    await clickOn(addon_card_remove_from_cart_image);
  }

  Future<void> verifyAddonsCommonElementsAreDisplayed(int itemsCount,
      {bool isAnnualSubscription = true}) async {
    await verifyElementIsDisplayed(addons_section);
    await verifyElementIsDisplayed(
        find.descendant(of: addons_section, matching: addons_label));
    await verifyElementIsDisplayed(find.descendant(
        of: addons_section,
        matching: (isAnnualSubscription)
            ? addons_sub_label_for_annual_subscription
            : addons_sub_label_for_seasonal_subscription));
    await verifyElementIsDisplayed(await find.descendant(
        of: addons_section,
        matching: await find.text(addons_count.replaceAll(
            'replace_quantity', itemsCount.toString()))));
  }

  Future<void> scrollAddonInView() async {
    await scrollTillElementIsVisible(addons_carousel,
        parent_finder: addons_section, dy: -10);
    await sleep(Duration(seconds: 2));
  }

  Future<void> verifyAddonsDetails(List addonData, int index) async {
//    final name = addonData[index][0];
//    final price = addonData[index][1];
    final addonCardParent =
        await find.byValueKey(addon_card.replaceAll('index', index.toString()));

    await scrollTillElementIsVisible(addonCardParent,
        parent_finder: cart_screen_parent, dx: -5);

    await verifyElementIsDisplayed(
        await find.descendant(of: addonCardParent, matching: addon_card_image));
    await verifyElementIsDisplayed(await find.descendant(
        of: addonCardParent, matching: addon_card_add_to_cart));
    await verifyElementIsDisplayed(await find.descendant(
        of: addonCardParent, matching: addon_card_add_to_cart_image));
    //  Todo:DTI-765:Products name is displayed different Add on section
//    await verifyElementIsDisplayed(await find.descendant(
//        of: addonCardParent, matching: await find.text(name)));
//    await verifyElementIsDisplayed(await find.descendant(
//        of: addonCardParent, matching: await find.text(price)));
    await verifyElementIsDisplayed(
        await find.descendant(of: addonCardParent, matching: addons_bag_image));
    await verifyElementIsDisplayed(
        await find.descendant(of: addonCardParent, matching: addons_bag_text));
  }

  Future<void> addAddonToCart(int index) async {

    final addonCardParent =
        await find.byValueKey(addon_card.replaceAll('index', index.toString()));
    await scrollTillElementIsVisible(find.byValueKey(addon_card.replaceAll('index', '0')), parent_finder: cart_screen_parent, dx: 200);
    await scrollTillElementIsVisible(addonCardParent, parent_finder: cart_screen_parent, dx: -200);
    await verifyElementIsDisplayed(await find.descendant(
        of: addonCardParent, matching: addon_card_add_to_cart));
    await clickOn(await find.descendant(
        of: addonCardParent, matching: addon_card_add_to_cart));
  }

  Future<void> removeAddonToCart(int index) async {
    final addonCardParent =
        await find.byValueKey(addon_card.replaceAll('index', index.toString()));
    await clickOn(await find.descendant(
        of: addonCardParent, matching: addon_card_remove_from_cart));
  }

  Future<void> verifyOrderSummary(
      bool isAnnualSubscription,
      String subscriptionTotal,
      String discount,
      String subTotal,
      String shipping) async {
    await verifyElementIsDisplayed(order_summary_card);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: order_summary_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: order_summary_show_less));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: cart_item_list));

    final cart_list_parent =
        await find.descendant(of: order_summary_card, matching: cart_item_list);

    if (isAnnualSubscription) {
      await verifyElementIsDisplayed(await find.descendant(
          of: cart_list_parent,
          matching: order_summary_annual_subscription_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: cart_list_parent, matching: order_summary_promo_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: cart_list_parent, matching: await find.text(subscriptionTotal)));
      await verifyElementIsDisplayed(await find.descendant(
          of: cart_list_parent, matching: await find.text(discount)));
    } else {
      await verifyElementIsDisplayed(await find.descendant(
          of: cart_list_parent,
          matching: order_summary_seasonal_subscription_label));
    }

    final total_row_parent =
        await find.descendant(of: order_summary_card, matching: sub_total_row);
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: sub_total_row_subtotal_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: await find.text(subTotal)));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: sub_total_row_shipping_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: await find.text(shipping)));
  }

  Future<void> verifyAddOnOrderSummary(String subscriptionTotal,
      String discount, String subTotal, String shipping) async {
    await verifyElementIsDisplayed(order_summary_card);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: order_summary_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: order_summary_show_less));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_card, matching: cart_item_list));

    final total_row_parent =
        await find.descendant(of: order_summary_card, matching: sub_total_row);
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: sub_total_row_subtotal_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: await find.text(subTotal)));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: sub_total_row_shipping_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: total_row_parent, matching: await find.text(shipping)));
  }

  Future<void> verifyAddonInOrderSummary(String addonName, String price) async {
    final cart_list_parent =
        await find.descendant(of: order_summary_card, matching: cart_item_list);
    await verifyElementIsDisplayed(await find.descendant(
        of: cart_list_parent, matching: await find.text(addonName)));
    await verifyElementIsDisplayed(await find.descendant(
        of: cart_list_parent, matching: await find.text(price)));
  }

  Future<void> clickOnCheckout() async {
    await clickOn(checkout_button);
  }
}
