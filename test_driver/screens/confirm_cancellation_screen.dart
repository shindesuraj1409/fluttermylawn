import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class ConfirmCancellationScreen extends BaseScreen {
  final close_icon = find.byValueKey('close_icon');
  final cancel_subtext =
      find.text('By canceling your subscription, the following will happen:');
  var refund_text = 'You will be refunded \$replace_amount for the products:';
  var refund_product_label = 'replace_product_name, QTY: replace_product_qty';
  final refund_duration_text = find.text(
      'The refund will appear in your original payment method within 7 days.');
  final no_billed_text = find.text('You will no longer be billed.');
  final no_receive_shipments =
      find.text('You will no longer receive product shipments.');
  final online_scotts_account_text =
      find.text('You will still have an online account with Scotts.');

  final phone_image = find.byValueKey('phone_image');
  final phone_number = find.text('1-877-220-3091');
  final mail_image = find.byValueKey('mail_image');
  final mail = find.text('orders@scotts.com');

  final continue_button = find.text('CONTINUE');

  ConfirmCancellationScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyConfirmCancellationScreenIsDisplayed(
      bool isAnnual, String amount, List productData) async {
    await verifyElementIsDisplayed(cancel_subtext);

    if (isAnnual) {
//    TODO: Rich Text
//    await verifyElementIsDisplayed(await find.text('You will be refunded '));
//    await verifyElementIsDisplayed(await find.text('for the products:'));
//    await verifyElementIsDisplayed(await find.text('\$$amount'));

//    TODO: https://scotts.jira.com/browse/DTI-607
//    for (var i = 0; i < productData.length; i++) {
//      await verifyElementIsDisplayed(await find.text(refund_product_label
//          .replaceAll('replace_product_name', productData[i][0])
//          .replaceAll('replace_product_qty',
//              (productData[i][2]).toString().replaceAll('×', ''))));
//    }

      await verifyElementIsDisplayed(refund_duration_text);
    }

    await verifyElementIsDisplayed(no_billed_text);
    await verifyElementIsDisplayed(no_receive_shipments);
    await verifyElementIsDisplayed(online_scotts_account_text);
    await verifyElementIsDisplayed(phone_image);
    await verifyElementIsDisplayed(phone_number);
    await verifyElementIsDisplayed(mail_image);
    await verifyElementIsDisplayed(mail);
    await verifyElementIsDisplayed(close_icon);
    await validate(await getText(header_title), 'Confirm Cancelation');
    await verifyElementIsDisplayed(continue_button);
  }

  Future<void> clickOnContinueButton() async {
    await scrollTillElementIsVisible(continue_button, dy: 5);
    await clickOn(continue_button);
  }

  Future<void> verifyProcessingCancellationScreen() async {
    await verifyElementIsDisplayed(await find.text('HANG TIGHT'));
    await verifyElementIsDisplayed(await find.text('Processing cancelation'));
  }

  Future<void> verifyCancelationDoneScreen() async {
    await verifyElementIsDisplayed(await find.text('YOU ARE ALL SET'));
    await verifyElementIsDisplayed(
        await find.text('Your Subscription Is Canceled.'));
  }
}
