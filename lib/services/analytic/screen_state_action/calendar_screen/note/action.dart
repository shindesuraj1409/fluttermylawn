import 'package:my_lawn/services/analytic/adobe_analytic_action.dart';

class NoteAddedScreenAdobeAction extends AdobeAnalyticAction {

  NoteAddedScreenAdobeAction() : super(type: 'NoteAddedScreenAdobeAction', action: 'notes added');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'calendar'
    };
  }
}