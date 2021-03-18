import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class AddNoteScreenAdobeState extends AdobeAnalyticState {

  AddNoteScreenAdobeState() : super(type: 'AddNoteScreenAdobeState', state: 'add notes');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'calendar'
    };
  }
}