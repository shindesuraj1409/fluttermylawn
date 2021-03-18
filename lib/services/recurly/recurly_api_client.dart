import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:my_lawn/services/recurly/i_recurly_api_client.dart';
import 'package:my_lawn/services/recurly/recurly_api_interceptor.dart';

class RecurlyClientImpl implements RecurlyApiClient {
  final String host;
  final http.Client _client;
  final String apiKey;

  factory RecurlyClientImpl(
    String apiKey, {
    String host = 'api.recurly.com',
  }) {
    final client = HttpClientWithInterceptor.build(
      interceptors: [
        RecurlyApiInterceptor(),
      ],
      requestTimeout: Duration(minutes: 1),
    );

    return RecurlyClientImpl._(
      client,
      apiKey,
      host: host,
    );
  }

  RecurlyClientImpl._(
    this._client,
    this.apiKey, {
    this.host,
  });

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> post(
    String path, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body,
    Encoding encoding,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: path,
    );

    final requestBody = json.encode({
      ...body,
      'key': apiKey,
    });

    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...headers,
    };

    return _client.post(
      uri.toString(),
      headers: requestHeaders,
      body: requestBody,
    );
  }
}
