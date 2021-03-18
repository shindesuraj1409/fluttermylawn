import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:my_lawn/services/analytic/sub_services/adobe_identity_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_user_profile_service.dart';

abstract class AdobeUserProfileRepository {

  void checkIdentity();

  void updateUserCustomerId(String email);

  void updateUserLocalyticsId(String localyticsId);

  void updateUserAttribute(String attribute, bool value);
}

class AdobeUserProfileRepositoryImpl implements AdobeUserProfileRepository{
  static const String TAG = 'AdobeUserProfileRepository';

  final AdobeUserProfileService _adobeUserProfileService ;
  final AdobeIdentityService _adobeIdentityService;

  AdobeUserProfileRepositoryImpl(this._adobeUserProfileService,this._adobeIdentityService,);

  void _updateUserAttribute(String key, String value) {
    _adobeUserProfileService.updateUserAttribute(key, value);
  }

  void _syncIdentifier(String key, String value, AdobeIdentifierAuthState state) {
    _adobeIdentityService.syncIdentifier(key, value, state);
  }

  @override
  void checkIdentity(){
    _adobeIdentityService.getIdentifiers();
  }

  @override
  void updateUserCustomerId(String email) {
    final adobeKey = 'customerId';

    final hashedEmail = generateMd5(email);

    _updateUserAttribute(adobeKey, hashedEmail);

    _syncIdentifier(adobeKey, hashedEmail, AdobeIdentifierAuthState.AUTHENTICATED);
  }

  @override
  void updateUserLocalyticsId(String localyticsId) {
    final adobeKey = 'localyticsId';

    _updateUserAttribute(adobeKey, localyticsId);

    _syncIdentifier(adobeKey, localyticsId, AdobeIdentifierAuthState.AUTHENTICATED);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  void updateUserAttribute(String attribute, bool value) {
    _updateUserAttribute(attribute, value.toString());
  }
}