import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';
import 'package:my_lawn/data/analytics/analytic_action_model.dart';
import 'package:my_lawn/data/analytics/analytic_state_model.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_analytic_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_core_service.dart';

class AdobeRepositoryImpl implements AdobeRepository {
  static const String TAG = 'AdobeRepository';

  final AdobeAnalyticService _adobeAnalyticService;
  final AdobeCoreService _adobeCoreService;

  AdobeRepositoryImpl(
    this._adobeAnalyticService,
    this._adobeCoreService,
  );

  @override
  void getSDKVersion() {
    _adobeAnalyticService.getAdobeAnalyticExtensionVersion();
  }

  @override
  void setACPCoreLogLevel() {
    _adobeCoreService.setACPCoreLogLevel(ACPLoggingLevel.ERROR);
  }

  @override
  void trackAppState(AdobeAnalyticState action) {
    final analyticStateModel = buildAnalyticStateData(action);

    _adobeAnalyticService.trackAppState(analyticStateModel);
  }

  ///Function for serializing data and calling [trackAppActions()] function
  ///in AnalyticService
  @override
  void trackAppActions(AdobeAnalyticAction action) {
    final analyticModel = buildAnalyticActionData(action);
    _adobeAnalyticService.trackAppActions(analyticModel);
  }

  @override
  AnalyticStateModel buildAnalyticStateData(AdobeAnalyticState state) {
    final analyticStateModel = AnalyticStateModel(
        name: state.type.toString(), data: state.getData(), state: state.state);

    return analyticStateModel;
  }

  ///Function for serializing data from [AdobeAnalyticState] to [AnalyticActionModel]
  @override
  AnalyticActionModel buildAnalyticActionData(AdobeAnalyticAction action) {
    final analyticalModel = AnalyticActionModel(
        name: action.type.toString(),
        data: action.getData(),
        action: action.action);

    return analyticalModel;
  }

  @override
  String buildProductString(
    List list, {
    bool parentSku = false,
    bool sku = false,
    bool quantity = false,
    bool price = false,
  }) {
    var _result = '';

    list.cast<Product>().forEach(
      (product) {
        _result += buildSingleProductString(
          product,
          parentSku: parentSku,
          sku: sku,
          quantity: quantity,
          price: price,
        );
      },
    );

    return _result;
  }

  @override
  String buildSingleProductString(
    dynamic product, {
    bool parentSku = false,
    bool sku = false,
    bool quantity = false,
    bool price = false,
  }) {
    final prod = product as Product;
    final childProd = prod?.childProducts?.first;

    final priceString = childProd?.price == null ? '' : '${childProd?.price}';

    return ';${parentSku ? prod?.parentSku : ''};${quantity ? childProd?.quantity : ''};${price ? countRevenue(quan: childProd?.quantity, price: priceString) : ''};;evar43=${sku ? childProd?.sku : ''},';
  }

  @override
  String buildProductsFromShipmentProductString(List list) {
    var _result = '';

    list.cast<ShipmentProduct>().forEach((product) {
      _result += buildSingleProductFromShipmentProductString(
        product,
      );
    });

    return _result;
  }

  @override
  String buildSingleProductFromShipmentProductString(dynamic product) {
    final prod = product as ShipmentProduct;
    return ';${prod?.sku};${prod?.qty};${countRevenue(quan: prod?.qty, price: prod?.price)};;evar43=${prod?.productId},';
  }

  @override
  String countRevenue({int quan, String price}) {
    if (quan == null || price == null) {
      return '';
    }
    return (quan * double.parse(price)).toString();
  }
}
