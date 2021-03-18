import 'package:my_lawn/services/analytic/actions/appsflyer/appsflyer_event.dart';

class ProductAppliedAppsFlyer extends AppsFlyerEvent {
  ProductAppliedAppsFlyer(this.sku);

  final String sku;

  @override
  String get eventName => 'Product Applied';

  @override
  Map<String, String> get args => {
        'sku': sku,
      };
}

class ProductSkippedAppsFlyer extends AppsFlyerEvent {
  ProductSkippedAppsFlyer(this.sku);

  final String sku;

  @override
  String get eventName => 'Product Skipped';

  @override
  Map<String, String> get args => {
        'sku': sku,
      };
}
