import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';

class LoggerHttpClient extends BaseClient {
  final Client _client;
  final JsonEncoder _encoder = JsonEncoder.withIndent('   ');
  final JsonDecoder _decoder = JsonDecoder();

  LoggerHttpClient(this._client);

  @override
  void close() {
    _client.close();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if (request is Request) {
      final prettyBody = _encoder.convert(_decoder.convert(request.body));

      final _res = '''
      message: 'NETWORK REQUEST DATA',
      request: ${request.toString()},
      params: ${request.headers.toString()},
      body: $prettyBody
      ''';

      registry<Logger>().d(_res.toString());
    }

    return _client.send(request).then((response) async {
      final responseString = await response.stream.bytesToString();

      final prettyPrint = _encoder.convert(_decoder.convert(responseString));
      final _res = '''
      message: 'NETWORK RESPONSE DATA',
      request: ${response.request.toString()},
      statusCode: ${response.statusCode} - ${response.reasonPhrase}
      responseString: $prettyPrint,
      ''';
      registry<Logger>().d(_res.toString());

      return StreamedResponse(ByteStream.fromBytes(utf8.encode(responseString)),
          response.statusCode,
          headers: response.headers,
          reasonPhrase: response.reasonPhrase,
          persistentConnection: response.persistentConnection,
          contentLength: response.contentLength,
          isRedirect: response.isRedirect,
          request: response.request);
    });
  }
}
