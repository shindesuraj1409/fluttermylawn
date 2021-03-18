import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class LawnProfileAdobeState extends AdobeAnalyticState {
  LawnProfileAdobeState()
      : super(type: 'LawnProfileAdobeState', state: 'lawn profile');

  @override
  Map<String, String> getData() {
    return {'s.type': 'account'};
  }
}

class EditLawnProfileAdobeState extends AdobeAnalyticState {
  EditLawnProfileAdobeState()
      : super(type: 'EditLawnProfileAdobeState', state: 'edit lawn profile');

  @override
  Map<String, String> getData() {
    return {'s.type': 'account'};
  }
}
