abstract class HelpEvent {
  const HelpEvent();
}

class FetchHelpEvent extends HelpEvent {
  final String helpPage;

  FetchHelpEvent({this.helpPage});
}
