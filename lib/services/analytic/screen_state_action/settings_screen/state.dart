import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class SettingsSubScreenAdobeState extends AdobeAnalyticState {
  final String option;

  SettingsSubScreenAdobeState({
    this.option
  }) : super(type: 'SettingsSubScreenAdobeState', state: 'settings|$option');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
    };
  }
}

class SoftAskScreenAdobeState extends AdobeAnalyticState {
  final String askType;

  SoftAskScreenAdobeState({
    this.askType
  }) : super(type: 'SoftAskScreenAdobeState', state: 'settings|soft ask|$askType');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
    };
  }
}

class AppFeedbackScreenAdobeState extends AdobeAnalyticState {

  AppFeedbackScreenAdobeState() : super(type: 'AppFeedbackScreenAdobeState', state: 'feedback',);

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
    };
  }
}

class SettingsScreenAdobeState extends AdobeAnalyticState {
  SettingsScreenAdobeState() : super(type: 'SettingsScreenAdobeState', state: 'settings',);

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
    };
  }
}
