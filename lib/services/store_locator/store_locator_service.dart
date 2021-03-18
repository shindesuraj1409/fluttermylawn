// ML.SC.015: Store Locator Screen
import 'dart:convert';

import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:http/http.dart' as http;

abstract class StoreLocatorService {
  // Get local store list from price spider api
  Future<List<Store>> getLocalStores(
    String productId,
    double latitude,
    double longitude,
  );

  // Get online store list from price spider api
  Future<List<OnlineSeller>> getOnlineStores(String productId);
}

class StoreLocatorServiceImpl extends StoreLocatorService {
  @override
  Future<List<Store>> getLocalStores(
    String productId,
    double latitude,
    double longitude,
  ) async {
    final host = 'api.pricespider.com';
    final path = '/v2/restjson.svc/GetLocalStores';
    final apiKey = const String.fromEnvironment(
      EnvironmentConfig.PSPIDER_LOCAL_SELLERS_API_KEY,
      defaultValue: '###',
    );
    final skuList = 'US_$productId';

    try {
      final uri = Uri(
        scheme: 'https',
        host: host,
        path: path,
        queryParameters: {
          'apiConfigurationId': '$apiKey',
          'skuList': '$skuList',
          'latitude': '$latitude',
          'longitude': '$longitude',
        },
      );

      final response = await http.get(uri.toString());

      if (response.statusCode == 200) {
        final storeLocatorResponse =
            StoreLocatorResponse.fromJson(json.decode(response.body));

        return storeLocatorResponse.localSellers[0].sellers
            .map((seller) => seller.stores)
            .expand((store) => store)
            .toList();
      } else {
        throw StoreLocatorException('Something went wrong. Please try again.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OnlineSeller>> getOnlineStores(String productId) async {
    final host = 'api.pricespider.com';
    final path = '/v2/restjson.svc/GetOnlineSellers';
    final apiKey = const String.fromEnvironment(
      EnvironmentConfig.PSPIDER_ONLINE_STORES_API_KEY,
      defaultValue: '###',
    );
    final skuList = 'US_$productId';

    try {
      final uri = Uri(
        scheme: 'https',
        host: host,
        path: path,
        queryParameters: {
          'apiConfigurationId': '$apiKey',
          'skuList': '$skuList',
        },
      );
      final response = await http.get(uri.toString());

      if (response.statusCode == 200) {
        final storeLocatorResponse =
            StoreLocatorResponse.fromJson(json.decode(response.body));
        if (storeLocatorResponse.errorDescription == null) {
          return storeLocatorResponse.onlineSellers[0].sellers;
        } else {
          throw StoreLocatorException(storeLocatorResponse.errorDescription);
        }
      } else {
        throw StoreLocatorException('Something went wrong. Please try again.');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class StoreLocatorException implements Exception {
  final String reason;
  StoreLocatorException(this.reason);
}
