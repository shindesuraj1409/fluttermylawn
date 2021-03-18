import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_lawn/services/auth/gigya/i_gigya_api_client.dart';

class GigyaApiClientImpl implements GigyaApiClient {
  final String _host;
  final http.Client _client;

  final Map<String, String> defaultQueryParameters;

  final String _gigyaApiKey;

  GigyaApiClientImpl(
    String gigyaApiKey, {
    String host = 'accounts.us1.gigya.com',
  })  : _host = host,
        _gigyaApiKey = gigyaApiKey,
        defaultQueryParameters = {'apiKey': gigyaApiKey},
        _client = http.Client();

  @override
  void close() {
    _client.close();
  }

  @override
  String get gigyaApiKey => _gigyaApiKey;

  @override
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, String> headers,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: _host,
      path: path,
      queryParameters: <String, String>{
            ...defaultQueryParameters,
            ...queryParameters
          } ??
          defaultQueryParameters,
    );
    return _client.get(uri.toString(), headers: headers);
  }

  @override
  Future<http.Response> post(
    String path, {
    Map<String, String> headers = const {},
    Map<String, String> body,
    Encoding encoding,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: _host,
      path: path,
      queryParameters: defaultQueryParameters,
    );

    final defaultHeaders = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: 'application/json'
    };

    final requestHeaders = {...headers, ...defaultHeaders};

    return _client.post(
      uri.toString(),
      headers: requestHeaders,
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );
  }
}
