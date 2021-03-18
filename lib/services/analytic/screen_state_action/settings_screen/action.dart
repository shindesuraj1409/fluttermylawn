import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class AppFeedbackScreenAction extends AdobeAnalyticAction {
  final int rating;

  AppFeedbackScreenAction({
    this.rating,
  }) : super(type: 'AppFeedbackScreenAction', action: 'feedback|thank you');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'general',
      's.stars': '#' * rating,
    };
  }
}
