import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class HomeScreenAdobeState extends AdobeAnalyticState {

  HomeScreenAdobeState() : super(type: 'HomeScreenAdobeState', state: 'home');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'lawncareplan'
    };
  }
}


