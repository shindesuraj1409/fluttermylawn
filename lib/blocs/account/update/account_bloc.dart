import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:pedantic/pedantic.dart';

part 'account_event.dart';
part 'account_state.dart';

const genericeSuccessMessage = 'Account updated successfully.';
const genericErrorMessage = 'Something went wrong. Please try again';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CustomerService _service;
  final SessionManager _sessionManager;
  final GigyaService _gigyaService;
  AccountBloc(
    this._service,
    this._sessionManager,
    this._gigyaService,
    User _user,
  )   : assert(_service != null,
            'Customer Service is required to use AccountBloc'),
        assert(_sessionManager != null,
            'Session Manager is required to use AccountBloc'),
        assert(_gigyaService != null,
            'Gigya Service is required to use AccountBloc'),
        super(AccountState.initial(_user));

  void updateAccount({
    String email,
    String firstName,
    String lastName,
    bool isNewsletterSubscribed,
  }) {
    add(AccountUpdateEvent(
      email,
      firstName,
      lastName,
      isNewsletterSubscribed,
    ));
  }

  void subscribeToNewsLetter() {
    add(AccountSubscribeNewsLetterEvent());
  }

  void changePassword(String oldPassword, String newPassword) {
    add(ChangePasswordEvent(oldPassword, newPassword));
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is AccountUpdateEvent) {
      yield* _mapAccountUpdateEventToState(event);
    } else if (event is ChangePasswordEvent) {
      yield* _mapChangePasswordEventToState(event);
    } else if (event is AccountSubscribeNewsLetterEvent) {
      yield* _mapAccountSubscribeNewsLetterEventToState(event);
    }
  }

  Stream<AccountState> _mapChangePasswordEventToState(
      ChangePasswordEvent event) async* {
    yield AccountState.loading(state.user);
    try {
      await _gigyaService.setAccountInfo(
        currentPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      yield AccountState.success('Password Updated Successfully!', state.user);
    } on GigyaErrorException catch (e) {
      yield (AccountState.error(e.errorMessage, state.user));
    } catch (e) {
      yield (AccountState.error(genericErrorMessage, state.user));
    }
  }

  Stream<AccountState> _mapAccountUpdateEventToState(
      AccountUpdateEvent event) async* {
    yield AccountState.loading(state.user);

    try {
      final _customerId = state.user.customerId;
      final userToSend = state.user.copyWith(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        isNewsletterSubscribed: event.isNewsletterSubscribed,
      );
      final message = await _service.updateCustomer(_customerId, userToSend);
      final user = await _service.getCustomer(_customerId);
      await _sessionManager.setUser(user);
      yield AccountState.success(message, await _sessionManager.getUser());
    } catch (e) {
      yield (AccountState.error(genericErrorMessage, state.user));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<AccountState> _mapAccountSubscribeNewsLetterEventToState(
      AccountSubscribeNewsLetterEvent event) async* {
    yield AccountState.loading(state.user);

    try {
      final _customerId = state.user.customerId;
      final user = await _service.subscribeNewsLetter(_customerId);
      await _sessionManager.setUser(user);
      yield AccountState.success(
          genericeSuccessMessage, await _sessionManager.getUser());
    } catch (e) {
      yield (AccountState.error(genericErrorMessage, state.user));
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
