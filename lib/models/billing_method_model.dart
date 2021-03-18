import 'package:my_lawn/screens/checkout/widgets/payment_subscreen_widget.dart';

class BillingMethod {
  String lastDigits;
  PaymentType paymentType;

  BillingMethod({
    this.lastDigits,
    this.paymentType,
  });
}
