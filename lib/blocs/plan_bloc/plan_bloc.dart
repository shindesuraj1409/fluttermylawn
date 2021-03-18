import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_event.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_state.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/plan/i_plan_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/utils/plan_state_combinator.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final PlanService planService;
  final ActivitiesService activitiesService;
  final ProductsService productsService;
  final AuthenticationBloc authenticationBloc;
  Stream<PlanStateCombinator> stateCombinatorStream;

  PlanBloc(
      {ProductsService productsService,
      RecommendationService recommendationService,
      FindSubscriptionsByCustomerIdService subscriptionService,
      ActivitiesService activitiesService,
      PlanService planService,
      AuthenticationBloc authenticationBloc,
      // inject a stream for unit testing purposes
      Stream<PlanStateCombinator> stateCombinatorStream})
      : planService = planService ?? registry<PlanService>(),
        activitiesService = activitiesService,
        productsService = productsService ?? registry<ProductsService>(),
        authenticationBloc =
            authenticationBloc ?? registry<AuthenticationBloc>(),
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
        super(PlanInitialState()) {
    this.stateCombinatorStream.listen((update) {
      add(PlanChanged(
          subscription: update.subscription,
          recommendation: update.recommendation,
          activities: update.activities));
    });
  }

  @override
  Stream<PlanState> mapEventToState(PlanEvent event) async* {
    try {
      final previousState = state;
      if (event is PlanChanged) {
        if (authenticationBloc.state.isLoggedOut) {
          yield PlanInitialState();
          return;
        }
        if (authenticationBloc.state == null ||
            authenticationBloc.state.user == null) throw Exception();
        final user = authenticationBloc.state.user;
        final isGuest = user.email == null && user.recommendationId != null;
        yield PlanLoadingState();
        final recommendation = event.recommendation;
        final activities = event.activities;
        final subscription = event.subscription;
        final skus = <String>[];
        Plan plan;

        if (!isGuest) {
          if (activities == null) return;
          var planActivities = activities
              .where(
                (element) =>
                    (element.activityType == ActivityType.recommended &&
                        element.recommendationId ==
                            recommendation.recommendationId &&
                        element.childProducts.isNotEmpty) ||
                    (element.activityType == ActivityType.userAddedProduct &&
                        element.productId != null) ||
                    (element.activityType == ActivityType.fake),
              )
              .toList();

          final recommendedSkus = planActivities
              .where(
                (element) =>
                    element.activityType == ActivityType.recommended ||
                    element.activityType == ActivityType.fake,
              )
              .expand((element) => element.childProducts)
              .map((e) => e.sku)
              .toList();

          final userAddedSkus = planActivities
              .where(
                (element) =>
                    element.activityType == ActivityType.userAddedProduct,
              )
              .map((e) => e.productId)
              .toList();

          skus.addAll(recommendedSkus + userAddedSkus);

          planActivities = await activitiesService.copyWithGraphQL(
              activities: planActivities, products: skus);

          planActivities = _copyWithSubscriptionState(
              activities: planActivities, subscription: subscription);

          planActivities?.sort((a, b) => a.applicationWindow.startDate
              .compareTo(b.applicationWindow.startDate));

          plan = Plan.fromActivities(activities: planActivities);
          final addOnProducts = event.recommendation.plan.addOnProducts;
          plan = plan.copyWith(addOnProducts: addOnProducts);
        } else {
          recommendation.plan.products.forEach((parentProd) {
            parentProd.childProducts.forEach((childProd) {
              skus.add(childProd.sku);
            });
          });
          plan = await planService.copyWithGraphQL(
            plan: recommendation.plan,
            products: skus,
          );
        }
        plan.products.forEach((element) {
          if (element.childProducts != null) {
            element.childProducts
                .sort((a, b) => a.coverageArea.compareTo(b.coverageArea));
          }
        });

        final recommendationImages = recommendation.plan.products
            .map((product) => product?.childProducts?.first?.imageUrl ?? '')
            .toList();

        yield previousState is PlanSuccessState
            ? previousState.copyWith(
                plan: plan,
                subscription: subscription,
                recommendationImages: recommendationImages)
            : PlanSuccessState(
                plan: plan,
                subscription: subscription,
                recommendationImages: recommendationImages);
      }
      if (event is PlanRetryButtonPressed || event is PlanUpdate) {
        final user = authenticationBloc.state.user;
        unawaited(registry<RecommendationService>()
            .getRecommendationByCustomer(user.customerId));

        unawaited(registry<FindSubscriptionsByCustomerIdService>()
            .findSubscriptionsByCustomerId(user.customerId));

        unawaited(registry<ActivitiesService>().waitForActivities(
          user.customerId,
          user.recommendationId,
        ));
      }
    } catch (e) {
      yield PlanErrorState(
          errorMessage: 'Something went wrong. Please try again');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  List<ActivityData> _copyWithSubscriptionState(
      {List<ActivityData> activities, SubscriptionData subscription}) {
    if (subscription.subscriptionStatus == SubscriptionStatus.active ||
        subscription.subscriptionStatus == SubscriptionStatus.pending) {
      if (activities != null) {
        for (var activity in activities) {
          for (var product in activity.childProducts) {
            var modifiedProduct = product;
            if (activity.activityType == ActivityType.userAddedProduct) {
              modifiedProduct = product.copyWith(isAddedByMe: true);
            }
            if (activity.activityType == ActivityType.recommended) {
              modifiedProduct = product.copyWith(isSubscribed: true);
            }
            activity.childProducts[activity.childProducts.indexOf(product)] =
                modifiedProduct;
          }
        }
      }
    }
    return activities;
  }
}
