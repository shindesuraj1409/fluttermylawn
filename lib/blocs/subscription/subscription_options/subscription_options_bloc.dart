import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:pedantic/pedantic.dart';

part 'subscription_options_event.dart';
part 'subscription_options_state.dart';

const invalidRecommendationPlanErrorMessage =
    "Error! Invalid recommendation received. You'll have to retake quiz";
const recommendationPlanNotFoundErrorMessage =
    'We’re sorry! We’re unable to find your Recommendation Plan';
const regenerateRecommendationErrorMessage =
    "We're sorry! We're unable to update your Recommendation";
const genericErrorMessage = 'Something went wrong. Please try again';

class SubscriptionOptionsBloc
    extends Bloc<SubscriptionOptionsEvent, SubscriptionOptionsState> {
  final RecommendationService service;
  final Stream<Recommendation> recommendationStream;

  SubscriptionOptionsBloc({
    @required this.service,
    @required this.recommendationStream,
  })  : assert(service != null),
        assert(recommendationStream != null),
        super(SubscriptionOptionsState.initial());

  void fetchRecommendation(String recommendationId) {
    add(FetchRecommendationEvent(recommendationId));
  }

  void regenerateRecommendation(String recommendationId) {
    add(RegenerateRecommendationEvent(recommendationId));
  }

  @override
  Stream<SubscriptionOptionsState> mapEventToState(
    SubscriptionOptionsEvent event,
  ) async* {
    if (event is FetchRecommendationEvent) {
      yield* _mapFetchRecommendationEventToState(event.recommendationId);
    } else if (event is RegenerateRecommendationEvent) {
      yield* _mapRegenerateEventToState(event.recommendationId);
    }
  }

  Stream<SubscriptionOptionsState> _mapFetchRecommendationEventToState(
      String recommendationId) async* {
    try {
      yield SubscriptionOptionsState.fetchingRecommendation();

      Recommendation recommendation;
      // Try to get THE LATEST recommendation from service stream cache
      await recommendationStream.listen((event) {
        recommendation = event;
      });

      // If not present in cache, do an api call to get the recommendation
      if (!_isCached(recommendation)) {
        recommendation = await service.getRecommendation(recommendationId);
      }

      final isPlanValid = _checkIfPlanIsValid(recommendation.plan);
      if (!isPlanValid) {
        yield SubscriptionOptionsState.fetchRecommendationError(
            invalidRecommendationPlanErrorMessage);
        return;
      }

      // Sort products in plan by application startDate
      recommendation.plan.products.sort(
        (product1, product2) => product1.applicationWindow.startDate.compareTo(
          product2.applicationWindow.startDate,
        ),
      );

      // Regenerate recommendation if user's system date is after
      // the first product's application startDate

      // This would happen in scenario where user has taken the quiz
      // then later on didn't subscribed to any plan(seasonal or annual) immediately
      // instead they decide to do it later on after few weeks/months.
      // So, the old recommendation plan is no longer applicable and needs
      // to be "regenerated" using old "recommendationId".
      final firstProduct = recommendation.plan.products.first;
      final currentDateTime = DateTime.now();
      if (currentDateTime.isAfter(firstProduct.applicationWindow.startDate)) {
        yield* _mapRegenerateEventToState(recommendationId);
        return;
      }

      // We don't get bundle prices from API.
      // we need to calculate those by looking
      // at all childproducts "prices" and their respective "quantities"
      final updatedPlan =
          recommendation.plan.getUpdatedPlanWithPricesCalculated();
      yield SubscriptionOptionsState.fetchRecommendationSuccess(updatedPlan);
    } on ApiException catch (e) {
      yield SubscriptionOptionsState.fetchRecommendationError(e.message);
    } catch (e) {
      yield SubscriptionOptionsState.fetchRecommendationError(
          genericErrorMessage);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<SubscriptionOptionsState> _mapRegenerateEventToState(
      String recommendationId) async* {
    try {
      yield SubscriptionOptionsState.regeneratingRecommendation();

      final recommendation =
          await service.regenerateRecommendation(recommendationId);
      final plan = recommendation.plan.getUpdatedPlanWithPricesCalculated();

      yield SubscriptionOptionsState.regenerateRecommendationSuccess(plan);
    } on NotFoundException catch (e) {
      yield SubscriptionOptionsState.regenerateRecommendationError(
          regenerateRecommendationErrorMessage);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield SubscriptionOptionsState.regenerateRecommendationError(
          regenerateRecommendationErrorMessage);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  bool _checkIfPlanIsValid(Plan plan) {
    if (plan == null || plan.products == null || plan.products.isEmpty) {
      return false;
    }

    var isValid = true;
    for (final products in plan.products) {
      if (products.childProducts == null || products.childProducts.isEmpty) {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  bool _isCached(Recommendation recommendation) =>
      recommendation.recommendationId != null &&
      recommendation.plan != null &&
      recommendation.plan.products != null &&
      recommendation.plan.products.isNotEmpty;
}
