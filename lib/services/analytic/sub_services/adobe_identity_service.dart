import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';
import 'package:flutter_acpcore/flutter_acpidentity.dart';
import 'package:my_lawn/data/analytics/multiple_identifier_model.dart';
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';
import 'package:pedantic/pedantic.dart';

///Identity package documentation [https://github.com/adobe/flutter_acpcore#identity]
abstract class AdobeIdentityService {
  Future<String> getIdentityVersion();

  ACPMobileVisitorAuthenticationState getACPMobileVisitorAuthenticationState(
    AdobeIdentifierAuthState state,
  );

  Future<void> syncIdentifier(
    String key,
    String value,
    AdobeIdentifierAuthState state,
  );

  Future<void> syncIdentifiers(MultipleIdentifierModel multipleIdentifierModel);

  Future<void> syncIdentifiersWithAuthState(
    MultipleIdentifierModel multipleIdentifierModel,
  );

  Future<void> setAdvertisingIdentifier(String adId);

  Future<String> appendUserDataToUrl(String url);

  Future<String> getUserDataQueryString();

  Future<List<ACPMobileVisitorId>> getIdentifiers();

  Future<String> getExperienceCloudId();
}

class AdobeIdentityServiceImpl implements AdobeIdentityService {
  static const String TAG = 'AdobeIdentityService';

  ///Getting Identity version
  @override
  Future<String> getIdentityVersion() async {
    final result = await FlutterACPIdentity.extensionVersion;

    return result;
  }

  @override
  ACPMobileVisitorAuthenticationState getACPMobileVisitorAuthenticationState(
    AdobeIdentifierAuthState state,
  ) {
    switch (state) {
      case AdobeIdentifierAuthState.UNKNOWN:
        return ACPMobileVisitorAuthenticationState.UNKNOWN;
      case AdobeIdentifierAuthState.AUTHENTICATED:
        return ACPMobileVisitorAuthenticationState.AUTHENTICATED;
      case AdobeIdentifierAuthState.LOGGED_OUT:
        return ACPMobileVisitorAuthenticationState.LOGGED_OUT;

      default:
        return ACPMobileVisitorAuthenticationState.UNKNOWN;
    }
  }

  ///Sync single Identifier
  @override
  Future<void> syncIdentifier(
    String key,
    String value,
    AdobeIdentifierAuthState state,
  ) async {
    final _state = getACPMobileVisitorAuthenticationState(state);
    try {
      await FlutterACPIdentity.syncIdentifier(key, value, _state);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Sync multiple Identifiers
  @override
  Future<void> syncIdentifiers(
    MultipleIdentifierModel multipleIdentifierModel,
  ) async {
    try {
      await FlutterACPIdentity.syncIdentifiers(
        multipleIdentifierModel.identifierMap,
      );
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Sync Identifiers with Authentication State
  @override
  Future<void> syncIdentifiersWithAuthState(
    MultipleIdentifierModel multipleIdentifierModel,
  ) async {
    try {
      await FlutterACPIdentity.syncIdentifiersWithAuthState(
          multipleIdentifierModel.identifierMap,
          multipleIdentifierModel.acpMobileVisitorAuthenticationState);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Setting the advertising identifier
  @override
  Future<void> setAdvertisingIdentifier(String adId) async {
    await FlutterACPCore.setAdvertisingIdentifier(adId);
  }

  ///Append visitor data to a URL
  @override
  Future<String> appendUserDataToUrl(String url) async {
    String result;

    try {
      result = await FlutterACPIdentity.appendToUrl(url);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Get visitor data as URL query parameter string
  @override
  Future<String> getUserDataQueryString() async {
    String result;

    try {
      result = await FlutterACPIdentity.urlVariables;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Get Identifiers
  @override
  Future<List<ACPMobileVisitorId>> getIdentifiers() async {
    List<ACPMobileVisitorId> result;

    try {
      result = await FlutterACPIdentity.identifiers;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Get Experience Cloud IDs
  @override
  Future<String> getExperienceCloudId() async {
    String result;

    try {
      result = await FlutterACPIdentity.experienceCloudId;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }
}

enum AdobeIdentifierAuthState {
  UNKNOWN,
  AUTHENTICATED,
  LOGGED_OUT,
}
