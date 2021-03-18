import 'package:my_lawn/services/auth/gigya/gigya_responses.dart';

abstract class GigyaService {
  Future<bool> isEmailAvailable(String email);

  Future<GigyaAccountResponse> siteRegister(
    String email,
    String password,
    bool subscribeToNewsletter,
  );

  Future<GigyaAccountResponse> siteLogin(
    String email,
    String password,
  );

  Future<GigyaAccountResponse> socialLogin(
    String email,
    Map<String, dynamic> providerSessions,
  );

  Future<GigyaAccountResponse> getAccountInfo(
    String oauthToken,
    String sessionSecret,
  );

  Future<GigyaAccountResponse> setAccountInfo({
    String firstName,
    String lastName,
    String newPassword,
    String currentPassword,
    Map<String, dynamic> data,
  });

  Future<GigyaAccountResponse> completePendingRegistration(
    String regToken,
    bool subscribeToNewsletter,
  );

  Future<GigyaAccountResponse> linkAccounts(String email, String password);

  Future<bool> resetPassword(String email);
}
