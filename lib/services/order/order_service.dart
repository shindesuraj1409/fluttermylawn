import 'dart:convert';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/order/i_order_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/order/order_request_bodies.dart';
import '../scotts_api_client.dart';

class OrderServiceImpl implements OrderService {
  final ScottsApiClient _apiClient;

  OrderServiceImpl() : _apiClient = registry<ScottsApiClient>();

  @override
  Future<String> createOrder(CreateOrderRequest orderRequest) async {
    try {
      final response = await _apiClient.post(
        '/orders/v1/orders/kickoff',
        body: orderRequest.toJson(),
      );

      if (response.statusCode != 201) {
        final map = json.decode(
          response.body,
        );
        throw OrderException(map['message']);
      }

      final map = json.decode(
        response.body,
      );
      return map['orderId'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createAddonOrder(CreateOrderRequest orderRequest) async {
    try {
      final response = await _apiClient.post(
        '/subscriptions/v1/subscriptions/${orderRequest.subscriptionId}/addons',
        body: orderRequest.toAddonJson(),
      );

      if (response.statusCode != 201) {
        final map = json.decode(
          response.body,
        );
        throw OrderException(map['message']);
      }

      final map = json.decode(
        response.body,
      );
      return map['orderId'];
    } catch (e) {
      rethrow;
    }
  }
}
