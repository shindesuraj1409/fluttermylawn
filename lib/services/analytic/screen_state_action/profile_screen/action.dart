import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class LogOutAdobeAction extends AdobeAnalyticAction {

  LogOutAdobeAction() : super(type: 'LogOutAdobeAction', action: 'logout');

  @override
  Map<String, String> getData() {
    return {};
  }
}