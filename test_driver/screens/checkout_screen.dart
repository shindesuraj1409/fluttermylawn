import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class CheckoutScreen extends BaseScreen {
  final check_out_screen_parent = find.byType('CustomScrollView');
  // shipping tile
  final shipping_tile_label = find.text('Shipping');
  final shipping_zip_code_label = find.byValueKey('zip_code_label');
  final shipping_expand_icon = find.byValueKey('shipping_expand');
  final shipping_collapse_icon = find.byValueKey('shipping_collapse');
  final shipping_first_name = find.byValueKey('first_name_input');
  final shipping_last_name = find.byValueKey('last_name_input');
  final shipping_street_address = find.byValueKey('street_address_input');
  final shipping_apartment_suite_other__optional =
      find.byValueKey('apartment_suite_other__optional__input');
  final shipping_city = find.byValueKey('city_input');
  final shipping_state = find.byValueKey('state_input');
  final shipping_zip_code = find.byValueKey('zip_code_input');
  final shipping_phone_number = find.byValueKey('phone_number_input');
  final shipping_continue_to_payment_button = find.text('CONTINUE TO PAYMENT');

  // payment tile
  final payment_tile_label = find.text('Payment');
  final payment_expand_icon = find.byValueKey('payment_expand');
  final payment_collapse_icon = find.byValueKey('payment_collapse');
  final credit_card_image = find.byValueKey('credit_card_image');
  final payment_method_label = find.text('Choose payment method');
  final master_card_image = find.byValueKey('master_card_image');
  final visa_card_image = find.byValueKey('visa_card_image');
  final credit_card_label = find.text('Credit Card');

  final card_number = find.byValueKey('card_number_input');
  final expiration_date = find.byValueKey('expiration_date_input');
  final cvv = find.byValueKey('cvv_input');

  final visa_image = find.byValueKey('visa_image');
  final ms_image = find.byValueKey('master_card_image');
  final amex_image = find.byValueKey('amex_image');

  final billing_address_label = find.text('Billing Address');
  final same_as_shipping_address_label = find.text('Same as Shipping Address');
  final same_as_shipping_address_toggle =
      find.byValueKey('same_as_shipping_address');

  final payment_continue_to_order_summary_button =
      find.text('CONTINUE TO ORDER SUMMARY');

  // order summary
  final order_summary_tile_label = find.descendant(
      of: find.byType('ExpansionTile'), matching: find.text('Order Summary'));
  var order_summary_tile_total_label = 'Total: replace_value';
  final order_summary_expand = find.byValueKey('order_summary_expand');
  final order_summary_collapse = find.byValueKey('order_summary_collapse');
  final order_summary_annual_subscription_label =
      find.text('Annual Subscription');
  final order_summary_seasonal_subscription_label =
      find.text('Seasonal Subscription');
  final order_summary_annual_subscription_value =
      find.byValueKey('annual_subscription_value');
  final order_summary_seasonal_subscription_value =
      find.byValueKey('seasonal_subscription_value');
  final order_summary_promo_discount_label =
      find.text('Promo Code: Annual Discount');
  final order_summary_promo_discount_value =
      find.byValueKey('promo_code__annual_discount_value');
  final order_summary_subtotal_label = find.text('Subtotal');
  final order_summary_subtotal_value = find.byValueKey('subtotal_value');
  final order_summary_shipping_label = find.text('Shipping');
  final order_summary_shipping_value = find.byValueKey('shipping_value');
  final order_summary_tax_label = find.text('Tax');
  final order_summary_tax_value = find.byValueKey('tax_value');
  final order_summary_total_label = find.text('Total');
  final order_summary_total_value = find.byValueKey('total_value');
  final order_summary_checkbox = find.byValueKey('order_summary_checkbox');
  final order_summary_confirmation_label = find.text(
      'By checking this box you confirm that your subscription will automatically renew on an annual basis and you will continue to receive new shipments as outlined in your Scotts Program Lawn Plan unless you tell us to stop and your credit card on file will be automatically charged for your entire plan as outlined in your account on the date of renewal. You will be notified by email at the address provided between 30-60 days days prior to each charge. You may cancel your subscription at any time through our website program.scotts.com. To avoid the next charge you must cancel your subscription by the date indicated in the notice.');

  final order_summary_place_order_button = find.text('PLACE ORDER');

  final order_processing_image = find.byValueKey('order_processing_image');
  final order_processing_label = find.text('Processing Your Order');

  final checkout_button = find.text('CHECKOUT');

  CheckoutScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyCheckoutShippingElementsAreDisplayed(
      bool isExpanded) async {
    await verifyElementIsDisplayed(back_button);
    await validate(await getText(header_title), 'Checkout');

    final shipping_tile_parent = await find.ancestor(
        of: await find.text('Shipping'),
        matching: await find.byType('ExpansionTile'));

    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_tile_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_zip_code_label));

    if (isExpanded) {
      await verifyElementIsDisplayed(await find.descendant(
          of: shipping_tile_parent, matching: shipping_expand_icon));
    } else {
      await verifyElementIsDisplayed(await find.descendant(
          of: shipping_tile_parent, matching: shipping_collapse_icon));
      await clickOn(await find.descendant(
          of: shipping_tile_parent, matching: shipping_collapse_icon));
    }

    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_first_name));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_last_name));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_street_address));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent,
        matching: shipping_apartment_suite_other__optional));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_city));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_state));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_phone_number));
    await verifyElementIsDisplayed(await find.descendant(
        of: shipping_tile_parent, matching: shipping_zip_code));
  }

  Future<void> fillCheckoutShippingDetails(
      bool isExpanded, Map shippingData) async {
    final shipping_tile_parent = await find.ancestor(
        of: await find.text('Shipping'),
        matching: await find.byType('ExpansionTile'));

    if (!isExpanded) {
      await verifyElementIsDisplayed(await find.descendant(
          of: shipping_tile_parent, matching: shipping_expand_icon));
      await clickOn(await find.descendant(
          of: shipping_tile_parent, matching: shipping_expand_icon));
    }

    await validate(
        await getText(await find.descendant(
            of: shipping_tile_parent, matching: shipping_zip_code_label)),
        shippingData['shipping_zip_code']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_first_name),
        shippingData['shipping_first_name']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_last_name),
        shippingData['shipping_last_name']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_street_address),
        shippingData['shipping_street_address']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent,
            matching: shipping_apartment_suite_other__optional),
        shippingData['shipping_apartment_suite_other__optional']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_city),
        shippingData['shipping_city']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_state),
        shippingData['shipping_state']);
    await typeIn(
        await find.descendant(
            of: shipping_tile_parent, matching: shipping_phone_number),
        shippingData['shipping_phone_number']);
  }

  Future<void> clickContinueToPayment() async {
    final shipping_tile_parent = await find.ancestor(
        of: await find.text('Shipping'),
        matching: await find.byType('ExpansionTile'));
    await scrollTillElementIsVisible(shipping_continue_to_payment_button);
    await clickOn(await find.descendant(
        of: shipping_tile_parent,
        matching: shipping_continue_to_payment_button));
  }

  Future<void> verifyPaymentDetails(bool isExpanded) async {
    final payment_tile_parent = await find.ancestor(
        of: await find.text('Payment'),
        matching: await find.byType('ExpansionTile'));

    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: payment_tile_label));

    if (isExpanded) {
      await verifyElementIsDisplayed(await find.descendant(
          of: payment_tile_parent, matching: payment_expand_icon));
    } else {
      await verifyElementIsDisplayed(await find.descendant(
          of: payment_tile_parent, matching: payment_collapse_icon));
    }

    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: payment_method_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: master_card_image));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: visa_card_image));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: credit_card_label));
  }

  Future<void> fillPaymentDetails(bool isExpanded, Map paymentDetails) async {
    final payment_tile_parent = await find.ancestor(
        of: await find.text('Payment'),
        matching: await find.byType('ExpansionTile'));

    if (!isExpanded) {
      await clickOn(await find.descendant(
          of: payment_tile_parent, matching: payment_expand_icon));
    }

    await clickOn(await find.descendant(
        of: payment_tile_parent, matching: credit_card_label));
    await verifyCreditCardElementsAreDisplayed();

    await typeIn(
        await find.descendant(of: payment_tile_parent, matching: card_number),
        paymentDetails['card_number']);
    await typeIn(
        await find.descendant(
            of: payment_tile_parent, matching: expiration_date),
        paymentDetails['expiration_date']);
    await typeIn(await find.descendant(of: payment_tile_parent, matching: cvv),
        paymentDetails['cvv']);

    switch (paymentDetails['card_type']) {
      case 'visa':
        await verifyElementIsDisplayed(await find.descendant(
            of: payment_tile_parent, matching: visa_image));
        break;
      case 'amex':
        await verifyElementIsDisplayed(await find.descendant(
            of: payment_tile_parent, matching: amex_image));
        break;
      case 'ms':
        await verifyElementIsDisplayed(await find.descendant(
            of: payment_tile_parent, matching: master_card_image));
        break;
    }
  }

  Future<void> verifyCreditCardElementsAreDisplayed() async {
    final payment_tile_parent = await find.ancestor(
        of: await find.text('Payment'),
        matching: await find.byType('ExpansionTile'));

    await verifyElementIsDisplayed(
        await find.descendant(of: payment_tile_parent, matching: card_number));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: expiration_date));
    await verifyElementIsDisplayed(
        await find.descendant(of: payment_tile_parent, matching: cvv));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: billing_address_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: same_as_shipping_address_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: same_as_shipping_address_toggle));
    await verifyElementIsDisplayed(await find.descendant(
        of: payment_tile_parent, matching: credit_card_image));
  }

  Future<void> clickOnContinueToOrderSummary() async {
    final payment_tile_parent = await find.ancestor(
        of: await find.text('Payment'),
        matching: await find.byType('ExpansionTile'));

    await clickOn(await find.descendant(
        of: payment_tile_parent,
        matching: payment_continue_to_order_summary_button));
  }

  Future<void> verifyOrderSummaryDetails(
      bool isExpanded,
      bool isAnnualSubscription,
      String value,
      String discount,
      String subtotal,
      String shipping,
      String tax,
      String total) async {
    final order_summary_tile_parent = await find.ancestor(
        of: await find.text('Order Summary'),
        matching: await find.byType('ExpansionTile'));

    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_tile_label));

    await scrollTillElementIsVisible(
        find.ancestor(
            of: await find.text('Order Summary'),
            matching: await find.byType('ExpansionTile')),
        dy: 5);

    if (isExpanded) {
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent, matching: order_summary_expand));
    } else {
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent, matching: order_summary_collapse));
      await clickOn(await find.descendant(
          of: order_summary_tile_parent, matching: order_summary_collapse));
    }

    if (isAnnualSubscription) {
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_annual_subscription_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_annual_subscription_value));
      await validate(
          await getText(await find.descendant(
              of: order_summary_tile_parent,
              matching: order_summary_annual_subscription_value)),
          value);

      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_promo_discount_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_promo_discount_value));
      await validate(
          await getText(await find.descendant(
              of: order_summary_tile_parent,
              matching: order_summary_promo_discount_value)),
          discount);
    } else {
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_seasonal_subscription_label));
      await verifyElementIsDisplayed(await find.descendant(
          of: order_summary_tile_parent,
          matching: order_summary_seasonal_subscription_value));
      await validate(
          await getText(await find.descendant(
              of: order_summary_tile_parent,
              matching: order_summary_seasonal_subscription_value)),
          value);
      if (discount.isNotEmpty) {
        await verifyElementIsDisplayed(await find.descendant(
            of: order_summary_tile_parent,
            matching: await find.text(discount)));
      }
    }

    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_subtotal_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_subtotal_value));
    await validate(
        await getText(await find.descendant(
            of: order_summary_tile_parent,
            matching: order_summary_subtotal_value)),
        subtotal);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_shipping_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_shipping_value));
    await validate(
        await getText(await find.descendant(
            of: order_summary_tile_parent,
            matching: order_summary_shipping_value)),
        shipping);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_tax_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_tax_value));
    await validate(
        await getText(await find.descendant(
            of: order_summary_tile_parent, matching: order_summary_tax_value)),
        tax);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_total_label));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_total_value));
    await validate(
        await getText(await find.descendant(
            of: order_summary_tile_parent,
            matching: order_summary_total_value)),
        total);
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_checkbox));
    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent,
        matching: order_summary_confirmation_label));
    await verifyElementIsDisplayed(order_summary_place_order_button);

    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent,
        matching: await find.text(order_summary_tile_total_label.replaceAll(
            'replace_value', subtotal))));
  }

  Future<void> verifyAddonInOrderSummary(String addonName, String price) async {
    final order_summary_tile_parent = await find.ancestor(
        of: await find.text('Order Summary'),
        matching: await find.byType('ExpansionTile'));

    final actualPrice = await getText(await find.descendant(
        of: order_summary_tile_parent,
        matching: await find.byValueKey(
            addonName.toLowerCase().replaceAll(RegExp(r'[^\w]'), '_') +
                '_value')));

    await validate(actualPrice, price);

    await verifyElementIsDisplayed(await find.descendant(
        of: order_summary_tile_parent, matching: await find.text(addonName)));
  }

  Future<void> acceptSubscriptionConfirmation() async {
    final order_summary_tile_parent = await find.ancestor(
        of: await find.text('Order Summary'),
        matching: await find.byType('ExpansionTile'));

    await scrollTillElementIsVisible(order_summary_checkbox,
        parent_finder: order_summary_tile_parent, dx: 5);

    await clickOn(await find.descendant(
        of: order_summary_tile_parent, matching: order_summary_checkbox));
  }

  Future<void> clickOnPlaceOrder() async {
    await scrollTillElementIsVisible(order_summary_checkbox, dx: 5);
    await clickOn(order_summary_place_order_button);
  }
}
