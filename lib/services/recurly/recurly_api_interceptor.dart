import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';

class RecurlyApiInterceptor implements InterceptorContract {
  final Logger _logger = registry<Logger>();

  RecurlyApiInterceptor();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    _logger.d({
      'message': 'NETWORK REQUEST DATA',
      'url': '${data.url}',
      'headers': '${data.headers}',
      if (data.method == Method.POST || data.method == Method.PUT)
        'body': '${json.decode(data.body)}',
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
      'body': '${json.decode(data.body)}',
      'statusCode': '${data.statusCode}',
      'method': '${data.method}',
    });
    return data;
  }
}
