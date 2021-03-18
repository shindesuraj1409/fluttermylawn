abstract class SocialProvider {
  String get email;
  Future<Map<String, dynamic>> signIn();
}
