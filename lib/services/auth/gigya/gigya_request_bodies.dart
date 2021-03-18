import 'dart:convert';

class SiteRegisterRequest {
  final String email;
  final String password;
  final String regToken;
  final String include;
  final String targetEnv;
  final bool finalizeRegistration;
  final bool subscribeToNewsletter;

  SiteRegisterRequest.create(
    String email,
    String password,
    String regToken,
    bool subscribeToNewsletter,
  )   : email = email,
        password = password,
        regToken = regToken,
        subscribeToNewsletter = subscribeToNewsletter,
        include = 'id_token',
        targetEnv = 'mobile',
        finalizeRegistration = true;

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
      'regToken': regToken,
      'include': include,
      'finalizeRegistration': finalizeRegistration.toString(),
      'targetEnv': targetEnv,
      'data': json.encode(GigyaCustomData(subscribeToNewsletter).toJson()),
      'profile': json.encode(GigyaProfile().toJson()),
    };
  }
}

class SocialLoginRequest {
  final Map<String, dynamic> providerSessions;
  final String loginMode;

  SocialLoginRequest.create(
    Map<String, dynamic> providerSessions,
  )   : providerSessions = providerSessions,
        loginMode = 'standard';

  Map<String, String> toJson() {
    return {
      'providerSessions': jsonEncode(providerSessions),
      'loginMode': loginMode,
    };
  }
}

class SiteLoginRequest {
  final String loginId;
  final String password;
  final String include;
  final String targetEnv;

  SiteLoginRequest.create(String email, String password)
      : loginId = email,
        password = password,
        targetEnv = 'mobile',
        include = 'profile,data,id_token';

  Map<String, String> toJson() {
    return {
      'loginId': loginId,
      'password': password,
      'include': include,
      'targetEnv': targetEnv,
    };
  }
}

class GetAccountRequest {
  final String apiKey;
  final String oauthToken;

  GetAccountRequest.create(String apiKey, String oauthToken)
      : apiKey = apiKey,
        oauthToken = oauthToken;

  Map<String, String> toJson() {
    final request = {
      'apiKey': apiKey,
      'sdk': 'Android_4.2.3',
      'targetEnv': 'mobile',
      'oauth_token': oauthToken,
    };
    return request;
  }
}

class SetAccountRequest {
  final String apiKey;
  final String oauthToken;
  final String firstName;
  final String lastName;
  final String password;
  final String newPassword;
  final Map<String, dynamic> data;

  SetAccountRequest.create(
    String apiKey,
    String oauthToken,
    String firstName,
    String lastName,
    String password,
    String newPassword,
    Map<String, dynamic> data,
  )   : apiKey = apiKey,
        oauthToken = oauthToken,
        firstName = firstName,
        lastName = lastName,
        password = password,
        newPassword = newPassword,
        data = data;

  Map<String, String> toJson() {
    final request = {
      'apiKey': apiKey,
      'sdk': 'Android_4.2.3',
      'targetEnv': 'mobile',
      'oauth_token': oauthToken,
    };

    final profileMap = {};
    if (firstName != null) {
      profileMap['firstName'] = firstName;
    }
    if (lastName != null) {
      profileMap['lastName'] = lastName;
    }
    if (profileMap.isNotEmpty) {
      request['profile'] = jsonEncode(profileMap);
    }

    if (newPassword != null) {
      request['newPassword'] = newPassword;
      request['password'] = password;
    }

    if (data != null) {
      request['data'] = jsonEncode(data);
    }

    return request;
  }
}

class GigyaCustomData {
  final bool subscribeToNewsletter;
  final String acquisitionMethod = 'My Lawn';
  final String acquisitionSource = 'Scotts';

  GigyaCustomData(this.subscribeToNewsletter);

  Map<String, dynamic> toJson() {
    return {
      'subscribe': subscribeToNewsletter,
      'acquisition_method': acquisitionMethod,
      'acquisition_source': acquisitionSource,
    };
  }
}

class GigyaProfile {
  final String firstName = '';
  final String lastName = '';

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
