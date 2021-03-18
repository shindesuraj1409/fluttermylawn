import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_acpanalytics/flutter_acpanalytics.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';
import 'package:my_lawn/data/analytics/analytic_action_model.dart';
import 'package:my_lawn/data/analytics/analytic_state_model.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_analytic_service.dart';

import 'package:pedantic/pedantic.dart';

///Link for pub documentation [https://github.com/adobe/flutter_acpanalytics]
class AdobeAnalyticServiceImpl implements AdobeAnalyticService {
  static const String TAG = 'AdobeAnalyticService';

  ///Getting the SDK version
  @override
  Future<String> getAdobeAnalyticExtensionVersion() async {
    String result;

    try {
      result = await FlutterACPAnalytics.extensionVersion;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Get the tracking identifier
  @override
  Future<String> getTrackingIdentifier() async {
    String result;

    try {
      result = await FlutterACPAnalytics.trackingIdentifier;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Send queued hits
  @override
  Future<void> sendQueuedHits() async {
    await FlutterACPAnalytics.sendQueuedHits();
  }

  ///Get the queue size
  @override
  Future<int> getQueueSize() async {
    int queueSize;

    try {
      queueSize = await FlutterACPAnalytics.queueSize;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return queueSize;
  }

  ///Clear queued hits
  @override
  Future<void> clearQueuedHits() async {
    await FlutterACPAnalytics.clearQueue();
  }

  ///Get the custom visitor identifier
  @override
  Future<String> getCustomUserIdentifier() async {
    String result;

    try {
      result = await FlutterACPAnalytics.visitorIdentifier;
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return result;
  }

  ///Set the custom visitor identifier
  @override
  Future<void> setCustomUserIdentifier(String id) async {
    try {
      await FlutterACPAnalytics.setVisitorIdentifier(id);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Function for sending actions to Adobe analytics.
  @override
  Future<void> trackAppActions(AnalyticActionModel analyticActionModel) async {
    try {
      await FlutterACPCore.trackAction(
        analyticActionModel.action,
        data: analyticActionModel.getData,
      );
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  ///Function for sending actions to Adobe analytics.
  @override
  void trackAppState(AnalyticStateModel analyticStateModel) {
    try {
      FlutterACPCore.trackState(analyticStateModel.state,
          data: analyticStateModel.data);
    } catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
