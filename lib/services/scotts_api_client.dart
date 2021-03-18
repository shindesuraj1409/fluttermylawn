import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/auth/refresh/i_refresh_token_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/scotts/firebase_performance_interceptor.dart';
import 'package:my_lawn/services/scotts/refresh_token_retry_policy.dart';
import 'package:my_lawn/services/scotts/scotts_api_interceptor.dart';

abstract class ScottsApiClient {
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, String> headers,
  });

  Future<http.Response> post(
    String path, {
    Map<String, String> headers,
    Map<String, dynamic> body,
    Encoding encoding,
  });

  Future<http.Response> put(
    String path, {
    Map<String, String> headers,
    Map<String, dynamic> body,
    Encoding encoding,
  });

  Future<http.Response> delete(
    String path, {
    Map<String, String> headers,
    Encoding encoding,
  });

  Future<StreamedResponse> uploadFile(String path, String imagePath,
      {String imageName});

  String prepareImagePath(String path);
  Future<Map<String, String>> prepareImageHeader();

  void close();
}

class ScottsApiClientImpl implements ScottsApiClient {
  final http.Client _client;
  final String apiKey;
  final String host;
  final String sourceService;

  factory ScottsApiClientImpl(
    String apiKey,
    SessionManager sessionManager,
    String host,
    String source,
    String sourceService,
    RefreshTokenService refreshTokenService,
  ) {
    final client = HttpClientWithInterceptor.build(
      interceptors: [
        ScottsApiInterceptor(
          apiKey: apiKey,
          source: source,
          sourceService: sourceService,
          sessionManager: sessionManager,
        ),
        FirebasePerformanceInterceptor()
      ],
      retryPolicy: RefreshTokenRetryPolicy(
        refreshTokenService:
            refreshTokenService ?? registry<RefreshTokenService>(),
      ),
    );

    return ScottsApiClientImpl._(
      client,
      apiKey,
      host: host,
    );
  }

  ScottsApiClientImpl._(
    this._client,
    this.apiKey, {
    this.host,
    this.sourceService = 'LS',
  });

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, String> headers,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: path,
      queryParameters: queryParameters,
    );
    return _client.get(uri.toString(), headers: headers);
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
    final requestBody = json.encode(body);

    return _client.post(
      uri.toString(),
      headers: headers,
      body: requestBody,
    );
  }

  @override
  Future<http.Response> put(
    String path, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    Encoding encoding,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: path,
    );
    final requestBody = json.encode(body);

    return _client.put(
      uri.toString(),
      headers: headers,
      body: requestBody,
    );
  }

  @override
  Future<http.Response> delete(
    String path, {
    Map<String, String> headers = const {},
    Encoding encoding,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: path,
    );

    return _client.delete(
      uri.toString(),
      headers: headers,
    );
  }

  @override
  Future<StreamedResponse> uploadFile(String path, String filePath,
      {String imageName}) async {
    final uri = Uri(
      scheme: 'https',
      host: host,
      path: path,
    );

    final request = http.MultipartRequest('POST', uri);

    var file;
    if (imageName != null) {
      file = await http.MultipartFile.fromPath('file', filePath,
          filename: imageName);
    } else {
      file = null;
    }

    request.files.add(file);

    final token = await registry<SessionManager>().getScottsToken();
    final transId = registry.call<String>(name: RegistryConfig.TRANS_ID);

    request.headers['Authorization'] = token;
    request.headers['x-apikey'] = apiKey;

    request.fields['source'] = sourceService;
    request.fields['sourceService'] = sourceService;
    request.fields['transId'] = transId;

    return _client.send(request);
  }

  @override
  Future<Map<String, String>> prepareImageHeader() async {
    final token = await registry<SessionManager>().getScottsToken();
    final headers = <String, String>{};

    headers['Authorization'] = token;
    headers['x-apikey'] = apiKey;
    return headers;
  }

  @override
  String prepareImagePath(String path) {
    final buffer = StringBuffer();

    final transId = registry.call<String>(name: RegistryConfig.TRANS_ID);
    buffer.write('https://');
    buffer.write(host);
    buffer.write(path);
    buffer.write('?transId=$transId');
    buffer.write('&source=$sourceService');
    buffer.write('&sourceService=$sourceService');

    return buffer.toString();
  }
}
