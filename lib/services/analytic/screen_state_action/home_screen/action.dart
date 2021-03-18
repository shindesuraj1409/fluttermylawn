import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class HomeScreenProductSkippedWhyAdobeAction extends AdobeAnalyticAction {
  final String skipReason;
  final String products;

  HomeScreenProductSkippedWhyAdobeAction({
    this.products,
    this.skipReason,
  }) : super(type: 'HomeScreenProductSkippedWhyAdobeAction', action: 'product skipped');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'lawncareplan',
      's.skipReason': skipReason,
      '&&products': ';$products',
    };
  }
}

class HomeScreenProductAppliedAdobeAction extends AdobeAnalyticAction {

  HomeScreenProductAppliedAdobeAction() : super(type: 'HomeScreenProductAppliedAdobeAction', action: 'home');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'lawncareplan',
    };
  }
}