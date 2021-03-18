import 'package:my_lawn/data/analytics/analytic_action_model.dart';
import 'package:my_lawn/data/analytics/analytic_state_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

import '../stub/stub.dart';

class StubAdobeRepository implements AdobeRepository{
  @override
  AnalyticActionModel buildAnalyticActionData(AdobeAnalyticAction action) {
    addNewEntry('buildAnalyticActionData',value: action.action);
    return null;
  }

  @override
  AnalyticStateModel buildAnalyticStateData(AdobeAnalyticState state) {
    addNewEntry('buildAnalyticStateData');
    return null;
  }

  @override
  String buildProductString(List list, {bool parentSku = false, bool sku = false, bool quantity = false, bool price = false}) {
    addNewEntry('buildProductString');
    return '';
  }

  @override
  String buildProductsFromShipmentProductString(List product) {
    addNewEntry('buildProductsFromShipmentProductString');
    return '';
  }

  @override
  String buildSingleProductFromShipmentProductString(product) {
    addNewEntry('buildSingleProductFromShipmentProductString');
    return '';
  }

  @override
  String buildSingleProductString(product, {bool parentSku = false, bool sku = false, bool quantity = false, bool price = false}) {
    addNewEntry('buildSingleProductString');
    return '';
  }

  @override
  String countRevenue({int quan, String price}) {
    addNewEntry('countRevenue');
    return '';
  }

  @override
  void getSDKVersion() {
    addNewEntry('getSDKVersion');
  }

  @override
  void setACPCoreLogLevel() {
    addNewEntry('setACPCoreLogLevel');
  }

  @override
  void trackAppActions(AdobeAnalyticAction action) {
    addNewEntry('trackAppActions', value: action.type.toString());
  }

  @override
  void trackAppState(AdobeAnalyticState state) {
    addNewEntry('trackAppState', value: state.type.toString());
  }
}