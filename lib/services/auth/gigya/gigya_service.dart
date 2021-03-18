import 'dart:convert';

import 'package:http_interceptor/http_methods.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_auth_utils.dart';
import 'package:my_lawn/services/auth/gigya/gigya_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/gigya_request_bodies.dart';
import 'package:my_lawn/services/auth/gigya/gigya_responses.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_api_client.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class GigyaServiceImpl extends GigyaService {
  final GigyaApiClient _apiClient;
  final SessionManager _sessionManager;

  GigyaServiceImpl()
      : _apiClient = registry<GigyaApiClient>(),
        _sessionManager = registry.call<SessionManager>();

  Future<String> _initRegistration() async {
    try {
      final response = await _apiClient.post('/accounts.initRegistration');
      final initRegistrationResponse =
          InitRegistrationResponse.fromJson(json.decode(response.body));

      if (initRegistrationResponse.statusCode == 200) {
        return initRegistrationResponse.regToken;
      } else {
        throw GigyaErrorException(
          initRegistrationResponse.errorCode,
          errorMessage: initRegistrationResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GigyaAccountResponse> _finalizeRegistration(String regToken) async {
    try {
      final response = await _apiClient.post(
        '/accounts.finalizeRegistration',
        body: {
          'regToken': regToken,
          'include': 'profile,data,id_token',
          'targetEnv': 'mobile',
        },
      );

      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      if (gigyaAccountResponse.errorCode == 0) {
        await _saveGigyaCredentials(gigyaAccountResponse);
        return gigyaAccountResponse;
      } else {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    try {
      final response = await _apiClient.get(
        '/accounts.isAvailableLoginID',
        queryParameters: {
          'loginID': email,
        },
      );

      final emailAvailableResponse =
          EmailAvailableResponse.fromJson(json.decode(response.body));

      if (emailAvailableResponse.errorCode == 0) {
        return emailAvailableResponse.isAvailable;
      } else {
        throw GigyaErrorException(
          emailAvailableResponse.errorCode,
          errorMessage: emailAvailableResponse.statusReason,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> siteRegister(
    String email,
    String password,
    bool subscribeToNewsletter,
  ) async {
    try {
      final regToken = await _initRegistration();

      final siteRegisterRequest = SiteRegisterRequest.create(
        email,
        password,
        regToken,
        subscribeToNewsletter,
      );
      final response = await _apiClient.post(
        '/accounts.register',
        body: siteRegisterRequest.toJson(),
      );
      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      if (gigyaAccountResponse.statusCode == 200) {
        // Sometimes Gigya does not return the id_token in the register response.
        // If we do not have an id_token, call the login endpoint and request the id_token.
        if (gigyaAccountResponse.idToken == null ||
            gigyaAccountResponse.UID == null) {
          return await siteLogin(email, password);
        }
        _saveGigyaCredentials(gigyaAccountResponse);
        return gigyaAccountResponse;
      } else {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> siteLogin(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        '/accounts.login',
        body: SiteLoginRequest.create(email, password).toJson(),
      );
      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      if (gigyaAccountResponse.statusCode == 200 &&
          gigyaAccountResponse.idToken != null &&
          gigyaAccountResponse.UID != null) {
        _saveGigyaCredentials(gigyaAccountResponse);
        return gigyaAccountResponse;
      } else {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> socialLogin(
    String email,
    Map<String, dynamic> providerSessions,
  ) async {
    try {
      final requestBody = SocialLoginRequest.create(providerSessions).toJson();

      final response = await _apiClient.post(
        '/accounts.notifySocialLogin',
        body: requestBody,
      );

      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      await _saveGigyaCredentials(gigyaAccountResponse);

      switch (gigyaAccountResponse.errorCode) {
        case 0:
          final accountResponse = await getAccountInfo(
            gigyaAccountResponse.sessionToken,
            gigyaAccountResponse.sessionSecret,
          );
          await _saveGigyaCredentials(accountResponse);
          return accountResponse;
        case ERROR_PENDING_REGISTRATION:
          throw PendingRegistrationException(
            gigyaAccountResponse.statusReason,
            gigyaAccountResponse.regToken,
            email,
            gigyaAccountResponse.errorCode,
          );
        case ERROR_LOGIN_IDENTIFIER_EXISTS:
          throw LinkAccountsException(
            gigyaAccountResponse.statusReason,
            gigyaAccountResponse.errorCode,
            email,
          );
        default:
          throw GigyaErrorException(gigyaAccountResponse.errorCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> completePendingRegistration(
    String regToken,
    bool subscribeToNewsletter,
  ) async {
    try {
      final response = await _apiClient.post(
        '/accounts.setAccountInfo',
        body: {
          'regToken': regToken,
          'data': json.encode(GigyaCustomData(subscribeToNewsletter).toJson()),
          'targetEnv': 'mobile',
        },
      );
      final pendingResponse =
          BaseGigyaResponse.fromJson(json.decode(response.body));

      if (pendingResponse.errorCode != 0) {
        throw GigyaErrorException(pendingResponse.errorCode);
      }

      return _finalizeRegistration(regToken);
    } catch (e) {
      rethrow;
    }
  }

  void _saveGigyaCredentials(GigyaAccountResponse response) async {
    if (response.idToken != null) {
      await _sessionManager.setGigyaToken(response.idToken);
    }

    await _sessionManager.setUser(
      User(
        firstName: response.firstName,
        lastName: response.lastName,
        email: response.email,
        isEmailVerified: response.isVerified,
        gigyaUser: response.toGigyaUser(),
      ),
    );
  }

  @override
  Future<GigyaAccountResponse> getAccountInfo(
      String oauthToken, String sessionSecret) async {
    try {
      final path = '/accounts.getAccountInfo';
      final apiKey = _apiClient.gigyaApiKey;

      final body = GetAccountRequest.create(apiKey, oauthToken).toJson();

      GigyaAuthUtils.addAuthenticationParameters(
        sessionSecret,
        Method.POST,
        path,
        body,
      );

      final response = await _apiClient.post(path, body: body);

      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      if (gigyaAccountResponse.statusCode == 200 &&
          gigyaAccountResponse.UID != null) {
        _saveGigyaCredentials(gigyaAccountResponse);
        return gigyaAccountResponse;
      } else {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      final path = '/accounts.resetPassword';

      final response = await _apiClient.post(path, body: {'loginId': email});

      final baseGigyaResponse =
          BaseGigyaResponse.fromJson(jsonDecode(response.body));

      if (baseGigyaResponse.statusCode == 200 &&
          baseGigyaResponse.errorCode == 0) {
        return true;
      } else {
        throw GigyaErrorException(
          baseGigyaResponse.errorCode,
          errorMessage: baseGigyaResponse.errorMessage,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> setAccountInfo({
    String firstName,
    String lastName,
    String currentPassword,
    String newPassword,
    Map<String, dynamic> data,
  }) async {
    try {
      final path = '/accounts.setAccountInfo';
      final apiKey = _apiClient.gigyaApiKey;
      final user = await _sessionManager.getUser();

      final body = SetAccountRequest.create(
        apiKey,
        user.gigyaUser.sessionToken,
        firstName,
        lastName,
        currentPassword,
        newPassword,
        data,
      ).toJson();

      GigyaAuthUtils.addAuthenticationParameters(
        user.gigyaUser.sessionSecret,
        Method.POST,
        path,
        body,
      );

      final response = await _apiClient.post(
        path,
        body: body,
      );

      if (response.statusCode != 200) {
        throw GigyaErrorException(response.statusCode);
      }

      final gigyaAccountResponse =
          GigyaAccountResponse.fromJson(json.decode(response.body));

      if (gigyaAccountResponse.errorCode != 0) {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorDetails,
        );
      }

      return gigyaAccountResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GigyaAccountResponse> linkAccounts(
      String email, String password) async {
    try {
      final user = await _sessionManager.getUser();

      final body = {
        'targetEnv': 'mobile',
        'loginID': email,
        'password': password,
        'regToken': user.gigyaUser.regToken,
        'include': 'profile,data'
      };

      final response =
          await _apiClient.post('/accounts.linkAccounts', body: body);

      final json = jsonDecode(response.body);

      final gigyaAccountResponse = GigyaAccountResponse.fromJson(json);

      await _saveGigyaCredentials(gigyaAccountResponse);

      if (gigyaAccountResponse.errorCode == 0) {
        return gigyaAccountResponse;
      } else {
        throw GigyaErrorException(
          gigyaAccountResponse.errorCode,
          errorMessage: gigyaAccountResponse.errorDetails,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
