import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/recommendation/recommendation_exception.dart';
import 'package:my_lawn/services/scotts_api_client.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class RecommendationServiceImpl implements RecommendationService {
  final _recommendationStream = BehaviorSubject<Recommendation>();

  final ScottsApiClient _apiClient;
  final String _basePath;
  RecommendationServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = '/recommendations/v1/productRecommendations';

  void dispose() {
    _recommendationStream.close();
  }

  @override
  Future<Recommendation> submitQuiz(QuizSubmitRequest quizSubmitRequest) async {
    try {
      final response = await _apiClient.post(
        '$_basePath',
        body: quizSubmitRequest.toJson(),
      );

      if (response.statusCode != 201) {
        throw CreateLawnProfileException(
            'Something went wrong when creating your Lawn Profile');
      }

      final recommendation =
          Recommendation.fromJson(json.decode(response.body));
      _emit(recommendation);
      return recommendation;
    } catch (e) {
      _emit(Recommendation());
      rethrow;
    }
  }

  @override
  Future<Recommendation> getRecommendation(String recommendationId) async {
    try {
      final response = await _apiClient.get('$_basePath/$recommendationId');

      if (response.statusCode != 200) {
        throw getRESTException(response.statusCode);
      }

      final recommendation =
          Recommendation.fromJson(json.decode(response.body));
      _emit(recommendation);
      return recommendation;
    } catch (e) {
      _emit(Recommendation());
      rethrow;
    }
  }

  @override
  Future<Recommendation> regenerateRecommendation(
      String recommendationId) async {
    try {
      // Not sure why BE team has kept a "POST" request as "GET" request.
      final response =
          await _apiClient.get('$_basePath/generate/$recommendationId');

      if (response.statusCode == 404) {
        throw NotFoundException(errorCode: response.statusCode);
      }

      final recommendation =
          Recommendation.fromJson(json.decode(response.body));
      _emit(recommendation);
      return recommendation;
    } catch (e) {
      _emit(Recommendation());
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      rethrow;
    }
  }

  @override
  Future<Recommendation> getRecommendationByCustomer(String customerId) async {
    try {
      final response = await _apiClient.get('$_basePath/customer/$customerId');

      if (response.statusCode == HttpStatus.notFound) {
        throw NotFoundException(errorCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ForbiddenException(errorCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        throw UnauthorizedException(errorCode: response.statusCode);
      }
      final recommendationJson = json.decode(response.body);
      var recommendation = Recommendation();
      if (recommendationJson.isNotEmpty) {
        final List<Recommendation> recommendations = recommendationJson
            .map<Recommendation>((e) => Recommendation.fromJson(e))
            .toList();

        recommendations.sort((a, b) => a.completedAt.compareTo(b.completedAt));

        recommendation = recommendations.last;
      }
      _emit(recommendation);
      return recommendation;
    } catch (e) {
      _emit(Recommendation());
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      rethrow;
    }
  }

  @override
  Future createActivities(String recommendationId, String customerId) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/$recommendationId',
        body: {
          'customerId': customerId,
        },
      );

      if (response.statusCode == 404) {
        throw NotFoundException(errorCode: response.statusCode);
      }

      return;
    } catch (e) {
      _emit(Recommendation());
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      rethrow;
    }
  }

  @override
  Stream<Recommendation> get recommendationStream =>
      _recommendationStream.stream;

  void _emit(Recommendation recommendation) {
    _recommendationStream.sink.add(recommendation);
  }

  @override
  Future updateCustomerRecommendation(
      String recommendationId, String customerId) async {
    try {
      final response =
          await _apiClient.put('$_basePath/$recommendationId', body: {
        'customerId': customerId,
      });
      if (response.statusCode != 200) {
        throw UpdateRecommendationException('Error updating recommendation');
      }
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
