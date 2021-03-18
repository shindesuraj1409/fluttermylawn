import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class PDPScreenProductAppliedAdobeAction extends AdobeAnalyticAction {
  final String productName;
  final String productId;
  final String lawnCarePlanId;

  PDPScreenProductAppliedAdobeAction({
    this.productName,
    this.productId,
    this.lawnCarePlanId
  }) : super(type: 'PDPScreenProductAppliedAdobeAction', action: 'productApplied');

  @override
  Map<String, String> getData() {
    return {
      '&&products': ';$productId',
      's.productNameApplied': productName,
      's.lawnCarePlanId': lawnCarePlanId
    };
  }
}

class PDPScreenProductSkippedAdobeAction extends AdobeAnalyticAction {
  final String productName;
  final String productId;
  final String lawnCarePlanId;

  PDPScreenProductSkippedAdobeAction({
    this.productName,
    this.productId,
    this.lawnCarePlanId
  }) : super(type: 'PDPScreenProductSkippedAdobeAction', action: 'productSkipped');

  @override
  Map<String, String> getData() {
    return {
      '&&products': ';$productId',
      's.productNameApplied': productName,
      's.lawnCarePlanId': lawnCarePlanId
    };
  }
}