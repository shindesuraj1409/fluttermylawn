import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class MyScottsAccountScreenAdobeState extends AdobeAnalyticState {

  MyScottsAccountScreenAdobeState() : super(type: 'MyScottsAccountScreenAdobeState', state: 'overview');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}

class OrderHistoryScreenAdobeState extends AdobeAnalyticState {

  OrderHistoryScreenAdobeState() : super(type: 'OrderHistoryScreenAdobeState', state: 'order history');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}
