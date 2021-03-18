import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class OnBoardingState extends AdobeAnalyticState {
  final String some;
  final bool pushEnabled;
  final bool locationEnabled;
  final bool smsEnabled;

  OnBoardingState({
    this.some,
    this.pushEnabled,
    this.locationEnabled,
    this.smsEnabled,
  }) : super(
          type: 'OnBoardingState',
          state: 'splash',
        );

  @override
  Map<String, String> getData() {
    return {
      's.pushEnabled': pushEnabled.toString(),
      's.locationEnabled': locationEnabled.toString(),
      's.smsEnabled': smsEnabled.toString(),
      's.type': 'onboard',
    };
  }
}
