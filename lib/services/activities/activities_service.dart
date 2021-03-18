import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/extensions/string_extensions.dart';
import 'package:my_lawn/services/activities/activities_exception.dart';
import 'package:my_lawn/services/activities/activity_network.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:rxdart/rxdart.dart';

const String firestoreRecommendationActivities = 'recommendation-activities';

const _activityTypes = <ActivityType, String>{
  ActivityType.waterLawn: 'water_lawn',
  ActivityType.mowLawn: 'mow_lawn',
  ActivityType.aerateLawn: 'aerate_lawn',
  ActivityType.dethatchLawn: 'dethatch_lawn',
  ActivityType.overseedLawn: 'overseed_lawn',
  ActivityType.mulchBeds: 'mulch_beds',
  ActivityType.cleanDeckPatio: 'clean_deck_patio',
  ActivityType.winterizeSprinklerSystem: 'winterize_sprinkler_system',
  ActivityType.tuneUpMower: 'tune_up_mower',
  ActivityType.createYourOwn: 'create_your_own',
  ActivityType.recommended: 'product_recommendation',
  ActivityType.userAddedProduct: 'user_added_product',
};

class ActivitiesServiceImpl implements ActivitiesService {
  final _activitiesStream = BehaviorSubject<List<ActivityData>>();
  final _productsService = registry<ProductsService>();

  ActivitiesServiceImpl() : _apiClient = registry<ScottsApiClient>();

  final ScottsApiClient _apiClient;

  void dispose() {
    _activitiesStream.close();
  }

