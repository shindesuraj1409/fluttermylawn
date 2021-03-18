import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class RecurlyApiClient {
  Future<http.Response> post(
    String path, {
    Map<String, String> headers,
    Map<String, dynamic> body,
    Encoding encoding,
  });
  void close();
}
