import 'dart:io';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class FirebasePerformanceInterceptor implements InterceptorContract {
  final _map = <int, HttpMetric>{};

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      final metric = FirebasePerformance.instance
          .newHttpMetric(data.url, data.method.asHttpMethod());
      final requestKey = data.toHttpRequest().url.hashCode;
      _map[requestKey] = metric;
      metric.requestPayloadSize = data.toHttpRequest().contentLength;
      await metric.start();
    } catch (_) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    try {
      final requestKey = data.toHttpResponse().request.url.hashCode;
      final metric = _map[requestKey];
      metric.responsePayloadSize = data.contentLength;
      metric.httpResponseCode = data.statusCode;
      metric.responseContentType = data.headers[HttpHeaders.contentTypeHeader];
      await metric.stop();
      _map.remove(requestKey);
    } catch (_) {}
    return data;
  }
}

extension HttpMethodExtension on Method {
  HttpMethod asHttpMethod() {
    if (this == null) return null;

    switch (methodToString(this)) {
      case 'HEAD':
        return HttpMethod.Head;
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'DELETE':
        return HttpMethod.Delete;
      default:
        return null;
    }
  }
}
