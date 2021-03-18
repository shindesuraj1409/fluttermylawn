class CancelSubscriptionException implements Exception {
  final String errorMessage;
  CancelSubscriptionException({this.errorMessage});
}

class PreviewRefundException implements Exception {
  final String errorMessage;
  PreviewRefundException({this.errorMessage});
}
