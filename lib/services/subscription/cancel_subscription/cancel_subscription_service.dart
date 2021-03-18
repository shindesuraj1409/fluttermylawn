import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/refund_preview_data.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:my_lawn/services/subscription/cancel_subscription/cancel_subscription_exceptions.dart';

abstract class CancelSubscriptionService {
  Future<bool> cancelSubscription(String orderId);
  Future<RefundData> previewSubscriptionRefund(String orderId);
}

class CancelSubscriptionServiceImpl implements CancelSubscriptionService {
  final ScottsApiClient _apiClient;
  final String _basePath;

  CancelSubscriptionServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = '/orders/v1/orders';

  @override
  Future<bool> cancelSubscription(String orderId) async {
    try {
      final response = await _apiClient.delete('$_basePath/$orderId');

      if (response.statusCode == 200) {
        return true;
      }
      throw CancelSubscriptionException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RefundData> previewSubscriptionRefund(String orderId) async {
    try {
      final _payload = {'orderId': orderId};
      final response = await _apiClient.post('$_basePath/previewCancellation',
          body: _payload);

      if (response.statusCode == 200) {
        return RefundData.fromJson(response.body);
      }
      throw PreviewRefundException(errorMessage: 'Error getting preview.');
    } catch (exception) {
      rethrow;
    }
  }
}
