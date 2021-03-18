import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class AddToCartAdobeAnalyticAction extends AdobeAnalyticAction {
  final String product;

  AddToCartAdobeAnalyticAction({this.product,})
      : super(type: 'AddToCartAdobeAnalyticAction', action: 'add to cart');

  @override
  Map<String, String> getData() {
    return {
      '&&products': product,
      '&&events': '<cartAdd>'
    };
  }
}