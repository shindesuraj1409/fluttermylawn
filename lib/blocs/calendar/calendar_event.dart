import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';

abstract class CalendarEvent {}

class InitialCalendarEvent extends CalendarEvent {}

class EventsLoadedEvent extends CalendarEvent {
  EventsLoadedEvent({
    this.selectedDate,
    this.allEvents,
    this.displayedEvents,
    this.exception,
  });
  final DateTime selectedDate;
  final List<CalendarEvents> allEvents;
  final List<CalendarEvents> displayedEvents;
  final Exception exception;
}

class TabsChangedEvent extends CalendarEvent {
  TabsChangedEvent(this.selectedTabs);

  final List<Event> selectedTabs;
}

class SearchValueChangedEvent extends CalendarEvent {
  SearchValueChangedEvent(this.searchValue);

  final String searchValue;
}

class TodayEvent extends CalendarEvent {}

class SelectedDateEvent extends CalendarEvent {
  SelectedDateEvent(this.date);

  final DateTime date;
}

class DeleteEvent extends CalendarEvent {
  DeleteEvent(this.event);

  final CalendarEvents event;
}

class MarkDoneEvent extends CalendarEvent {
  MarkDoneEvent(this.event);

  final CalendarEvents event;
}
