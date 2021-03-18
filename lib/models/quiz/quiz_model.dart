import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/location_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/data_mock/quiz_response.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/recommendation/recommendation_exception.dart';
import 'package:my_lawn/services/subscription/modify_subscription/modify_subscription_service.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';
import 'package:pedantic/pedantic.dart';

class QuizModel with Bus {
  Map<QuestionType, String> answers = {};
  final Quiz _quiz = quizData;
  SubscriptionBloc _subscriptionBloc;

  final RecommendationService _recommendationService;
  final ModifySubscriptionService _modifySubscriptionService;
  final SessionManager _sessionManager;
  final LocalyticsService _localyticsService;
  final WaterModelService _waterModelService;

  QuizModel()
      : _recommendationService = registry<RecommendationService>(),
        _modifySubscriptionService = registry<ModifySubscriptionService>(),
        _waterModelService = registry<WaterModelService>(),
        _sessionManager = registry<SessionManager>(),
        _localyticsService = registry<LocalyticsService>();

  QuizPage getQuizPage(QuizPageType pageType) {
    switch (pageType) {
      case QuizPageType.lawnCondition:
        return _quiz.pages[0];
      case QuizPageType.spreader:
        return _quiz.pages[1];
      case QuizPageType.lawnAreaAndZipCode:
        return _quiz.pages[2];
      case QuizPageType.grassType:
        return _quiz.pages[3];
      default:
        throw UnimplementedError('Incorrect pageType : $pageType');
    }
  }

  String getZipCode() => answers[QuestionType.zipCode];

  @override
  void destroy() {
    _subscriptionBloc.close();
    super.destroy();
  }

  void saveLawnCondition(
    int colorRating,
    int thicknessRating,
    int weedsRating,
  ) {
    answers[QuestionType.lawnColor] = LawnGrassColor.values
        .firstWhere((value) => value.index == colorRating)
        .pascalCaseString;

    answers[QuestionType.lawnThickness] = LawnGrassThickness.values
        .firstWhere((value) => value.index == thicknessRating)
        .pascalCaseString;

    answers[QuestionType.lawnWeeds] = LawnWeeds.values
        .firstWhere((value) => value.index == weedsRating)
        .pascalCaseString;

    unawaited(_localyticsService.updateUserProfile());
  }

  void setAnswers(LawnData lawnData) async {
    saveSpreaderType(lawnData.spreader);
    saveLawnCondition(
        lawnData.color.index, lawnData.thickness.index, lawnData.weeds.index);
    await saveAddressInfo(
      lawnArea: lawnData.lawnSqFt,
      zipCode: lawnData.lawnAddress?.zip,
      locationData: LocationData(
        city: lawnData.lawnAddress?.city,
        address: lawnData.lawnAddress?.address1,
        state: lawnData.lawnAddress?.state,
      ),
    );
    await saveGrassType(lawnData.grassType, lawnData.grassTypeImageUrl,
        lawnData.grassTypeNameString);
  }

  void saveSpreaderType(Spreader spreader) {
    answers[QuestionType.lawnSpreader] = Spreader.values
        .firstWhere((value) => value == spreader)
        .pascalCaseString;

    unawaited(_localyticsService.updateUserProfile());
  }

  void saveAddressInfo(
      {int lawnArea,
      String zipCode,
      String lawnZone,
      LocationData locationData,
      String inputType}) async {
    answers[QuestionType.lawnArea] = lawnArea.toString();
    answers[QuestionType.zipCode] = zipCode;
    answers[QuestionType.lawnZone] = lawnZone;
    answers[QuestionType.inputType] = inputType;

    final addressData = AddressData(
      address1: locationData?.address,
      city: locationData?.city,
      state: locationData?.state,
      zip: zipCode,
    );

    await _sessionManager
        .setLawnData(LawnData(lawnAddress: addressData, inputType: inputType));

    unawaited(_localyticsService.updateUserProfile());
  }

