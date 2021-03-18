import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/auth/refresh/i_refresh_token_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class RefreshTokenServiceImpl implements RefreshTokenService {
  final SessionManager _sessionManager;
  final String host;
  final String source;
  final String sourceService;
  final Client _client;
  final Logger _logger = registry<Logger>();
  final String _apiKey;

  RefreshTokenServiceImpl(
    String apiKey,
    Client client,
    SessionManager sessionManager,
    String host,
    String source,
    String sourceService,
  )   : _apiKey = apiKey,
        _client = client,
        _sessionManager = sessionManager ?? registry<SessionManager>(),
        host = host,
        source = source,
        sourceService = sourceService;

  @override
  Future<void> refreshGigyaToken() async {
    try {
      final user = await _sessionManager.getUser();

      if (user == null || user.gigyaUser == null) {
        throw Exception('Token not found');
      }

      final uri = Uri(
        scheme: 'https',
        host: host,
        path: '/iam/v1/iam/jwt',
      );

      final headers = {
        'Content-type': 'application/json',
        'x-apikey': _apiKey,
      };

      final transId = registry.call<String>(name: RegistryConfig.TRANS_ID);
      final seconds = 300;

      final body = {
        'uid': user.gigyaUser.uid,
        'uidSignature': user.gigyaUser.uidSignature,
        'uidSignatureTimestamp': int.parse(user.gigyaUser.uidTimestamp),
        'expiration': seconds,
        'source': source,
        'sourceService': sourceService,
        'transId': transId,
      };

      _logger.d({
        'message': 'NETWORK REQUEST DATA',
        'url': '${uri.toString()}',
        'headers': '${headers}',
        'body': '${body}',
        'method': 'POST',
      });

      final response = await _client.post(
        uri.toString(),
        headers: headers,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body);

      _logger.d({
        'message': 'NETWORK RESPONSE DATA',
        'url': '${uri.toString()}',
        'headers': '${response.headers}',
        'body': '${json}',
        'method': 'POST'
      });

      final token = json['id_token'];

      if (token == null) {
        throw Exception('Token was null in response');
      }

      await _sessionManager.setGigyaToken(token);
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      throw Exception('Error refreshing Gigya token');
    }
  }

  @override
  Future<void> authenticate() async {
    try {
      final gigyaToken = await _sessionManager.getGigyaToken();
      final transId = registry.call<String>(name: RegistryConfig.TRANS_ID);

      if (gigyaToken == null) {
        throw Exception('Gigya token not found');
      }

      final uri = Uri(
        scheme: 'https',
        host: host,
        path: '/iam/v1/iam/authenticate',
      );

      final headers = {
        'Content-type': 'application/json',
        'x-apikey': _apiKey,
      };

      final body = {
        'sourceService': sourceService,
        'transId': transId,
        'jwtToken': gigyaToken
      };

      _logger.d({
        'message': 'NETWORK REQUEST DATA',
        'url': '${uri.toString()}',
        'headers': '${headers}',
        'body': '${body}',
        'method': 'POST',
      });

      final response = await _client.post(
        uri.toString(),
        headers: headers,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body);

      _logger.d({
        'message': 'NETWORK RESPONSE DATA',
        'url': '${uri.toString()}',
        'headers': '${response.headers}',
        'body': '${json}',
        'method': 'POST'
      });

      final token = json['jwtToken'];

      if (token == null) {
        throw Exception('Scotts token was null in response');
      }

      await _sessionManager.setScottsToken(token);
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      throw Exception('Error refreshing Scotts token');
    }
  }

  @override
  Future<void> refresh() async {
    try {
      await refreshGigyaToken();
      await authenticate();
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      throw Exception('Error refreshing token');
    }
  }
}
