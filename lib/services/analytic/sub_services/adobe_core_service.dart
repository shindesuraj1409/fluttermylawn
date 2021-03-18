import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';
import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';
import 'package:flutter_acpcore/src/acpextension_event.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';

import 'package:my_lawn/data/analytics/acp_extension_event_model.dart';
import 'package:pedantic/pedantic.dart';

abstract class AdobeCoreService {
  Future<String> getAdobeCoreExtensionVersion();

  Future<bool> configure(String environmentId);

  Future<void> updateConfiguration(Map<String, String> configuration);

  Future<void> setACPCoreLogLevel(ACPLoggingLevel acpLoggingLevel);

  Future<ACPPrivacyStatus> getPrivacyLevel();

  Future<void> setPrivacyLevel(ACPPrivacyStatus acpPrivacyStatus);

  Future<String> getSDKIdentities();

  Future<bool> dispatchAnEventHubEvent(
      ACPExtensionEventModel acpExtensionEventModel);

  Future<ACPExtensionEvent> dispatchAnEventHubEventWithCallback(
      ACPExtensionEventModel acpExtensionEventModel);

  Future dispatchAnEventHubEventResponseEvent(
      {ACPExtensionEventModel responseEventModel,
      ACPExtensionEventModel requestEventModel});

  ACPExtensionEvent buildACPExtensionEvent(
      ACPExtensionEventModel acpExtensionEventModel);
}

class AdobeCoreServiceImpl implements AdobeCoreService {
  static const String TAG = '[AdobeCoreService]';

  ///Getting the SDK version
  @override
  Future<String> getAdobeCoreExtensionVersion() async {
    String result;

    try {
      result = await FlutterACPCore.extensionVersion;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Configuring the SDK
  @override
  Future<bool> configure(String environmentId) async {
    assert(environmentId?.isNotEmpty == true);

    try {
      return environmentId ==
          await MethodChannel('com.scotts.lawnapp/adobe').invokeMethod<String>(
              'configureAdobeWithEnvironmentId', environmentId);
    } catch (e) {
      registry<Logger>().e('configure: failed with $e');
      return false;
    }
  }

  ///Updating the SDK configuration
  @override
  Future<void> updateConfiguration(Map<String, String> configuration) async {
    try {
      await FlutterACPCore.updateConfiguration(configuration);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Function for setting different log levels of FlutterACPCore
  @override
  Future<void> setACPCoreLogLevel(ACPLoggingLevel acpLoggingLevel) async {
    await FlutterACPCore.setLogLevel(acpLoggingLevel);
  }

  ///Function for getting the current privacy status
  @override
  Future<ACPPrivacyStatus> getPrivacyLevel() async {
    ACPPrivacyStatus result;

    try {
      result = await FlutterACPCore.privacyStatus;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
    return result;
  }

  ///Function setting the privacy status
  @override
  Future<void> setPrivacyLevel(ACPPrivacyStatus acpPrivacyStatus) async {
    await FlutterACPCore.setPrivacyStatus(acpPrivacyStatus);
  }

  ///Getting the SDK identities
  @override
  Future<String> getSDKIdentities() async {
    String result;

    try {
      result = await FlutterACPCore.sdkIdentities;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Dispatching an Event Hub event
  @override
  Future<bool> dispatchAnEventHubEvent(
      ACPExtensionEventModel acpExtensionEventModel) async {
    final event = buildACPExtensionEvent(acpExtensionEventModel);

    bool result;
    try {
      result = await FlutterACPCore.dispatchEvent(event);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
    return result;
  }

  ///Dispatching an Event Hub event with callback
  @override
  Future<ACPExtensionEvent> dispatchAnEventHubEventWithCallback(
      ACPExtensionEventModel acpExtensionEventModel) async {
    ACPExtensionEvent result;
    final event = buildACPExtensionEvent(acpExtensionEventModel);

    try {
      result = await FlutterACPCore.dispatchEventWithResponseCallback(event);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Dispatching an Event Hub response event
  @override
  Future dispatchAnEventHubEventResponseEvent(
      {ACPExtensionEventModel responseEventModel,
      ACPExtensionEventModel requestEventModel}) async {
    bool result;

    final responseEvent = buildACPExtensionEvent(responseEventModel);
    final requestEvent = buildACPExtensionEvent(requestEventModel);

    try {
      result = await FlutterACPCore.dispatchResponseEvent(
          responseEvent, requestEvent);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Building [ACPExtensionEvent] from data model [ACPExtensionEventModel]
  @override
  ACPExtensionEvent buildACPExtensionEvent(
      ACPExtensionEventModel acpExtensionEventModel) {
    return ACPExtensionEvent.createEvent(
        acpExtensionEventModel.eventName,
        acpExtensionEventModel.eventType,
        acpExtensionEventModel.eventSource,
        acpExtensionEventModel.data);
  }
}
