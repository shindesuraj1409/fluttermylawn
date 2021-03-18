import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/order_data.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:my_lawn/services/subscription/order_details/order_details_exceptions.dart';

abstract class OrderDetailsService {
  Future<OrderData> getOrder(String orderId);
}

class OrderDetailsServiceImpl implements OrderDetailsService {
  final ScottsApiClient _apiClient;
  final String _basePath;

  OrderDetailsServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = 'orders/v1/orders';

  @override
  Future<OrderData> getOrder(String orderId) async {
    try {
      final response = await _apiClient.get('$_basePath/$orderId');

      if (response.statusCode != 200) {
        throw OrderDetailsException();
      }
      return OrderData.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
