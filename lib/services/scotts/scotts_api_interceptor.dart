import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class ScottsApiInterceptor implements InterceptorContract {
  final String _apiKey;

  final String _source;
  final String _sourceService;
  final SessionManager _sessionManager;
  final Logger _logger = registry<Logger>();

  ScottsApiInterceptor({
    String apiKey,
    String source = 'scottsprogram.com',
    String sourceService = 'LS',
    SessionManager sessionManager,
  })  : _apiKey = apiKey,
        _source = source,
        _sourceService = sourceService,
        _sessionManager = sessionManager;

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    if (_apiKey != null) {
      data.headers['x-apikey'] = _apiKey;
    }

    if (data.toHttpRequest().url.path.contains('customer/login') ||
        data.toHttpRequest().url.path.contains('customer/register')) {
      // Login/Register endpoints still require the gigya jwt token
      data.headers['Authorization'] =
          await _sessionManager.getGigyaToken() ?? '';
    } else {
      data.headers['Authorization'] =
          await _sessionManager.getScottsToken() ?? '';
    }

    final transId = registry.call<String>(name: 'trans_id');

    if (data.method == Method.GET || data.method == Method.DELETE) {
      data.params['source'] = _source;
      data.params['sourceService'] = _sourceService;
      data.params['transId'] = transId;
    }

    if (data.method == Method.POST ||
        data.method == Method.PUT ||
        data.method == Method.DELETE) {
      data.headers['Content-Type'] = 'application/json';
      data.headers['Accept'] = 'application/json';

      final body = data.body.isNotEmpty ? json.decode(data.body) : {};
      body['source'] = _source;
      body['sourceService'] = _sourceService;
      body['transId'] = transId;

      data.body = json.encode(body);
    }
    _logger.d({
      'message': 'NETWORK REQUEST DATA',
      'url': '${data.url}',
      'headers': '${data.headers}',
      if (data.method == Method.POST || data.method == Method.PUT)
        'body': '${data.body}',
      'params': '${data.params}',
      'method': '${data.method}',
    });
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    _logger.d({
      'message': 'NETWORK RESPONSE DATA',
      'url': '${data.url}',
      'headers': '${data.headers}',
      'body': '${data.body}',
      'statusCode': '${data.statusCode}',
      'method': '${data.method}',
    });
    return data;
  }
}
