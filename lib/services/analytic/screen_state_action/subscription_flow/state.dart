import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class SubscriptionOptionScreenAdobeState extends AdobeAnalyticState {

  SubscriptionOptionScreenAdobeState()
      : super(type: 'SubscriptionOptionScreenAdobeState', state: 'subscription options');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'checkout'
    };
  }
}

class YourCartScreenAdobeState extends AdobeAnalyticState {

  YourCartScreenAdobeState()
      : super(type: 'YourCartScreenAdobeState', state: 'cart');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'checkout'
    };
  }
}

class AddPromoCodeScreenAdobeState extends AdobeAnalyticState {
  final String promoCode;

  AddPromoCodeScreenAdobeState({this.promoCode,})
      : super(type: 'AddPromoCodeScreenAdobeState', state: 'checkout|promo code');

  @override
  Map<String, String> getData() {
    return {
      's.promocode': promoCode,
      's.type': 'checkout'
    };
  }
}

class OrderProcessingScreenAdobeState extends AdobeAnalyticState {

  OrderProcessingScreenAdobeState()
      : super(type: 'OrderProcessingScreenAdobeState', state: 'order processing');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'checkout'
    };
  }
}