import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class MySubscriptionScreen extends BaseScreen {
  final screen_parent = find.byType('CustomScrollView');
  var items_label = 'replace_items_qty items';
  final products_section = find.byValueKey('products_list_view');
  final my_subscription_parent = find.byType('CustomScrollView');
  var subscription_card = 'subscription_card_el_ID';
  final shipment_label = find.text('SHIPMENT');
  final product_image = find.byValueKey('product_image');
  final bag_image = find.byValueKey('bag_image');
  final bag_text = find.byValueKey('bag_text');
  final product_name = find.byValueKey('product_name');
  final large_bag_image = find.byValueKey('large_bag_image');
  final large_bag_text = find.byValueKey('large_bag_text');

  final subscription_type_section =
      find.byValueKey('subscription_type_section');
  final subscription_type_text = find.text('Subscription Type');
  final subscription_type_label = find.byValueKey('section_main_label');
  final subscription_status_label =
      find.byValueKey('subscription_status_label');

  var section_main_label = 'section_main_label';
  final start_date_section = find.byValueKey('start_date_section');
  final renewal_date_section = find.byValueKey('renewal_date_section');

  final billing_info_section = find.byValueKey('billing_info_section');
  final billing_info_text = find.text('Billing Info');
  final billing_info_card_image = find.byValueKey('image');
  final billing_info_card_number = find.byValueKey('section_main_label');
  final billing_info_navigate_to_icon = find.byValueKey('navigate_to_icon');

  final shipping_address_section = find.byValueKey('shipping_address_section');
  final shipping_info_text = find.text('Shipping Address');
  final shipping_info_address = find.byValueKey('section_main_label');
  final shipping_info_i_have_moved_text = find.text('I have moved');
  final shipping_info_i_have_moved_icon = find.byValueKey('i_have_moved_icon');

  final cancel_subscription_button = find.text('CANCEL SUBSCRIPTION');
  final get_a_new_plan_button = find.text('GET A NEW PLAN');
  final faq = find.byValueKey('faqs');
  final customer_support = find.byValueKey('customer_support');
  final add_button = find.byValueKey('add_button');
  final select_add_on_products = find.text('Select Add-on Products');
  final you_will_be_charged =
      find.text('You will be charged at the time of the first shipment');
  final cancel_icon = find.byValueKey('cancel_icon');

  // update billing info
  final update_billing_info = find.text('Update Billing Info');
  final payment_radio_list_tile = find.byValueKey('payment_radio_list_tile');
  final or_text = find.text('OR');
  final payment_button_row = find.byValueKey('payment_button_row');
  final payment_button_column = find.byValueKey('payment_button_column');

  final checkout_button = find.text('CHECKOUT');
  final subscription_card_skip_shipment_link = find.text('SKIP SHIPMENT');
  final product_card_shipment_skipped_text = find.text('Shipment Skipped');

  //why do you wish to skip
  final why_do_you_wish_to_skip_label = find.text('Why do you wish to skip?');
  final submit_button = find.text('SUBMIT');
  final skip_shipment_reasons_checkbox = 'skip_reasons_checkbox_ID';

  //Shipment skipped
  final shipment_skipped_screen_check_Image =
      find.byValueKey('skip_shipment_check_image');
  final close_Icon = find.byValueKey('cancel_button');
  final shipment_skipped_label = find.text('Shipment Skipped!');
  final shipment_skipped_subtitle =
      find.byValueKey('shipment_skipped_subtitle');

  // Number of Items on My Subscription Screen
  final number_of_items_label = find.byValueKey('number_of_items');

  //Processing label
  final skip_shipment_processing_label = find.text('Processing');

  MySubscriptionScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyShipmentCardDetails(int id, List shipmentDetails) async {
    final productName = shipmentDetails[id][0];
    final bagQuantity = shipmentDetails[id][1];
    final largeBagQuantity = shipmentDetails[id][2];

    final cardParent = await find
        .byValueKey(subscription_card.replaceAll('ID', (id + 1).toString()));
    await scrollTillElementIsVisible(cardParent,
        parent_finder: products_section, dx: -5);
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: shipment_label));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: product_image));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: bag_image));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: bag_text));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: product_name));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: large_bag_image));
    await verifyElementIsDisplayed(
        await find.descendant(of: cardParent, matching: large_bag_text));

    await validate(
        await getText(
            await find.descendant(of: cardParent, matching: product_name)),
        productName);

    await validate(
        await getText(
            await find.descendant(of: cardParent, matching: bag_text)),
        bagQuantity);

    await validate(
        await getText(
            await find.descendant(of: cardParent, matching: large_bag_text)),
        largeBagQuantity);
  }

  Future<void> verifyMySubscriptionScreenIsDisplayed(
      bool isActive,
      bool isAnnual,
      List productData,
      Map paymentDetails,
      Map shippingDetails,
      List shipmentDetails) async {
    if (isActive) {
      await verifyElementIsDisplayed(products_section);
      await verifyElementIsDisplayed(await find.text(items_label.replaceAll(
          'replace_items_qty', (shipmentDetails.length).toString())));

      await validate(
          await getText(await find.descendant(
              of: subscription_type_section,
              matching: subscription_status_label)),
          'ACTIVE');

      await verifyElementIsDisplayed(cancel_subscription_button);
      await verifyElementIsDisplayed(add_button);

//      TODO: https://scotts.jira.com/browse/DMP-1034
//      for (var i = 0; i < productData.length; i++) {
//        await verifyShipmentCardDetails(i, shipmentDetails);
//      }
    } else {
      await validate(
          await getText(await find.descendant(
              of: subscription_type_section,
              matching: subscription_status_label)),
          'CANCELED');

      await verifyElementIsDisplayed(get_a_new_plan_button);
    }

    // Subscription Type section
    await verifyElementIsDisplayed(subscription_type_section);
    await verifyElementIsDisplayed(await find.descendant(
        of: subscription_type_section, matching: subscription_type_text));
    await verifyElementIsDisplayed(await find.descendant(
        of: subscription_type_section, matching: subscription_type_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: subscription_type_section, matching: subscription_status_label));
    if (isAnnual) {
      await validate(
          await getText(await find.descendant(
              of: subscription_type_section,
              matching: find.byValueKey(section_main_label))),
          'Annual Lawn Subscription Plan');
    } else {
      await validate(
          await getText(await find.descendant(
              of: subscription_type_section,
              matching: find.byValueKey(section_main_label))),
          'Seasonal Lawn Subscription Plan');
    }

    // Start section
    await verifyElementIsDisplayed(start_date_section);
    await verifyElementIsDisplayed(await find.descendant(
        of: start_date_section, matching: await find.text('Start Date')));
    await validate(
        await getText(await find.descendant(
            of: start_date_section,
            matching: find.byValueKey(section_main_label))),
        null,
        op: false);

    // End/Renew section
    await verifyElementIsDisplayed(renewal_date_section);
    await validate(
        await getText(await find.descendant(
            of: renewal_date_section,
            matching: find.byValueKey(section_main_label))),
        null,
        op: false);

    await verifyElementIsDisplayed(back_button);
    await validate(await getText(header_title), 'My Subscription');

    if (isAnnual) {
      // Billing section
      await verifyElementIsDisplayed(billing_info_section);
      await verifyElementIsDisplayed(await find.descendant(
          of: billing_info_section, matching: billing_info_text));
      await verifyElementIsDisplayed(await find.descendant(
          of: billing_info_section, matching: billing_info_card_image));
      await verifyElementIsDisplayed(await find.descendant(
          of: billing_info_section, matching: billing_info_card_number));
      await verifyElementIsDisplayed(await find.descendant(
          of: billing_info_section, matching: billing_info_navigate_to_icon));
      assert(await getText(await find.descendant(
              of: billing_info_section, matching: billing_info_card_number)) ==
          paymentDetails['masked_card_number']);
    }

    // Shipping section
    await scrollTillElementIsVisible(shipping_address_section, dy: 5);
    await verifyElementIsDisplayed(shipping_address_section);
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_address_section, matching: shipping_info_text));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_address_section, matching: shipping_info_address));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_address_section,
        matching: shipping_info_i_have_moved_text));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_address_section,
        matching: shipping_info_i_have_moved_icon));
    await validate(
        await getText(await find.descendant(
            of: shipping_address_section,
            matching: shipping_info_i_have_moved_text)),
        null,
        op: false);
  }

  Future<void> clickOnCancelSubscriptionButton() async {
    await scrollTillElementIsVisible(cancel_subscription_button,
        parent_finder: my_subscription_parent, dy: 50);
    await clickOn(cancel_subscription_button);
  }

  Future<void> clickOnGetANewPlanButton() async {
    await scrollTillElementIsVisible(get_a_new_plan_button, dy: 5);
    await clickOn(get_a_new_plan_button);
  }

  Future<void> clickOnFAQ() async {
    await scrollTillElementIsVisible(faq,
        parent_finder: my_subscription_parent, dy: -50, timeoutVal: 1000);
    await clickOn(faq);
  }

  Future<void> clickOnCustomerSupport() async {
    await scrollTillElementIsVisible(customer_support,
        parent_finder: my_subscription_parent, dy: -50, timeoutVal: 1000);
    await clickOn(customer_support);
  }

  Future<void> clicOnAddButton() async {
    await clickOn(add_button);
  }

  Future<void> verifyAddOnProduct() async {
    await verifyElementIsDisplayed(select_add_on_products);
    await verifyElementIsDisplayed(you_will_be_charged);
    await verifyElementIsDisplayed(cancel_icon);
  }

  Future<void> clicOnCancelIcon() async {
    await clickOn(cancel_icon);
  }

  Future<void> clickOnBillingInfo() async {
    final subscribe_now_button_coordinates =
        await driver.getCenter(billing_info_section);
    await scrollElement(screen_parent,
        dy: (0 - subscribe_now_button_coordinates.dy) * 0.3, timeout: 1000);
    await clickOn(billing_info_section);
  }

  Future<void> verifyUpdateBilling() async {
    await verifyElementIsDisplayed(update_billing_info);
    await verifyElementIsDisplayed(payment_radio_list_tile);
    await verifyElementIsDisplayed(or_text);
    await verifyElementIsDisplayed(payment_button_column);
  }

  Future<void> scrollTillEnd() async {
    await scrollElement(screen_parent, dy: -640);
  }

  Future<void> clickOnCheckout() async {
    await clickOn(checkout_button);
  }

  Future<dynamic> clickOnSkipShipment() async {
    await scrollTillElementIsVisible(products_section);
    final productDetails = await getSkipShipmentProductNameAndID();
    await clickOn(await find.descendant(
        of: await find.byValueKey(
            subscription_card.replaceAll('ID', (productDetails[1]).toString())),
        matching: subscription_card_skip_shipment_link,
        firstMatchOnly: true));
    return productDetails[0];
  }

  Future<void> verifyElementsOnSkipShipmentScreen(
      Map skipShipmentReasons) async {
    await verifyElementIsDisplayed(why_do_you_wish_to_skip_label);
    await verifyElementIsDisplayed(cancel_button);
    for (var i = 0; i < skipShipmentReasons.length; i++) {
      await verifyElementIsDisplayed(find.byValueKey(
          skip_shipment_reasons_checkbox.replaceAll('ID', (i + 1).toString())));
      await verifyElementIsDisplayed(
          find.text(skipShipmentReasons['reason_' + (i + 1).toString()]));
    }
    await verifyElementIsDisplayed(submit_button);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_button);
  }

  Future<void> clickOnSubmitButton() async {
    await clickOn(submit_button);
  }

  Future<void> clickOnSkipShipmentReason(
      String reason, Map skipShipmentReasons) async {
    var element;
    switch (reason) {
      case 'reason_1':
        element = find.text(skipShipmentReasons[reason]);
        break;
      case 'reason_2':
        element = find.text(skipShipmentReasons[reason]);
        break;
      case 'reason_3':
        element = find.text(skipShipmentReasons[reason]);
        break;
      case 'reason_4':
        element = find.text(skipShipmentReasons[reason]);
        break;
      case 'reason_5':
        element = find.text(skipShipmentReasons[reason]);
        break;
      default:
        throw Exception('Bad reason : $reason');
        break;
    }

    await clickOn(element);
  }

  Future<void> verifyShipmentSkippedScreenElements() async {
    await verifyElementIsDisplayed(shipment_skipped_screen_check_Image);
    await verifyElementIsDisplayed(close_Icon);
    await verifyElementIsDisplayed(shipment_skipped_label);
    await verifyElementIsDisplayed(shipment_skipped_subtitle);
  }

  Future<String> getShipmentSkippedSubtitle() async =>
      getText(shipment_skipped_subtitle);

  Future<dynamic> getCalculatedRefundAmount(
      bool isAnnual,
      List subscriptionCardProductDetails,
      List addOnProductDetails,
      String productName,
      var tax,
      var annualDiscount) async {
    var refundedAmt;
    final mod = pow(10.0, 2);
    for (var i = 0; i < subscriptionCardProductDetails.length; i++) {
      if (subscriptionCardProductDetails[i][0] == productName) {
        final productAmt = double.parse(
            subscriptionCardProductDetails[i][4].replaceAll('\$', ''));
        if (isAnnual) {
          if (annualDiscount != null && annualDiscount > 0) {
            final discountedAmt =
                productAmt - ((productAmt * annualDiscount) / 100);
            final taxedAmt = discountedAmt + ((discountedAmt * tax) / 100);
            refundedAmt = ((taxedAmt * mod).round().toDouble() / mod);
          } else {
            final taxedAmt = productAmt + ((productAmt * tax) / 100);
            refundedAmt = ((taxedAmt * mod).round().toDouble() / mod);
          }
        } else {
          final taxedAmt = productAmt + ((productAmt * tax) / 100);
          refundedAmt = ((taxedAmt * mod).round().toDouble() / mod);
        }
        break;
      }
    }
    if (refundedAmt == null) {
      for (var i = 0; i < addOnProductDetails.length; i++) {
        final productAmt =
            double.parse(addOnProductDetails[i][1].replaceAll('\$', ''));
        if (addOnProductDetails[i][0] == productName) {
          final taxedAmt = productAmt + ((productAmt * tax) / 100);
          refundedAmt = ((taxedAmt * mod).round().toDouble() / mod);
        }
      }
    }
    return refundedAmt;
  }

  Future<dynamic> getSkipShipmentProductNameAndID() async {
    await scrollTillElementIsVisible(products_section);
//get number of items on My Subscription Screen
    final numberOfItems =
        (await getText(number_of_items_label)).substring(0, 1);
    final productDetails = List(2);

//iterate over items on my subscription screen to get name of first product having skip shipment link
    for (var i = 0; i < int.parse(numberOfItems); i++) {
      final cardParent = await find
          .byValueKey(subscription_card.replaceAll('ID', (i + 1).toString()));
      try {
        await scrollTillElementIsVisible(cardParent,
            parent_finder: products_section, dx: -5);
        await verifyElementIsDisplayed(await find.descendant(
            of: cardParent, matching: subscription_card_skip_shipment_link));
        productDetails[0] = await getText(
            await find.descendant(of: cardParent, matching: product_name));
        productDetails[1] = i + 1;
        break;
      } catch (e) {
        if (i == int.parse(numberOfItems) - 1) {
          throw Exception(
              'Skip Shipment link not found. Either all products were Shipped or Skipped');
        } else {
          continue;
        }
      }
    }
    return productDetails;
  }

  Future<void> goToProfileScreen() async {
    await goToBack();
  }

  Future<void> clickOnCloseIcon() async {
    await clickOn(close_Icon);
  }

  Future<void> verifySkipShipmentProcessingLabel() async {
    await verifyElementIsDisplayed(skip_shipment_processing_label);
  }

  Future<void> verifyProductInShipmentProductList(var productName) async
  {
    await scrollTillElementIsVisible(products_section);
//get number of items on My Subscription Screen
    final numberOfItems =
    (await getText(number_of_items_label)).substring(0, 1);

    //iterate over items on my subscription screen to get name of first product having skip shipment link
    for (var i = 0; i < int.parse(numberOfItems); i++) {
      final cardParent = await find
          .byValueKey(subscription_card.replaceAll('ID', (i + 1).toString()));
      try {
        await scrollTillElementIsVisible(cardParent,
            parent_finder: products_section, dx: -5);
        final actualProductName = await getText(
            await find.descendant(of: cardParent, matching: product_name));
        await validate(actualProductName, productName);
        break;
      } catch (e) {
        if (i == int.parse(numberOfItems) - 1) {
          throw Exception(
              'Expected product $productName not found in the shipment product list');
        } else {
          continue;
        }
      }
    }
  }

  Future<void> verifyProductShipmentSkippedText(var productName) async
  {
    await scrollTillElementIsVisible(products_section);
//get number of items on My Subscription Screen
    final numberOfItems =
    (await getText(number_of_items_label)).substring(0, 1);

    //iterate over items on my subscription screen to get name of first product having skip shipment link
    for (var i = 0; i < int.parse(numberOfItems); i++) {
      final cardParent = await find
          .byValueKey(subscription_card.replaceAll('ID', (i + 1).toString()));
      try {
        await scrollTillElementIsVisible(cardParent,
            parent_finder: products_section, dx: -5);
        final actualProductName = await getText(
            await find.descendant(of: cardParent, matching: product_name));
        await validate(actualProductName, productName);
        await verifyElementIsDisplayed(find.descendant(of: cardParent, matching: product_card_shipment_skipped_text));
        break;
      } catch (e) {
        if (i == int.parse(numberOfItems) - 1) {
          throw Exception(
              'Expected product $productName not found in the shipment product list');
        } else {
          continue;
        }
      }
    }
  }



}
