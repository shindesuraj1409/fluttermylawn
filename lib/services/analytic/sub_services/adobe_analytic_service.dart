import 'package:my_lawn/data/analytics/analytic_action_model.dart';
import 'package:my_lawn/data/analytics/analytic_state_model.dart';

abstract class AdobeAnalyticService {

  Future<String> getAdobeAnalyticExtensionVersion();

  Future<String> getTrackingIdentifier();

  Future<void> sendQueuedHits();

  Future<int> getQueueSize();

  Future<void> clearQueuedHits();

  Future<String> getCustomUserIdentifier();

  Future<void> setCustomUserIdentifier(String id);

  Future<void> trackAppActions(AnalyticActionModel analyticActionModel);

  void trackAppState(AnalyticStateModel analyticStateModel);
}
