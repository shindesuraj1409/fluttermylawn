import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_event.dart';
import 'package:my_lawn/blocs/activity/activity_state.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class MockActivitiesService extends Mock implements ActivitiesService {}

class MockSessionManager extends Mock implements SessionManager {}

void main() {
  group('ActivityBloc', () {
    final customerId = 'mockedCustomerId';
    final activityId = '1';
    final date = DateTime.now();
    final type = ActivityType.waterLawn;
    final validActivityData =
        ActivityData(activityType: type, activityDate: date);
    final editedActivityData = ActivityData(
      activityType: type,
      activityDate: date,
      activityId: activityId,
    );
    final invalidActivityData = ActivityData();
    final user = User(customerId: customerId);
    final exception = Exception('Invalid activity data');

    ActivitiesService activitiesService;
    SessionManager sessionManager;

    setUp(() {
      activitiesService = MockActivitiesService();
      sessionManager = MockSessionManager();

      when(sessionManager.getUser()).thenAnswer((_) async => user);
      when(activitiesService.createActivity(customerId, invalidActivityData))
          .thenThrow(exception);
      when(activitiesService.createActivity(customerId, validActivityData))
          .thenAnswer((_) async => null);
      when(activitiesService.updateActivity(customerId, editedActivityData))
          .thenAnswer((_) async => null);
    });

    test('initial state', () {
      final bloc = ActivityBloc(
        activitiesService: activitiesService,
        sessionManager: sessionManager,
      );
      expect(bloc.state, InitialActivityState());
      bloc.close();
    });

    blocTest<ActivityBloc, ActivityState>(
      'emits [LoadingActivityState, SuccessActivityState]',
      build: () => ActivityBloc(
        activitiesService: activitiesService,
        sessionManager: sessionManager,
      ),
      act: (bloc) => bloc.add(SaveActivityEvent(validActivityData)),
      expect: <ActivityState>[
        LoadingActivityState(),
        SuccessActivityState(),
      ],
      verify: (_) {
        verify(sessionManager.getUser()).called(1);
        verify(activitiesService.createActivity(customerId, validActivityData))
            .called(1);
        verifyNoMoreInteractions(sessionManager);
        verifyNoMoreInteractions(activitiesService);
      },
    );

    blocTest<ActivityBloc, ActivityState>(
      'emits [LoadingActivityState, SuccessUpdateActivityState]',
      build: () => ActivityBloc(
        activitiesService: activitiesService,
        sessionManager: sessionManager,
      ),
      act: (bloc) => bloc.add(SaveActivityEvent(editedActivityData)),
      expect: <ActivityState>[
        LoadingActivityState(),
        SuccessUpdateActivityState(),
      ],
      verify: (_) {
        verify(sessionManager.getUser()).called(1);
        verify(activitiesService.updateActivity(customerId, editedActivityData))
            .called(1);
        verifyNoMoreInteractions(sessionManager);
        verifyNoMoreInteractions(activitiesService);
      },
    );

    blocTest<ActivityBloc, ActivityState>(
      'emits [LoadingActivityState, ErrorActivityState]',
      build: () => ActivityBloc(
        activitiesService: activitiesService,
        sessionManager: sessionManager,
      ),
      act: (bloc) => bloc.add(SaveActivityEvent(invalidActivityData)),
      expect: <ActivityState>[
        LoadingActivityState(),
        ErrorActivityState(),
      ],
      verify: (_) {
        verify(sessionManager.getUser()).called(1);
        verify(activitiesService.createActivity(
                customerId, invalidActivityData))
            .called(1);
        verifyNoMoreInteractions(sessionManager);
        verifyNoMoreInteractions(activitiesService);
      },
    );
  });
}
