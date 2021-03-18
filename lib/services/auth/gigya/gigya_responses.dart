import 'package:my_lawn/services/auth/gigya/gigya_user.dart';

class BaseGigyaResponse {
  final int errorCode;
  final int statusCode;
  final String statusReason;
  final String errorMessage;
  final String errorDetails;
  final String loginToken;
  final String sessionToken;
  final String sessionSecret;

  BaseGigyaResponse({
    this.errorCode,
    this.statusCode,
    this.statusReason,
    this.errorMessage,
    this.errorDetails,
    this.loginToken,
    this.sessionToken,
    this.sessionSecret,
  });

  BaseGigyaResponse.fromJson(Map<String, dynamic> map)
      : statusCode = map['statusCode'] as int,
        errorCode = map['errorCode'] as int,
        statusReason = map['statusReason'] as String,
        errorMessage = map['errorMessage'] as String,
        errorDetails = map['errorDetails'] as String,
        loginToken = map['login_token'] as String,
        sessionToken = map['sessionInfo'] != null
            ? map['sessionInfo']['sessionToken'] as String
            : null,
        sessionSecret = map['sessionInfo'] != null
            ? map['sessionInfo']['sessionSecret'] as String
            : null;
}

class InitRegistrationResponse extends BaseGigyaResponse {
  final String regToken;

  InitRegistrationResponse.fromJson(Map<String, dynamic> map)
      : regToken = map['regToken'] as String,
        super.fromJson(map);
}

class EmailAvailableResponse extends BaseGigyaResponse {
  final bool isAvailable;

  EmailAvailableResponse.fromJson(Map<String, dynamic> map)
      : isAvailable = map['isAvailable'] as bool,
        super.fromJson(map);
}

class GigyaAccountResponse extends BaseGigyaResponse {
  final String UID;
  final String UIDSignature;
  final String signatureTimestamp;

  final String regToken;
  final String idToken;
  final String accessToken;

  final bool isVerified;
  final String firstName;
  final String lastName;
  final String email;
  final bool newUser;

  GigyaAccountResponse({
    this.UID,
    this.UIDSignature,
    this.signatureTimestamp,
    this.regToken,
    this.idToken,
    this.isVerified,
    this.firstName,
    this.lastName,
    this.email,
    this.accessToken,
    this.newUser,
  });

  GigyaAccountResponse.fromJson(Map<String, dynamic> map)
      : UID = map['UID'] as String,
        UIDSignature = map['UIDSignature'] as String,
        signatureTimestamp = map['signatureTimestamp'] is String
            ? map['signatureTimestamp']
            : map['signatureTimestamp'].toString(),
        regToken = map['regToken'] as String,
        idToken = map['id_token'] as String,
        isVerified =
            map['isVerified'] != null ? map['isVerified'] as bool : false,
        firstName = map['profile'] != null ? map['profile']['firstName'] : null,
        lastName = map['profile'] != null ? map['profile']['lastName'] : null,
        email = map['profile'] != null ? map['profile']['email'] : null,
        accessToken = map['access_token'] as String,
        newUser = map['newUser'] != null ? map['newUser'] as bool : false,
        super.fromJson(map);
}

extension GigyaAccountResponseExtensions on GigyaAccountResponse {
  GigyaUser toGigyaUser() {
    return GigyaUser(
      uid: UID,
      uidSignature: UIDSignature,
      uidTimestamp: signatureTimestamp,
      sessionToken: sessionToken,
      sessionSecret: sessionSecret,
      regToken: regToken,
    );
  }
}
