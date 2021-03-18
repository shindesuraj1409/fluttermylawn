import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:pedantic/pedantic.dart';

part 'check_email_event.dart';
part 'check_email_state.dart';

// Bloc to manage business logic of communicating to Gigya Api and finding out whether a
// particular "emailId" is available to be used for creating a new account
// or is it already taken.
class CheckEmailBloc extends Bloc<CheckEmailEvent, CheckEmailState> {
  final GigyaService _gigyaService;
  CheckEmailBloc({GigyaService gigyaService})
      : _gigyaService = gigyaService ?? registry<GigyaService>(),
        super(CheckEmailInitialState());

  // Actions
  void checkIsEmailAvailable(String email) {
    add(CheckEmailEvent(email));
  }

  @override
  Stream<CheckEmailState> mapEventToState(
    CheckEmailEvent event,
  ) async* {
    yield CheckEmailLoadingState();
    try {
      final lowerCaseEmail = event.email.toLowerCase();

      final isEmailAvailable =
          await _gigyaService.isEmailAvailable(lowerCaseEmail);

      yield (CheckEmailSuccessState(
        email: lowerCaseEmail,
        isEmailAvailable: isEmailAvailable,
      ));
    } on GigyaErrorException catch (e) {
      yield (CheckEmailErrorState(
        errorCode: e.errorCode,
        errorMessage: e.gigyaMessage(),
      ));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield (CheckEmailErrorState(
        errorMessage: 'Something went wrong. Please try again',
        errorCode: -1,
      ));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
