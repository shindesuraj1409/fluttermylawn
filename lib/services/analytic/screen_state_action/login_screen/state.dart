import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class EmailLoginScreenAdobeState extends AdobeAnalyticState {

  EmailLoginScreenAdobeState() : super(type: 'EmailLoginScreenAdobeState', state: 'login|email');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}

class WelcomeBackScreenAdobeState extends AdobeAnalyticState {

  WelcomeBackScreenAdobeState() : super(type: 'WelcomeBackScreenAdobeState', state: 'login|welcome back');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}

class FamiliarEmailScreenAdobeState extends AdobeAnalyticState {

  FamiliarEmailScreenAdobeState() : super(type: 'FamiliarEmailScreenAdobeState', state: 'login|social link');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}