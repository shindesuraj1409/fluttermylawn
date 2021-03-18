import 'dart:convert';

import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:rxdart/rxdart.dart';

abstract class FindSubscriptionsByCustomerIdService {
  Stream<SubscriptionData> get subscriptionStream;

  Future<List<SubscriptionData>> findSubscriptionsByCustomerId(
      String customerId);
}

class FindSubscriptionsByCustomerIdServiceImpl
    implements FindSubscriptionsByCustomerIdService {
  final ScottsApiClient _apiClient;
  final String _basePath;
  final _subscriptionStream = BehaviorSubject<SubscriptionData>();

  FindSubscriptionsByCustomerIdServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = 'subscriptions/v1/subscriptions/find';

  void dispose() {
    _subscriptionStream.close();
  }

  @override
  Future<List<SubscriptionData>> findSubscriptionsByCustomerId(
      String customerId) async {
    try {
      // For Guest Users, there will be no "customerId"
      // and associated "Subscription" to fetch because to buy
      // a Subscription users need to sign up first.
      // In that case we set subscription status to "none" in subscriptionStream(for whoever is listening to stream data)
      // and return empty results.
      if (customerId == null) {
        _emit(SubscriptionData(subscriptionStatus: SubscriptionStatus.none));
        return [];
      }

      final queryParameters = {'customerId': '${customerId}'};
      final response = await _apiClient.get(
        '$_basePath',
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200) {
        throw FindSubscriptionByCustomerIdException(
            errorMessage: 'Unable to find subscription for ${customerId}');
      }

      final subscriptionData = json.decode(response.body);
      final subscriptions = List<SubscriptionData>.from(
        subscriptionData?.map(
              (subscription) => SubscriptionData.fromMap(subscription),
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
