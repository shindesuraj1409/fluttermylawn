import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/calendar/calendar_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_event.dart';
import 'package:my_lawn/blocs/calendar/calendar_state.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';

class MockNotesService extends Mock implements NotesService {}

class MockActivitiesService extends Mock implements ActivitiesService {
  @override
  Stream<List<ActivityData>> get activitiesStream => MockActivitiesStream();
}

class MockActivitiesStream extends Mock implements Stream<List<ActivityData>> {}

class MockSessionManager extends Mock implements SessionManager {}

class MockLocalyticsService extends Mock implements LocalyticsService {}

void main() {
  final customerId = 'mockedCustomerId';
  final recommendationId = 'recommendationId';
  final user = User(customerId: customerId, recommendationId: recommendationId);

  final initialState = CalendarState(
    selectedTabs: Event.values,
  );
  final activityData = ActivityData(
    activityDate: DateTime.now(),
    activityType: ActivityType.mowLawn,
    activityId: 'id',
  );
  final noteData = NoteData(date: DateTime.now());
  final searchValue = 'search';
  final tabs = [Event.products, Event.notes];
  final calendarNote = CalendarEvents(
    event: Event.notes,
    eventDate: noteData.date,
    note: noteData,
  );
  final calendarActivity = CalendarEvents(
    event: Event.tasks,
    eventDate: activityData.activityDate,
    task: activityData,
  );
  final exception = Exception();

  NotesService notesService;
  ActivitiesService activitiesService;
  SessionManager sessionManager;
  LocalyticsService localyticsService;

  group('CalendarBloc SUCCESS cases', () {
    setUp(() {
      notesService = MockNotesService();
      activitiesService = MockActivitiesService();
      sessionManager = MockSessionManager();
      localyticsService = MockLocalyticsService();

      when(notesService.getAllNotes(customerId))
          .thenAnswer((_) async => [noteData]);
      when(activitiesService.getActivities(customerId))
          .thenAnswer((_) async => [activityData]);
      when(sessionManager.getUser()).thenAnswer((_) async => user);
      when(notesService.deleteNote(customerId, noteData))
          .thenAnswer((_) => null);
      when(activitiesService.deleteActivity(
              customerId, activityData.activityId))
          .thenAnswer((_) => null);
      when(activitiesService.activitiesStream.listen(any))
          .thenAnswer((Invocation invocation) {
        final callback = invocation.positionalArguments.single;
        return callback([activityData]);
      });
    });

    test('initial state', () {
      final bloc = CalendarBloc(
        notesService: notesService,
        activitiesService: activitiesService,
        sessionManager: sessionManager,
        localyticsService: localyticsService,
      );

      expect(bloc.state, initialState);
      bloc.close();
    });

    blocTest<CalendarBloc, CalendarState>('TabsChangedEvent',
        build: () => CalendarBloc(
              notesService: notesService,
              activitiesService: activitiesService,
              sessionManager: sessionManager,
              localyticsService: localyticsService,
            ),
        act: (bloc) => bloc.add(TabsChangedEvent(tabs)),
        expect: <CalendarState>[
          initialState.copyWith(selectedTabs: tabs),
        ]);

    blocTest<CalendarBloc, CalendarState>('SearchValueChangedEvent',
        build: () => CalendarBloc(
              notesService: notesService,
              activitiesService: activitiesService,
              sessionManager: sessionManager,
              localyticsService: localyticsService,
            ),
        act: (bloc) => bloc.add(SearchValueChangedEvent(searchValue)),
        expect: <CalendarState>[
          initialState.copyWith(searchText: searchValue),
        ]);
  });

  group('CalendarBloc ERROR cases', () {
    setUp(() {
      notesService = MockNotesService();
      activitiesService = MockActivitiesService();
      sessionManager = MockSessionManager();

      when(notesService.getAllNotes(customerId)).thenThrow(exception);
      when(activitiesService.getActivities(customerId)).thenThrow(exception);
      when(sessionManager.getUser()).thenAnswer((_) async => user);
      when(notesService.deleteNote(customerId, noteData)).thenThrow(exception);
      when(activitiesService.deleteActivity(
              customerId, activityData.activityId))
          .thenThrow(exception);
    });

    blocTest<CalendarBloc, CalendarState>(
      'InitialCalendarEvent',
      build: () => CalendarBloc(
        notesService: notesService,
        activitiesService: activitiesService,
        sessionManager: sessionManager,
        localyticsService: localyticsService,
      ),
      act: (bloc) => bloc.add(InitialCalendarEvent()),
      expect: <CalendarState>[
        initialState.copyWith(loading: true),
      ],
      verify: (_) {
        verify(notesService.getAllNotes(customerId)).called(1);
        verify(sessionManager.getUser()).called(1);
        verifyNoMoreInteractions(notesService);
        verifyNoMoreInteractions(activitiesService);
        verifyNoMoreInteractions(sessionManager);
      },
    );

    blocTest<CalendarBloc, CalendarState>('TabsChangedEvent',
        build: () => CalendarBloc(
              notesService: notesService,
              activitiesService: activitiesService,
              sessionManager: sessionManager,
              localyticsService: localyticsService,
            ),
        act: (bloc) => bloc.add(TabsChangedEvent([])),
        expect: <CalendarState>[
          initialState,
        ]);

    blocTest<CalendarBloc, CalendarState>('DeleteEvent - NoteData',
        build: () => CalendarBloc(
              notesService: notesService,
              activitiesService: activitiesService,
              sessionManager: sessionManager,
              localyticsService: localyticsService,
            ),
        act: (bloc) => bloc.add(DeleteEvent(calendarNote)),
        expect: <CalendarState>[
          initialState.copyWith(loading: true),
          initialState.copyWith(loading: false, exception: exception),
        ],
        verify: (_) {
          verify(notesService.deleteNote(customerId, noteData)).called(1);
          verify(sessionManager.getUser()).called(1);
          verifyNoMoreInteractions(notesService);
          verifyNoMoreInteractions(activitiesService);
          verifyNoMoreInteractions(sessionManager);
        });

    blocTest<CalendarBloc, CalendarState>('DeleteEvent - ActivityData',
        build: () => CalendarBloc(
              notesService: notesService,
              activitiesService: activitiesService,
              sessionManager: sessionManager,
              localyticsService: localyticsService,
            ),
        act: (bloc) => bloc.add(DeleteEvent(calendarActivity)),
        expect: <CalendarState>[
          initialState.copyWith(loading: true),
          initialState.copyWith(loading: false, exception: exception),
        ],
        verify: (_) {
          verify(activitiesService.deleteActivity(
            customerId,
            activityData.activityId,
          )).called(1);
          verify(sessionManager.getUser()).called(1);
          verifyNoMoreInteractions(notesService);
          verifyNoMoreInteractions(activitiesService);
          verifyNoMoreInteractions(sessionManager);
        });
  });
}
