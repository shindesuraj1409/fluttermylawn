class CreateLawnProfileException implements Exception {
  final String reason;
  CreateLawnProfileException(this.reason);
}

class UpdateRecommendationException implements Exception {
  final String reason;
  UpdateRecommendationException(this.reason);
}
