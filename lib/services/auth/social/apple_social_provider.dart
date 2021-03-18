import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_lawn/services/auth/social/i_social_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSocialProvider extends SocialProvider {
  String _email;

  @override
  String get email => _email;

  @override
  Future<Map<String, dynamic>> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential == null || credential.authorizationCode == null) {
        return null;
      }

      _email = credential.email ??
          JwtDecoder.decode(credential.identityToken)['email'];

      return {
        'apple': {
          'idToken': credential.identityToken,
          'code': credential.authorizationCode,
          'lastName': credential.familyName,
          'firstName': credential.givenName
        }
      };
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      return null;
    }
  }
}
