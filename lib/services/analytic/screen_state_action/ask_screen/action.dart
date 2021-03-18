import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class SendAskAction extends AdobeAnalyticAction {
  final String askType;

  SendAskAction(
    this.askType
  ) : super(type: 'SendAskAction', action: 'ask|$askType');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general'
    };
  }
}