  @override
  Future<void> createActivity(
    String customerId,
    ActivityData activityData,
  ) async {
    final requestBody = _mapActivityToJson(activityData);

    final response = await _apiClient.post(
      '/activities/v1/activity/$customerId',
      body: requestBody,
    );

    if (response.statusCode != 201) {
      throw ActivitiesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    final activity = _mapNetworkToDomain(
        ActivityResponse.fromJson(jsonDecode(response.body)));

    _addActivityToStream(activity);
  }

  @override
  Future<void> deleteActivity(String customerId, String activityId) async {
    final response = await _apiClient.delete(
      '/activities/v1/activity/$customerId/$activityId',
    );

    if (response.statusCode != 200) {
      throw ActivitiesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    _deleteActivityFromStream(activityId);
  }

  @override
  Future<void> waitForActivities(
      String customerId, String recommendationId) async {
    //in the case is a guest user
    if (customerId == null) {
      _emit(null);
      return;
    }

    //Awaiter to remove race condition when this method is called while creating activities
    final environmentSelected =
        await registry<EnvironmentConfig>().getSelectedEnvironment();

    FirebaseFirestore firestore;

    if (environmentSelected == Environment.rc) {
      final apps = Firebase.apps;
      var dtcInfrastructureSandboxInitialized = false;
      apps.forEach((app) {
        dtcInfrastructureSandboxInitialized =
            app.name == EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX;
      });

      if (!dtcInfrastructureSandboxInitialized) {
        await Firebase.initializeApp(
          name: EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX,
          options: FirebaseOptions(
            apiKey: Platform.isIOS
                ? const String.fromEnvironment(
                    EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX_IOS_API_KEY)
                : const String.fromEnvironment(EnvironmentConfig
                    .DTC_INFRASTRUCTURE_SANDBOX_ANDROID_API_KEY),
            appId: Platform.isIOS
                ? const String.fromEnvironment(
                    EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX_IOS_APP_ID)
                : const String.fromEnvironment(EnvironmentConfig
                    .DTC_INFRASTRUCTURE_SANDBOX_ANDROID_APP_ID),
            messagingSenderId: const String.fromEnvironment(
                EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX_MESSAGE_SENDER_ID),
            projectId: EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX,
          ),
        );
      }
      firestore = FirebaseFirestore.instanceFor(
          app: Firebase.app(EnvironmentConfig.DTC_INFRASTRUCTURE_SANDBOX));
    } else {
      firestore = FirebaseFirestore.instance;
    }

    await firestore
        .collection(firestoreRecommendationActivities)
        .doc(recommendationId)
        .get()
        .then(
      (value) async {
        if (value.exists) {
          return getActivities(customerId);
        } else {
          await _fakeActivities(recommendationId);
          firestore
              .collection(firestoreRecommendationActivities)
              .snapshots(includeMetadataChanges: true)
              .listen(
            (snapshot) {
              if (snapshot.metadata.isFromCache) {
                getActivities(customerId);
              }
              snapshot.docChanges.forEach(
                (element) {
                  if (element.type == DocumentChangeType.added) {
                    if (element.doc.id == recommendationId) {
                      //refresh activities
                      getActivities(customerId);
                    }
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  void _fakeActivities(String recommendationId) async {
    final recommendation = await registry<RecommendationService>()
        .getRecommendation(recommendationId);

    final activities = recommendation.plan.products
        .map((e) => ActivityData.fromRecommendation(recommendationId, e))
        .toList();

    _emit(activities);
  }

  @override
  Future<void> getActivities(String customerId) async {
    final response =
        await _apiClient.get('/activities/v1/activity/$customerId');

    if (response.statusCode != 200) {
      _emit([ActivityData()]);
      throw ActivitiesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    final activitiesResponse =
        ActivitiesListResponse.fromJson(jsonDecode(response.body));

    final activities =
        activitiesResponse.activities.map(_mapNetworkToDomain).toList();

    _emit(activities);
  }

  @override
  Future<void> updateActivity(
    String customerId,
    ActivityData activityData,
  ) async {
    var requestBody;
    if (activityData.applied || activityData.skipped) {
      if (activityData.applied) {
        requestBody = {
          'status': 'applied',
          'appliedDate':
              (activityData.appliedDate ?? DateTime.now()).toIso8601String(),
        };
      } else {
        requestBody = {
          'status': 'skipped',
        };
      }
    } else {
      requestBody = _mapActivityToJson(activityData);
    }

    final response = await _apiClient.put(
      '/activities/v1/activity/$customerId/${activityData.activityId}',
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw ActivitiesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    final activity = _mapNetworkToDomain(
        ActivityResponse.fromJson(jsonDecode(response.body)));

    _updateActivityInStream(activity);
  }

  Map<String, dynamic> _mapActivityToJson(ActivityData activityData) {
    return ActivityRequest(
      productId: activityData.productId,
      activityType: _activityTypes[activityData.activityType],
      description: activityData.description,
      frequency: activityData.frequency,
      time: activityData.time,
      activityDate: activityData.activityDate,
      recommendationId: activityData.recommendationId,
      status: activityData.isAutomaticallyDone || activityData.applied
          ? 'applied'
          : null,
      applicationWindow: activityData.applicationWindow,
      reminder: activityData.remind,
      duration: activityData.duration,
    ).toJson();
  }

  ActivityData _mapNetworkToDomain(ActivityResponse activity) {
    return ActivityData(
      activityId: activity.activityId,
      productId: activity.productId,
      childProducts: activity.childProducts,
      activityType: _activityTypes.keys.firstWhere(
        (key) => _activityTypes[key] == activity.activityType,
        orElse: () => ActivityType.createYourOwn,
      ),
      description: activity.description,
      frequency: activity.frequency,
      time: activity.time,
      activityDate: activity.activityDate,
      recommendationId: activity.recommendationId,
      applicationWindow: activity.applicationWindow,
      appliedDate: activity.appliedDate,
      completedDate: activity.completedDate,
      name: activity.name,
      applied: activity.applied,
      skipped: activity.skipped,
      duration: activity.duration,
      remind: activity.reminder,
    );
  }

  void _addActivityToStream(ActivityData activity) {
    final activities = _activitiesStream.value ?? <ActivityData>[];
    activities.add(activity);
    _emit(activities);
  }

  void _updateActivityInStream(ActivityData activity) {
    final activities = _activitiesStream.value;
    final index = activities
        .indexWhere((element) => element.activityId == activity.activityId);
    activities[index] = activity;
    _emit(activities);
  }

  void _deleteActivityFromStream(String activityId) {
    final activities = _activitiesStream.value;
    activities.removeWhere((element) => element.activityId == activityId);
    _emit(activities);
  }

  void _emit(List<ActivityData> activities) {
    _activitiesStream.sink.add(activities);
  }

  @override
  Stream<List<ActivityData>> get activitiesStream => _activitiesStream.stream;

  @override
  Future<List<ActivityData>> copyWithGraphQL(
      {List<ActivityData> activities, List<String> products}) async {
    if (products.isEmpty) return null;
    final productResponse =
        await _productsService.getProducts(skuList: products);

    final resp = <ActivityData>[];
    for (var activity in activities) {
      if (activity.activityType == ActivityType.userAddedProduct) {
        final product = productResponse
            .map((product) => product.copyWith(
                isAddedByMe: true, childProducts: [product].toList()))
            .firstWhere((element) => element.sku == activity.productId);
        activity = activity.copyWith(
          childProducts: [product],
          name: product.name,
        );
      } else {
        final updatedChildProducts = <Product>[];
        for (var childProduct in activity.childProducts) {
          final graphQLProd = productResponse.firstWhere(
              (product) => product.sku.matchesSKU(childProduct.sku),
              orElse: () => null);
          Product product;
          if (graphQLProd != null) {
            product = childProduct.copyWithProduct(graphQLProd);

            //TODO: check if is a skipped activity
            //we dont have backend support for this
            product = product.copyWith(
              applied: activity.appliedDate != null ||
                  activity.completedDate != null,
              completedDate: activity.appliedDate ?? activity.completedDate,
            );
          } else {
            product = childProduct.copyWith(name: activity.name);
          }
          updatedChildProducts.add(product);
        }

        activity = activity.copyWith(childProducts: updatedChildProducts);
      }
      resp.add(activity);
    }

    return resp;
  }
}
