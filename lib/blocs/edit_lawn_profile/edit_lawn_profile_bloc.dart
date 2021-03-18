import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/lawn_data.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

part 'edit_lawn_profile_event.dart';
part 'edit_lawn_profile_state.dart';

const genericErrorMessage =
    'An error occurred while saving your Lawn Profile. Please try again';

class EditLawnProfileBloc
    extends Bloc<EditLawnProfileEvent, EditLawnProfileState> {
  final Navigation navigation;
  final SessionManager sessionManager;
  final WaterModelService waterModelService;
  EditLawnProfileBloc(
      this.navigation, this.sessionManager, this.waterModelService)
      : assert(navigation != null,
            'Navigation is required to use EditLawnProfileBloc'),
        assert(sessionManager != null,
            'Session Manager is required to use EditLawnProfileBloc'),
        assert(sessionManager != null,
            'WaterModel Service is required to use EditLawnProfileBloc'),
        super(EditLawnProfileStateInitial());

  void editLawnProfile({
    String screenPath,
    Object lawnData,
  }) {
    add(EditLawnProfileEventLoad(
      screenPath: screenPath,
      lawnData: lawnData,
    ));
  }

  @override
  Stream<EditLawnProfileState> mapEventToState(
    EditLawnProfileEvent event,
  ) async* {
    if (event is EditLawnProfileEventLoad) {
      try {
        final result = await navigation.push(
          event.screenPath,
          arguments: event.lawnData,
        );
        if (result != null && result is LawnData) {
          yield EditLawnProfileStateLoading();
          final user = await sessionManager.getUser();
          if (user.customerId == null) {
            await waterModelService.getWaterDataGuest(
              result.lawnAddress?.zip,
            );
          } else {
            await waterModelService.createPlot(
                user.customerId, int.tryParse(result.lawnAddress?.zip));
          }
        }
        yield EditLawnProfileStateSuccess(lawnData: result);
      } catch (exception) {
        yield EditLawnProfileStateError(errorMessage: genericErrorMessage);
        unawaited(
          FirebaseCrashlytics.instance
              .recordError(exception, StackTrace.current),
        );
      }
    }
  }
}
