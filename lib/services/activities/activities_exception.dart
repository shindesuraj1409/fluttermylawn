class ActivitiesException implements Exception {
  ActivitiesException({this.message, this.statusCode});

  final String message;
  final int statusCode;
}
