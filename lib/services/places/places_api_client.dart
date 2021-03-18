import 'dart:async';

import 'package:http/http.dart' as http;

abstract class PlacesApiClient {
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, String> headers,
  });

  void close();
}

class PlacesApiClientImpl implements PlacesApiClient {
  final http.Client _client;
  final String _apiKey;
  final String _host;

  factory PlacesApiClientImpl(
    http.Client client,
    String apiKey, {
    String host = 'maps.googleapis.com',
  }) {
    return PlacesApiClientImpl._(
      client,
      apiKey,
      host,
    );
  }

  PlacesApiClientImpl._(
    this._client,
    this._apiKey,
    this._host,
  );

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, String> headers = const {},
  }) {
    final appendedQueryParameters = {
      'key': _apiKey,
      ...queryParameters,
    };

    final uri = Uri(
      scheme: 'https',
      host: _host,
      path: path,
      queryParameters: appendedQueryParameters,
    );
    return _client.get(uri.toString(), headers: headers);
  }
}
