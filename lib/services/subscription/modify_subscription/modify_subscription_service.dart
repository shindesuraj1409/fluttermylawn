import 'dart:convert';

import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:rxdart/rxdart.dart';

import 'modify_subscription_exception.dart';

abstract class ModifySubscriptionService {
  Stream<SubscriptionData> get subscriptionStream;

  Future<List<SubscriptionData>> modificationPreview(
      String subscriptionId, String recommendationId);
}

class ModifySubscriptionServiceImpl implements ModifySubscriptionService {
  final ScottsApiClient _apiClient;
  final String _basePath;
  final _subscriptionStream = BehaviorSubject<SubscriptionData>();

  ModifySubscriptionServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath =
            'subscriptions/v1/subscriptions/subscriptionModificationPreview';

  void dispose() {
    _subscriptionStream.close();
  }

  @override
  Future<List<SubscriptionData>> modificationPreview(
      String subscriptionId, String recommendationId) async {
    try {
      final queryParameters = {
        'subscriptionId': '${subscriptionId}',
        'recommendationId': '${recommendationId}',
        'engineType': 'lawn'
      };
      final response = await _apiClient.post(
        '$_basePath',
        body: queryParameters,
      );

      if (response.statusCode != 201) {
        throw ModifySubscriptionException(
            errorMessage: 'Unable to preview subscription modification');
      }

      final subscriptionData = json.decode(response.body);

      final subscriptions = List<SubscriptionData>.from(
        subscriptionData['report']['newAdded']?.map(
              (subscription) => SubscriptionData.fromMap(
                subscription['report']['newAdded'],
                subscriptionData['report']['newAdded'].length +
                    subscriptionData['report']['removed'].length +
                    subscriptionData['report']['sameSkuDifferentQty'].length,
              ),
            ) ??
            [],
      );
      if (subscriptions.isEmpty) {
        _emit(SubscriptionData(subscriptionStatus: SubscriptionStatus.none));
      } else {
        _emit(subscriptions.last);
      }
      return subscriptions;
    } catch (exception) {
      _emit(SubscriptionData(subscriptionStatus: SubscriptionStatus.error));
      rethrow;
    }
  }

  @override
  Stream<SubscriptionData> get subscriptionStream => _subscriptionStream.stream;

  void _emit(SubscriptionData subscription) {
    _subscriptionStream.sink.add(subscription);
  }
}
