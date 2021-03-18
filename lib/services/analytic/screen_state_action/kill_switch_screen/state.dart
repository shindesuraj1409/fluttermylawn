import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class KillSwitchForceScreenAdobeState extends AdobeAnalyticState {
  KillSwitchForceScreenAdobeState() : super(type: 'KillSwitchForceScreenAdobeState', state: 'force update');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
    };
  }
}
