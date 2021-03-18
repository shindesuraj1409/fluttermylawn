import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class GigyaApiClient {
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, String> headers,
  });

  Future<http.Response> post(
    String path, {
    Map<String, String> headers,
    Map<String, String> body,
    Encoding encoding,
  });

  void close();

  String get gigyaApiKey;
}
