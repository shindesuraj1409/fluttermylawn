import 'package:my_lawn/data/analytics/analytic_action_model.dart';
import 'package:my_lawn/data/analytics/analytic_state_model.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

abstract class AdobeRepository {
  void getSDKVersion();

  void setACPCoreLogLevel();

  void trackAppState(AdobeAnalyticState action);

  void trackAppActions(AdobeAnalyticAction action);

  AnalyticStateModel buildAnalyticStateData(AdobeAnalyticState state);

  AnalyticActionModel buildAnalyticActionData(AdobeAnalyticAction action);

  String buildSingleProductString(
    dynamic product, {
    bool parentSku = false,
    bool sku = false,
    bool quantity = false,
    bool price = false,
  });

  String buildSingleProductFromShipmentProductString(
    dynamic product,
  );

  String buildProductsFromShipmentProductString(
    List<dynamic> product,
  );

  String buildProductString(List<dynamic> list,
      {bool parentSku = false,
      bool sku = false,
      bool quantity = false,
      bool price = false});

  String countRevenue({int quan, String price});
}
