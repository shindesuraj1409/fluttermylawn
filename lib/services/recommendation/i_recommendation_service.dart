import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';

abstract class RecommendationService {
  Stream<Recommendation> get recommendationStream;

  Future<Recommendation> submitQuiz(QuizSubmitRequest quizSubmitRequest);

  Future<Recommendation> getRecommendation(String recommendationId);
  Future<Recommendation> regenerateRecommendation(String recommendationId);

  Future createActivities(String recommendationId, String customerId);
  Future<Recommendation> getRecommendationByCustomer(String customerId);
  Future updateCustomerRecommendation(
      String recommendationId, String customerId);
}

class QuizSubmitRequest {
  final String databaseVersion = 'v1';

  // Quiz Info
  final String lawnThickness;
  final String lawnColor;
  final String lawnWeeds;

  final String lawnSpreader;

  final int lawnArea;
  final String zipCode;
  final String lawnZone;

  final String grassType;
  final String customerId;

  QuizSubmitRequest.create(Map<QuestionType, String> answers, String customerId)
      : lawnColor = answers[QuestionType.lawnColor],
        lawnThickness = answers[QuestionType.lawnThickness],
        lawnWeeds = answers[QuestionType.lawnWeeds],
        lawnSpreader = answers[QuestionType.lawnSpreader],
        zipCode = answers[QuestionType.zipCode],
        lawnArea = int.parse(answers[QuestionType.lawnArea]),
        lawnZone = answers[QuestionType.lawnZone],
        grassType = answers[QuestionType.grassType],
        customerId = customerId;

  Map<String, dynamic> toJson() {
    final jsonMap = {
      'databaseVersion': databaseVersion,
      'lawnThickness': lawnThickness,
      'lawnColor': lawnColor,
      'lawnWeeds': lawnWeeds,
      'lawnSpreader': lawnSpreader,
      'lawnArea': lawnArea,
      'zipCode': zipCode,
      'lawnZone': lawnZone,
      'grassType': grassType,
    };

    if (customerId != null) {
      jsonMap['customerId'] = customerId;
    }

    return jsonMap;
  }
}
