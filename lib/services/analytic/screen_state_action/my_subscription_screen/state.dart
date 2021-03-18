import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class MySubscriptionScreenAdobeState extends AdobeAnalyticState {

  MySubscriptionScreenAdobeState()
      : super(type: 'MySubscriptionScreenAdobeState', state: 'mysubscription');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}

class CancelSubscriptionScreenAdobeState extends AdobeAnalyticState {

  CancelSubscriptionScreenAdobeState()
      : super(type: 'CancelSubscriptionScreenAdobeState', state: 'cancelsubscription');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}

class UpdateSubscriptionScreenAdobeState extends AdobeAnalyticState {
  final String recommendationId;
  final String products;

  UpdateSubscriptionScreenAdobeState({
    this.recommendationId,
    this.products
  }) : super(type: 'UpdateSubscriptionScreenAdobeState', state: 'updatesubscription');

  @override
  Map<String, String> getData() {
    return {
      's.recommendationId': recommendationId,
      '&&products': products,
      's.type': 'account',
    };
  }
}

class CancelReasonScreenAdobeState extends AdobeAnalyticState {
  List<String> cancelList;

  CancelReasonScreenAdobeState({
    this.cancelList,
  })
      : super(type: 'CancelReasonScreenAdobeState', state: 'cancel reason');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account',
      's.cancelReason': getString(cancelList),
    };
  }

  String getString(List<String> list) {
    var _list = '';

    for(var i = 0; i < list.length; i++) {
      var str = list[i];

      if(i != list.length-1) {
        str += '|';
      }

      _list += str;
    }

    return _list;
  }
}

class CancelConfirmationScreenAdobeState extends AdobeAnalyticState {
  final String cancelRefundAmount;
  final String canceledOrderId;

  CancelConfirmationScreenAdobeState({
    this.cancelRefundAmount,
    this.canceledOrderId
  }) : super(type: 'CancelConfirmationScreenAdobeState', state: 'cancel confirmation');

  @override
  Map<String, String> getData() {
    return {
      's.cancelRefundAmount': cancelRefundAmount,
      's.canceledOrderId': canceledOrderId,
      's.type': 'account',
    };
  }
}
