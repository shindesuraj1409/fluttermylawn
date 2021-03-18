import 'package:my_lawn/services/analytic/actions/appsflyer/appsflyer_event.dart';

class CompleteCheckoutEvent extends AppsFlyerEvent {
  CompleteCheckoutEvent({this.cartValue, this.orderTotal});

  final String cartValue;
  final String orderTotal;

  @override
  String get eventName => 'Complete checkout';

  @override
  Map<String, String> get args => {
        'cartValue': cartValue,
        'orderTotal': orderTotal,
      };
}
