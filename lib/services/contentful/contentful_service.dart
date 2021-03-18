import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';

class HttpClient extends http.BaseClient {
  factory HttpClient(String accessToken) {
    final client = http.Client();
    return HttpClient._internal(client, accessToken);
  }
  HttpClient._internal(this._inner, this.accessToken);

  final http.Client _inner;
  final String accessToken;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    return _inner.send(request);
  }
}

class ContentfulServiceImpl implements ContentfulService {
  final String accessToken;

  factory ContentfulServiceImpl(
    String accessToken, {
    String environment = 'development',
    String spaceId = 'i52w2h2r1atp',
    String host = 'cdn.contentful.com',
  }) {
    final client = HttpClient(accessToken);
    return ContentfulServiceImpl._(
      accessToken,
      client,
      spaceId,
      environment,
      host: host,
    );
  }

  ContentfulServiceImpl._(
    this.accessToken,
    this._client,
    this.spaceId,
    this.environment, {
    this.host,
  });

  final HttpClient _client;
  final String spaceId;
  final String host;
  final String environment;

  Uri _uri(String path, {Map<String, dynamic> params}) => Uri(
        scheme: 'https',
        host: host,
        path: '/spaces/$spaceId/environments/$environment$path',
        queryParameters: params,
      );

  void close() {
    _client.close();
  }

  @override
  Future<Map<String, dynamic>> getEntry(
    String id, {
    Map<String, dynamic> params,
  }) async {
    final response = await _client.get(_uri('/entries/$id', params: params));
    if (response.statusCode != 200) {
      throw getRESTException(response.statusCode);
    }

    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<Map<String, dynamic>> getEntries({
    Map<String, dynamic> params,
  }) async {
    final response = await _client.get(_uri(
      '/entries',
      params: params,
    ));
    if (response.statusCode != 200) {
      throw getRESTException(response.statusCode);
    }
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<Map<String, dynamic>> getAsset(String id) async {
    final response = await _client.get(_uri('/assets/$id'));
    if (response.statusCode != 200) {
      throw getRESTException(response.statusCode);
    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
}