  void saveGrassType(
    String grassType,
    String grassTypeImageUrl,
    String grassTypeLabel,
  ) async {
    answers[QuestionType.grassType] = grassType;

    await _sessionManager.setLawnData(LawnData(
      grassTypeImageUrl: grassTypeImageUrl,
      grassTypeName:
          grassType == LawnData.unknownGrassType ? '' : grassTypeLabel,
    ));

    unawaited(_localyticsService.updateUserProfile());
  }

  Future<void> submitQuiz() async {
    _subscriptionBloc = registry<SubscriptionBloc>();
    if (_subscriptionBloc.state.status == SubscriptionStatus.active) {
      publish(data: QuizSubmitData.updating());
    } else {
      publish(data: QuizSubmitData.submitting());
    }
    try {
      //If a user registers first before taking the quiz, lets associate the
      //recommendation to the customerId
      final user = await _sessionManager.getUser();
      final quizSubmitRequest =
          QuizSubmitRequest.create(answers, user?.customerId);
      final recommendation =
          await _recommendationService.submitQuiz(quizSubmitRequest);

      final previousProductCount =
          await _sessionManager.getPreviousRecommendationProductCount();
      if (previousProductCount == null) {
        await _sessionManager.setPreviousRecommendationProductCount(
            recommendation.plan.products.length);
      }

      //For logged in User, create a new plot for the water module
      if (user.customerId != null) {
        await _waterModelService.createPlot(user.customerId,
            int.tryParse(recommendation.lawnData.lawnAddress.zip));
      }

      // Save "recommendationId" in local storage
      await _sessionManager
          .setUser(User(recommendationId: recommendation.recommendationId));
      // Save "LawnData" in local storage
      await _sessionManager.setLawnData(recommendation.lawnData);

      unawaited(_localyticsService.updateUserProfile());

      publish(data: QuizSubmitData.success(recommendation));
    } on CreateLawnProfileException catch (e) {
      log.warning(e.reason);
      publish(data: QuizSubmitData.error(e.reason));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      log.warning(e.toString());
      publish(
          data: QuizSubmitData.error(
              'Something went wrong when creating Lawn Profile.'));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Future<int> subscriptionPlanUpdateCount(String recommendationId) async {
    final response = await _modifySubscriptionService.modificationPreview(
        '${_subscriptionBloc.state.data.last.id}', recommendationId);
    return response.isEmpty ? 0 : response.last.changes;
  }

  Future<int> recommendationPlanUpdateCount(
      Recommendation currentRecommendation) async {
    final previousRecommendationCount =
        await _sessionManager.getPreviousRecommendationProductCount();

    final totalProducts = currentRecommendation.plan?.products?.length ?? 0;
    await _sessionManager.setPreviousRecommendationProductCount(totalProducts);

    if (previousRecommendationCount == null) {
      return 0;
    }

    return (totalProducts - previousRecommendationCount).abs();
  }

  @override
  List<Channel> get channels => [Channel(QuizSubmitData)];
}

class QuizSubmitData extends Data {
  final Recommendation recommendation;
  final String errorMessage;
  final QuizSubmitState state;

  QuizSubmitData.submitting()
      : recommendation = null,
        errorMessage = null,
        state = QuizSubmitState.submitting_quiz;
  QuizSubmitData.updating()
      : recommendation = null,
        errorMessage = null,
        state = QuizSubmitState.updating_quiz;
  QuizSubmitData.error(String errorMessage)
      : recommendation = null,
        errorMessage = errorMessage,
        state = QuizSubmitState.error;

  QuizSubmitData.success(Recommendation recommendation)
      : recommendation = recommendation,
        errorMessage = null,
        state = QuizSubmitState.success;

  @override
  List<Object> get props => [state];
}

enum QuizSubmitState {
  submitting_quiz,
  error,
  success,
  updating_quiz,
}
