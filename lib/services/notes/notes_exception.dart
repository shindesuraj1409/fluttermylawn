class NotesException implements Exception {
  NotesException({this.message, this.statusCode});

  final String message;
  final int statusCode;
}
