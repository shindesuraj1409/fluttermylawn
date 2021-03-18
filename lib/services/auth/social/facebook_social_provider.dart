import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:my_lawn/services/auth/social/i_social_provider.dart';
import 'package:pedantic/pedantic.dart';

class FacebookSocialProvider extends SocialProvider {
  final _facebookLogin;
  final client;

  String _email;

  FacebookSocialProvider()
      : _facebookLogin = FacebookLogin(),
        client = Client();

  @override
  Future<Map<String, dynamic>> signIn() async {
    try {
      // Added for iOS bug see: https://github.com/facebook/facebook-swift-sdk/issues/215
      await _facebookLogin.logOut();
      final login = await _facebookLogin.logIn(['email']);
      Map<String, dynamic> result;

      switch (login.status) {
        case FacebookLoginStatus.loggedIn:
          final map = {
            'facebook': {
              'authToken': login.accessToken.token,
            }
          };

          final graphResponse = await client.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${login.accessToken.token}');
          final profile = jsonDecode(graphResponse.body);

          _email = profile['email'];
          result = map;
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }

      return result;
    } catch (e) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current),
      );
      throw Exception('Error logging in with Facebook');
    }
  }

  @override
  String get email => _email;
}
