import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_event.dart';
import 'package:my_lawn/blocs/calendar/calendar_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/analytic/actions/localytics/customize_plan_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';

final currentYear = DateTime.now().year;

final _initialState = CalendarState(
  selectedTabs: Event.values,
);

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    NotesService notesService,
    ActivitiesService activitiesService,
    SessionManager sessionManager,
    LocalyticsService localyticsService,
  })  : _notesService = notesService ?? registry<NotesService>(),
        _activitiesService = activitiesService ?? registry<ActivitiesService>(),
        _sessionManager = sessionManager ?? registry<SessionManager>(),
        _localyticsService = localyticsService ?? registry<LocalyticsService>(),
        super(_initialState) {
    _activitiesService.activitiesStream.listen((event) {
      add(InitialCalendarEvent());
    });
  }

  final NotesService _notesService;
  final ActivitiesService _activitiesService;
  final SessionManager _sessionManager;
  final LocalyticsService _localyticsService;

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is InitialCalendarEvent) {
      yield _initialState.copyWith(loading: true);
      await _loadEvents();
    } else if (event is EventsLoadedEvent) {
      final calendarMarkers = <DateTime, List<CalendarEvents>>{};

      for (var event in event.allEvents) {
        final modifiedEvent = CalendarEvents(
            event: event.event,
            eventDate: DateTime(
              event.eventDate.year,
              event.eventDate.month,
              event.eventDate.day,
            ));
        if (calendarMarkers.containsKey(modifiedEvent.eventDate)) {
          final eventType = calendarMarkers[modifiedEvent.eventDate]
              .map((calendarEvent) => calendarEvent.event);

          if (!eventType.contains(modifiedEvent.event)) {
            calendarMarkers[modifiedEvent.eventDate].add(modifiedEvent);
          }
        } else {
          calendarMarkers[modifiedEvent.eventDate] = [modifiedEvent];
        }
      }

      final selectedDate = event.selectedDate ?? DateTime.now();

      final currentDay =
          _getNearestSelectedDateEvent(selectedDate, event.displayedEvents);

      yield state.copyWith(
        calendarMarkers: calendarMarkers,
        allEvents: event.allEvents,
        displayedEvents: event.displayedEvents,
        exception: event.exception,
        focusedEvent: currentDay,
        loading: false,
      );
    } else if (event is SearchValueChangedEvent) {
      yield state.copyWith(searchText: event.searchValue);
      yield state.copyWith(displayedEvents: _getDisplayedEvents());
    } else if (event is TabsChangedEvent) {
      yield state.copyWith(
          selectedTabs: event.selectedTabs.isEmpty
              ? state.selectedTabs
              : event.selectedTabs);
      yield state.copyWith(displayedEvents: _getDisplayedEvents());
    } else if (event is SelectedDateEvent) {
      final seletedDateEvent =
          _getNearestSelectedDateEvent(event.date, _getDisplayedEvents());

      yield state.copyWith(loading: true);
      yield state.copyWith(loading: false, focusedEvent: seletedDateEvent);
    } else if (event is TodayEvent) {
      final now = DateTime.now();

      final currentDay =
          _getNearestSelectedDateEvent(now, _getDisplayedEvents());

      yield state.copyWith(loading: true);
      yield state.copyWith(loading: false, focusedEvent: currentDay);
    } else if (event is DeleteEvent) {
      yield* _deleteEvent(event.event);
    } else if (event is MarkDoneEvent) {
      yield* _markDone(event.event);
    } else {
      throw UnimplementedError('Not supported event type: $event');
    }
  }

  Stream<CalendarState> _markDone(CalendarEvents event) async* {
    await _localyticsService.tagEvent(TaskCompletedEvent(
      event.task.activityType.toString(),
      DateTime.now().toString(),
    ));

    final user = await _sessionManager.getUser();

    yield state.copyWith(loading: true);
    try {
      await _activitiesService.updateActivity(
          user.customerId, event.task.copyWith(applied: true));

      yield state.copyWith(loading: false);
    } catch (exception) {
      yield state.copyWith(exception: exception, loading: false);
    }
  }

  Future<void> _loadEvents() async {
    try {
      final notes = await _loadNotes();
      final tasks = await _loadTasks();

      final events = <CalendarEvents>[...notes, ...tasks]
        ..sort((e1, e2) => e1.eventDate.compareTo(e2.eventDate));
      final displayedEvents = _getDisplayedEvents(events: events);

      add(EventsLoadedEvent(
          allEvents: events, displayedEvents: displayedEvents));
    } catch (exception) {
      add(EventsLoadedEvent(
        exception: exception,
      ));
    }
  }

  List<CalendarEvents> _getDisplayedEvents({List<CalendarEvents> events}) {
    return (events ?? state.allEvents)
        .where((e) =>
            state.selectedTabs.contains(e.event) && _containsSearchValue(e))
        .toList();
  }

  bool _containsSearchValue(CalendarEvents event) {
    final value = state.searchText?.toLowerCase();
    if (value == null || value.isEmpty) {
      return true;
    } else if (event.note != null) {
      return (event.note.title?.toLowerCase()?.contains(value) ?? false) ||
          (event.note.description?.toLowerCase()?.contains(value) ?? false);
    } else if (event.task != null) {
      return (event.task.name?.toLowerCase()?.contains(value) ?? false) ||
          (event.task.description?.toLowerCase()?.contains(value) ?? false);
    }
    return false;
  }

  Future<List<CalendarEvents>> _loadTasks() async {
    var activities = <ActivityData>[];
    await _activitiesService.activitiesStream.listen((event) {
      activities = event;
    });
    if (activities == null) return [];
    var recommendation;
    await _sessionManager
        .getUser()
        .then((value) => recommendation = value.recommendationId);
    final skus = activities
        .where((activity) =>
            (activity.activityType == ActivityType.recommended &&
                activity.recommendationId == recommendation) ||
            (activity.activityType == ActivityType.recommended &&
                activity.recommendationId != recommendation &&
                (activity.applied || activity.skipped)) ||
            (activity.activityType == ActivityType.fake))
        .expand((activity) => activity.childProducts)
        .map((product) => product.sku)
        .toList();
    skus.addAll(activities
        .where((activity) =>
            activity.activityType == ActivityType.userAddedProduct)
        .map((product) => product.productId));

    var tasks = await _activitiesService.copyWithGraphQL(
        activities: activities
            .where((activity) =>
                (activity.activityType == ActivityType.recommended &&
                    activity.recommendationId == recommendation) ||
                (activity.activityType == ActivityType.recommended &&
                    activity.recommendationId != recommendation &&
                    (activity.applied || activity.skipped)) ||
                activity.activityType == ActivityType.fake ||
                activity.activityType == ActivityType.userAddedProduct)
            .toList(),
        products: skus);
    // Add all activities without products at the end of the list
    final tasksActivities = activities
        .where((activity) =>
            activity.activityType != ActivityType.recommended &&
            activity.activityType != ActivityType.fake &&
            activity.activityType != ActivityType.userAddedProduct)
        .toList();
    if (tasks == null) {
      tasks = tasksActivities;
    } else {
      tasks.addAll(tasksActivities);
    }

    return tasks
        .map((activity) => CalendarEvents(
              eventDate: activity.activityDate ??
                  activity?.applicationWindow?.startDate,
              event: _getActivityEventType(activity),
              task: activity,
            ))
        .toList();
  }

  Event _getActivityEventType(ActivityData activity) {
    switch (activity.activityType) {
      case ActivityType.waterLawn:
        return Event.water;
      case ActivityType.recommended:
        return Event.products;
      case ActivityType.userAddedProduct:
        return Event.products;
      case ActivityType.fake:
        return Event.products;
      default:
        return Event.tasks;
    }
  }

  CalendarEvents _getNearestSelectedDateEvent(
      DateTime selectedDate, List<CalendarEvents> events) {
    CalendarEvents currentDay;
    if (events.isNotEmpty) {
      final durations = events
          .map((event) => event.eventDate.difference(selectedDate).abs().inDays)
          .toList();
      currentDay = events.elementAt(
          durations.indexOf(durations.reduce((a, b) => a <= b ? a : b)));
    }
    return currentDay;
  }

  Future<List<CalendarEvents>> _loadNotes() async {
    final user = await _sessionManager.getUser();
    final notes = await _notesService.getAllNotes(user.customerId);

    return notes
        .map((note) => CalendarEvents(
              eventDate: note.date,
              event: Event.notes,
              note: note,
            ))
        .toList();
  }

  Stream<CalendarState> _deleteEvent(CalendarEvents event) async* {
    final user = await _sessionManager.getUser();

    yield state.copyWith(loading: true);
    try {
      if (event.note != null) {
        await _notesService.deleteNote(user.customerId, event.note);
        add(InitialCalendarEvent());
      } else if (event.task != null) {
        await _activitiesService.deleteActivity(
          user.customerId,
          event.task.activityId,
        );
      }
      yield state.copyWith(loading: false);
    } catch (exception) {
      yield state.copyWith(exception: exception, loading: false);
    }
  }
}
