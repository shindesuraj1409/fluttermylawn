import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class ConfirmationScreenAdobeState extends AdobeAnalyticState {
  final String products;
  final String purchaseId;
  final String purchase;

  ConfirmationScreenAdobeState({
    this.products,
    this.purchaseId,
    this.purchase
  }) : super(type: 'ConfirmationScreenAdobeState', state: 'order');

  @override
  Map<String, String> getData() {
    return {
      '&&products': products,
      '&&events': 'purchase',
      'm.purchaseid': purchaseId,
      'm.purchase': purchase,
      's.type': 'checkout'
    };
  }
}

class CheckoutScreenAdobeState extends AdobeAnalyticState {
  final String promoCode;

  CheckoutScreenAdobeState({
    this.promoCode,
  }) : super(type: 'CheckoutScreenAdobeState', state: 'order');

  @override
  Map<String, String> getData() {
    return {
      's.promocode': promoCode,
      's.type': 'checkout'
    };
  }
}

class PaymentScreenAdobeState extends AdobeAnalyticState {
  final String promoCode;

  PaymentScreenAdobeState({
    this.promoCode,
  }) : super(type: 'PaymentScreenAdobeState', state: 'payment');

  @override
  Map<String, String> getData() {
    return {
      's.promocode': promoCode,
      's.type': 'checkout'
    };
  }
}