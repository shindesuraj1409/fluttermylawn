import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_event.dart';
import 'package:my_lawn/blocs/activity/activity_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:pedantic/pedantic.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    ActivitiesService activitiesService,
    SessionManager sessionManager,
  })  : _activitiesService = activitiesService ?? registry<ActivitiesService>(),
        _sessionManager = sessionManager ?? registry<SessionManager>(),
        super(InitialActivityState());

  final ActivitiesService _activitiesService;
  final SessionManager _sessionManager;

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event) async* {
    if (event is SaveActivityEvent) {
      yield LoadingActivityState();
      try {
        final user = await _sessionManager.getUser();

        if (event.activityData.activityId != null) {
          await _activitiesService.updateActivity(
            user?.customerId,
            event.activityData,
          );
          yield SuccessUpdateActivityState();
        } else {
          await _activitiesService.createActivity(
            user?.customerId,
            event.activityData,
          );
          yield SuccessActivityState();
        }

      } catch (exception) {
        yield ErrorActivityState();
        unawaited(FirebaseCrashlytics.instance.recordError(
          exception,
          StackTrace.current,
        ));
      }
    }
  }
}
