import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_acpuserprofile/flutter_acpuserprofile.dart';
import 'package:pedantic/pedantic.dart';

abstract class AdobeUserProfileService {
  Future<String> getUserProfileExtensionVersion();

  Future<String> getUserAttributes(List<String> attributeList);

  Future<void> updateUserAttribute(String key, String value);

  Future<void> updateUserAttributes(Map<String, String> attributeMap);

  Future<void> removeUserAttribute(String attribute);

  Future<void> removeUserAttributes(List<String> attributeList);
}

class AdobeUserProfileServiceImpl implements AdobeUserProfileService {
  static const String TAG = 'AdobeUserProfileService';

  ///Getting the SDK version
  @override
  Future<String> getUserProfileExtensionVersion() async {
    var result = '';

    try {
      result = await FlutterACPUserProfile.extensionVersion;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Get user profile attributes which match the provided keys
  @override
  Future<String> getUserAttributes(List<String> attributeList) async {
    String userAttributes;

    try {
      userAttributes =
          await FlutterACPUserProfile.getUserAttributes(attributeList);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return userAttributes;
  }

  ///Set a single user profile attribute
  @override
  Future<void> updateUserAttribute(String key, String value) async {
    //TODO:Eugene think about data model here
    try {
      await FlutterACPUserProfile.updateUserAttribute(key, value);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  /// Set multiple user profile attributes.
  /// attributeMap format {"mapKey": "mapValue", "mapKey1": "mapValue1"}
  @override
  Future<void> updateUserAttributes(Map<String, String> attributeMap) async {
    //TODO:Eugene think about data model here
    try {
      await FlutterACPUserProfile.updateUserAttributes(attributeMap);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Remove user profile attribute if it exists
  @override
  Future<void> removeUserAttribute(String attribute) async {
    try {
      await FlutterACPUserProfile.removeUserAttribute(attribute);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Remove provided user profile attributes if they exist
  @override
  Future<void> removeUserAttributes(List<String> attributeList) async {
    try {
      await FlutterACPUserProfile.removeUserAttributes(attributeList);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
