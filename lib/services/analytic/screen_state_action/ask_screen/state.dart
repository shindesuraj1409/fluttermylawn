import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class AskScreenAdobeState extends AdobeAnalyticState {

  AskScreenAdobeState(): super(type: 'AskScreenAdobeState', state: 'ask');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general'
    };
  }
}

class AskSubScreenAdobeState extends AdobeAnalyticState {
  final String subScreen;

  AskSubScreenAdobeState({
    this.subScreen
  }) : super(type: 'AskSubScreenAdobeState', state: 'ask|${subScreen}');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general'
    };
  }
}
