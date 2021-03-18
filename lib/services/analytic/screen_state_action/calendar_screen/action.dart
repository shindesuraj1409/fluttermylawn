import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class TaskAddedScreenAdobeAction extends AdobeAnalyticAction {
  String taskType;

  TaskAddedScreenAdobeAction({
    this.taskType,
  }) : super(type: 'TaskAddedScreenAdobeAction', action: 'task added|$taskType');

  @override
  Map<String, String> getData() {
    return {
      's.taskType': taskType,
      's.type': 'calendar'
    };
  }
}

class ProductAddedScreenAdobeAction extends AdobeAnalyticAction {
  String productId;

  ProductAddedScreenAdobeAction({
    this.productId,
  }) : super(type: 'ProductAddedScreenAdobeAction', action: 'product added');

  @override
  Map<String, String> getData() {
    return {
      '&&products': ';$productId',
      's.type': 'calendar'
    };
  }
}