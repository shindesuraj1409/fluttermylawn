import 'package:flutter/foundation.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:collection/collection.dart';

class CalendarState {
  CalendarState({
    this.loading = false,
    this.selectedTabs = const [],
    this.allEvents = const [],
    this.displayedEvents = const [],
    this.focusedEvent,
    this.calendarMarkers = const <DateTime, List<CalendarEvents>>{},
    this.searchText,
    this.exception,
  });

  final bool loading;
  final List<Event> selectedTabs;
  final List<CalendarEvents> allEvents;
  final List<CalendarEvents> displayedEvents;
  final CalendarEvents focusedEvent;
  final Map<DateTime, List<CalendarEvents>> calendarMarkers;
  final String searchText;
  final Exception exception;

  CalendarState copyWith({
    bool loading,
    List<Event> selectedTabs,
    List<CalendarEvents> allEvents,
    List<CalendarEvents> displayedEvents,
    Map<DateTime, List<CalendarEvents>> calendarMarkers,
    CalendarEvents focusedEvent,
    String searchText,
    Exception exception,
  }) {
    return CalendarState(
      loading: loading ?? this.loading,
      selectedTabs: selectedTabs ?? this.selectedTabs,
      allEvents: allEvents ?? this.allEvents,
      displayedEvents: displayedEvents ?? this.displayedEvents,
      calendarMarkers: calendarMarkers ?? this.calendarMarkers,
      focusedEvent: focusedEvent ?? this.focusedEvent,
      searchText: searchText ?? this.searchText,
      exception: exception ?? this.exception,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          const ListEquality().equals(selectedTabs, other.selectedTabs) &&
          const ListEquality().equals(allEvents, other.allEvents) &&
          const ListEquality().equals(displayedEvents, other.displayedEvents) &&
          mapEquals(calendarMarkers, other.calendarMarkers) &&
          focusedEvent == other.focusedEvent &&
          searchText == other.searchText &&
          exception == other.exception;

  @override
  int get hashCode =>
      loading.hashCode ^
      selectedTabs.hashCode ^
      allEvents.hashCode ^
      displayedEvents.hashCode ^
      searchText.hashCode ^
      calendarMarkers.hashCode ^
      focusedEvent.hashCode ^
      exception.hashCode;

  @override
  String toString() {
    return 'CalendarState{loading: $loading, selectedTabs: $selectedTabs, '
        'allEvents: $allEvents, currentDay: $focusedEvent displayedEvents: $displayedEvents, calendarMarkers: $calendarMarkers '
        'searchText: $searchText, exception: $exception}';
  }
}
