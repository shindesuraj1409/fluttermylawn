import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/product/product_state.dart';
import 'package:my_lawn/blocs/product/produt_event.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/plan/i_plan_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/utils/plan_state_combinator.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
      {RecommendationService recommendationService,
      FindSubscriptionsByCustomerIdService subscriptionService,
      ActivitiesService activitiesService,
      PlanService planService,
      SessionManager sessionManager,
      ProductsService productService,
      Stream<PlanStateCombinator> stateCombinatorStream})
      : productService = productService,
        activitiesService = activitiesService,
        sessionManager = sessionManager,
        stateCombinatorStream = stateCombinatorStream ??
            Rx.combineLatest3(
                subscriptionService.subscriptionStream,
                recommendationService.recommendationStream,
                activitiesService.activitiesStream,
                (a, b, c) => PlanStateCombinator(
                      subscription: a,
                      recommendation: b,
                      activities: c,
                    )),
        super(InitialProductState()) {
    this.stateCombinatorStream.listen((update) {
      add(ProductBlocReady(
          subscription: update.subscription,
          recommendation: update.recommendation,
          activityList: update.activities));
    });
  }

  final ProductsService productService;
  final ActivitiesService activitiesService;
  final SessionManager sessionManager;
  Stream<PlanStateCombinator> stateCombinatorStream;
  SubscriptionData subscription;
  Recommendation recommendation;
  List<ActivityData> activityList;
  @override
  Stream<ProductState> mapEventToState(event) async* {
    try {
      if (event is ProductBlocReady) {
        subscription = event.subscription;
        recommendation = event.recommendation;
        activityList = event.activityList;

        yield BlocReadyState();
      }
      if (event is ProductFetchEvent) {
        yield LoadingProductState();

        final product = event.product;
        var isFakeActivity = false;

        var finalProduct =
            await productService.copyWithGraphQL(product: product);

        var activity;

        if (activityList != null) {
          if (product.activityId != null) {
            activity = activityList.firstWhere(
                (activityElement) =>
                    activityElement.activityId == product.activityId,
                orElse: () => null);
          } else {
            activity = activityList.firstWhere(
                (activityElement) => activityElement.childProducts?.any(
                    (productElement) => product.childProducts
                        .map((e) => e.sku)
                        .contains(productElement.sku)),
                orElse: () => null);
          }
        }

        if (activity != null) {
          if (activity.activityType == ActivityType.fake) isFakeActivity = true;
          if (activity.activityType == ActivityType.recommended) {
            finalProduct = finalProduct.copyWith(isRecommended: true);
            if (subscription.subscriptionStatus == SubscriptionStatus.active ||
                subscription.subscriptionStatus == SubscriptionStatus.pending) {
              finalProduct = finalProduct.copyWith(
                isSubscribed: true,
                activityId: activity.activityId,
                applied: activity.applied,
                skipped: activity.skipped,
              );
            }
          } else if (activity.activityType == ActivityType.userAddedProduct) {
            finalProduct = product.copyWith(
              isAddedByMe: true,
              activityId: activity.activityId,
              applied: activity.applied,
              skipped: activity.skipped,
            );
          }
        } else {
          final prod = recommendation.plan.products.firstWhere(
              (element) =>
                  (element.parentSku != null && product.parentSku != null)
                      ? element.parentSku == product.parentSku
                      : (element.childProducts != null &&
                              element.childProducts.isNotEmpty)
                          ? element.childProducts.firstWhere(
                                  (childProd) => childProd.sku == product.sku,
                                  orElse: () => null) !=
                              null
                          : element.sku == product.sku,
              orElse: () => null);
          if (prod != null) {
            finalProduct = finalProduct.copyWith(isRecommended: true);
          }

          final addOn = recommendation.plan.addOnProducts.firstWhere(
              (element) =>
                  (element.parentSku != null && product.parentSku != null)
                      ? element.parentSku == product.parentSku
                      : (element.childProducts != null &&
                              element.childProducts.isNotEmpty)
                          ? element.childProducts.firstWhere(
                                  (childProd) => childProd.sku == product.sku,
                                  orElse: () => null) !=
                              null
                          : element.sku == product.sku,
              orElse: () => null);
          if (addOn != null) {
            finalProduct = finalProduct.copyWith(isAddOn: true);
          }
        }

        finalProduct.childProducts.forEach((e) {
          if (e.coverageArea == null) {
            final error =
                'Product with SKU: ${e.sku} has an empty coverage area and wont be displayed in the buy now section.';
            unawaited(FirebaseCrashlytics.instance
                .recordError(error, StackTrace.current));
            registry<Logger>().e(error);
          }
        });
        finalProduct.childProducts
            .removeWhere((element) => element.coverageArea == null);
        finalProduct.childProducts
            .sort((a, b) => a.coverageArea.compareTo(b.coverageArea));
        yield ProductFetchedState(
            product: finalProduct, isFakeActivity: isFakeActivity);
      }
      if (event is DeleteProductActivitiesEvent) {
        final product = event.product;
        final user = await sessionManager.getUser();
        final activities = activityList
            .where((element) => element.productId == product.parentSku)
            .toList();
        for (var activity in activities) {
          await activitiesService.deleteActivity(
              user.customerId, activity.activityId);
        }
      }
    } catch (exception) {
      yield ErrorProductState(
          errorMessage: 'Something went wrong, Please try again');
      unawaited(FirebaseCrashlytics.instance
          .recordError(exception, StackTrace.current));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
