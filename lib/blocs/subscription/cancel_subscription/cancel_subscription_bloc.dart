import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/refund_preview_data.dart';
import 'package:my_lawn/services/subscription/cancel_subscription/cancel_subscription_exceptions.dart';
import 'package:my_lawn/services/subscription/cancel_subscription/cancel_subscription_service.dart';
import 'package:pedantic/pedantic.dart';

part 'cancel_subscription_event.dart';
part 'cancel_subscription_state.dart';

class CancelSubscriptionBloc
    extends Bloc<CancelEvent, CancelSubscriptionState> {
  final CancelSubscriptionService _service;

  CancelSubscriptionBloc(this._service)
      : assert(_service != null,
            'Cancel Subscription Service is required to use CancelSubscriptionBloc'),
        super(CancelSubscriptionStateInitial());

  @override
  Stream<CancelSubscriptionState> mapEventToState(
    CancelEvent event,
  ) async* {
    if (event is PreviewSubscriptionRefundEvent) {
      try {
        yield CancelSubscriptionStateLoading();

        final data = await _service.previewSubscriptionRefund(event.orderId);

        yield PreviewSubscriptionStateSuccess(data);
      } on PreviewRefundException catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
        yield CancelSubscriptionStateError(exception.errorMessage);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
        yield CancelSubscriptionStateError('Error getting preview');
      }
      ;
    }
    if (event is CancelSubscriptionEvent) {
      try {
        yield CancelSubscriptionStateLoading();

        await _service.cancelSubscription(event.orderId);

        yield CancelSubscriptionStateSuccess();
      } on CancelSubscriptionException catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
        yield CancelSubscriptionStateError(exception.errorMessage);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
        yield CancelSubscriptionStateError('Error canceling subscription');
      }
    }
  }
}
