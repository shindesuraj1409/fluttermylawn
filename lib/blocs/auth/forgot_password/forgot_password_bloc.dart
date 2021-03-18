import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:pedantic/pedantic.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final GigyaService _gigyaService;

  ForgotPasswordBloc({GigyaService gigyaService})
      : _gigyaService = gigyaService ?? registry<GigyaService>(),
        super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ResetPasswordEmailRequested) {
      yield ForgotPasswordLoading();
      try {
        final emailSent = await _gigyaService.resetPassword(event.email);
        if (emailSent) {
          yield ForgotPasswordSuccess();
        } else {
          yield ForgotPasswordError(
            errorMessage: 'Something went wrong. Please try again',
            errorCode: -1,
          );
        }
      } on GigyaErrorException catch (e) {
        yield ForgotPasswordError(
            errorCode: e.errorCode, errorMessage: e.errorMessage);
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield (ForgotPasswordError(
          errorMessage: 'Something went wrong. Please try again',
          errorCode: -1,
        ));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
  }
}
