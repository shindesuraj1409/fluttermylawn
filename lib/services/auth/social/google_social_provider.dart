import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_lawn/services/auth/social/i_social_provider.dart';
import 'package:pedantic/pedantic.dart';

class GoogleSocialProvider extends SocialProvider {
  final GoogleSignIn _googleSignIn;
  String _email;

  GoogleSocialProvider() : _googleSignIn = GoogleSignIn.standard();

  @override
  Future<Map<String, dynamic>> signIn() async {
    final account = await _googleSignIn.signIn();

    if (account == null) return null;
    _email = account.email;

    final authentication = await account.authentication;

    unawaited(_googleSignIn.signOut());

    return {
      'google': {
        'authToken': '${authentication.accessToken}',
      },
    };
  }

  @override
  String get email => _email;
}
