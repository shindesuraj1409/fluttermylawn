import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class PDPScreenAdobeState extends AdobeAnalyticState {
  final String productName;
  final String productId;

  PDPScreenAdobeState({this.productName, this.productId}) : super(type: 'PDPScreenAdobeState', state: productName);

  @override
  Map<String, String> getData() {
    return {
      '&&products': ';$productId',
      '&&events': 'prodView',
      's.type': 'product'
    };
  }
}

class BuyOnlineAdobeState extends AdobeAnalyticState {

  BuyOnlineAdobeState() : super(type: 'BuyOnlineAdobeState', state: 'buyonline');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'product'
    };
  }
}

class StoreLocatorScreenAdobeState extends AdobeAnalyticState {
  final String zipCode;

  StoreLocatorScreenAdobeState({this.zipCode,}) : super(type: 'StoreLocatorScreenAdobeState', state: 'where to buy',);

  @override
  Map<String, String> getData() {
    return {
      's.storeLocatorSearch': zipCode,
      's.type': 'product'
    };
  }
}