import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/services/subscription/modify_subscription/modify_subscription_exception.dart';
import 'package:my_lawn/services/subscription/modify_subscription/modify_subscription_service.dart';
import 'package:pedantic/pedantic.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(this._service, this._modifySubscriptionService,
      {AuthenticationBloc authenticationBloc})
      : authenticationBloc =
            authenticationBloc ?? registry<AuthenticationBloc>(),
        assert(_service != null,
            'Find Subscription Service is required to use CancelSubscriptionBloc'),
        super(const SubscriptionState.none());
  final FindSubscriptionsByCustomerIdService _service;
  final ModifySubscriptionService _modifySubscriptionService;
  final AuthenticationBloc authenticationBloc;

  @override
  Stream<SubscriptionState> mapEventToState(
    SubscriptionEvent event,
  ) async* {
    if (event is FindSubscription) {
      try {
        yield SubscriptionState.loading();

        final subscriptions =
            await _service.findSubscriptionsByCustomerId(event.customerId);

        if (subscriptions.isEmpty) {
          yield SubscriptionState.none();
          return;
        }

        yield _chooseSubscription(subscriptions);
      } on FindSubscriptionByCustomerIdException catch (exception) {
        yield SubscriptionState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } on ModifySubscriptionException catch (exception) {
        yield SubscriptionState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield SubscriptionState.error('Error finding subscriptions');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
    if (event is SubscriptionUpdated) {
      yield _chooseSubscription(event.data);
    }
    if (event is SubscriptionModificationPreview) {
      final subscriptionId = state.data.last.id;
      final subscriptions =
          await _modifySubscriptionService.modificationPreview(
              subscriptionId.toString(), event.recommendationId);
      yield SubscriptionState.preview(subscriptions);
    }
  }

  SubscriptionState _chooseSubscription(List<SubscriptionData> data) {
    if (data.isEmpty) {
      return SubscriptionState.none();
    } else if (data.last.subscriptionStatus.isPending) {
      return SubscriptionState.pending(data, SubscriptionStatus.pending);
    } else if (data.last.subscriptionStatus.isActive) {
      return SubscriptionState.active(data, SubscriptionStatus.active);
    } else if (data.last.subscriptionStatus.isCanceled &&
        data.last.recommendationId ==
            authenticationBloc.state.user.recommendationId) {
      return SubscriptionState.canceled(data, SubscriptionStatus.canceled);
    } else {
      return SubscriptionState.none();
    }
  }
}
