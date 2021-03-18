import 'dart:collection';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:http_interceptor/http_methods.dart';

class GigyaAuthUtils {
  static void addAuthenticationParameters(String sessionSecret,
      Method httpMethod, String url, Map<String, dynamic> params) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    params['timestamp'] = '${(currentTime / 1000).floor()}';
    params['nonce'] = 'nonce1-$currentTime';
    params['sig'] = getSignature(sessionSecret, httpMethod, url, params);
  }

  static String getSignature(String secret, Method httpMethod, String url,
      Map<String, dynamic> params) {
    final protocol = 'https';
    final host = 'accounts.us1.gigya.com';
    final method = httpMethod == Method.GET ? 'GET' : 'POST';

    final requestParams = SplayTreeMap<String, dynamic>.from(params);
    final normalizedUrl = '$protocol://$host$url';
    final encodedParams = encodeMap(requestParams);

    final baseSignature =
        '$method&${Uri.encodeComponent(normalizedUrl)}&${Uri.encodeComponent(encodedParams)}';

    return encodeSignature(baseSignature, secret);
  }

  static String encodeSignature(String baseSignature, String secret) {
    final keyBytes = base64Decode(secret);
    final textData = utf8.encoder.convert(baseSignature);

    final signingKey = SecretKey(keyBytes);
    final hmacSink = Hmac(sha1).newSink(secretKey: signingKey);
    hmacSink.add(textData);
    hmacSink.close();
    final mac = hmacSink.mac;

    return base64Encode(mac.bytes);
  }

  static String encodeMap(Map data) {
    return data.keys
        .map((key) => '$key=${Uri.encodeQueryComponent(data[key].toString())}')
        .join('&');
  }
}
