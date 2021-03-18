import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/services/customer/customer_service_excpetion.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';
import 'package:pedantic/pedantic.dart';

part 'update_billing_info_event.dart';
part 'update_billing_info_state.dart';

class UpdateBillingInfoBloc
    extends Bloc<UpdateBillingInfoEvent, UpdateBillingInfoState> {
  final CustomerService customerService;
  final RecurlyService recurlyService;
  final SessionManager sessionManager;

  UpdateBillingInfoBloc({
    @required this.customerService,
    @required this.recurlyService,
    @required this.sessionManager,
  })  : assert(customerService != null, 'Customer Service cannot be null'),
        assert(recurlyService != null, 'Recurly Service cannot be null'),
        assert(sessionManager != null, 'SessionManager cannot be null'),
        super(UpdateBillingInfoInitial());

  void updateBillingInfo(
    CreditCardData creditCardData,
    AddressData billingAddress,
  ) {
    add(UpdateBillingInfoEvent(
      creditCardData: creditCardData,
      billingAddress: billingAddress,
    ));
  }

  @override
  Stream<UpdateBillingInfoState> mapEventToState(
    UpdateBillingInfoEvent event,
  ) async* {
    try {
      yield UpdatingBillingInfo();

      // 1. Get Recurly Token if user is updating their Credit Card info
      // Note : Credit card validity is checked in UI part using CreditCardForm widget
      // so we don't need to check that here.
      var token;
      if (event.creditCardData != null && event.creditCardData.isNotEmpty()) {
        token = await recurlyService.getToken(
          event.billingAddress,
          event.creditCardData,
        );
      }

      // 2. Update Billing Info in Customer Service
      final user = await sessionManager.getUser();
      final customerId = user.customerId;

      await customerService.updateBillingInfo(
        customerId,
        event.billingAddress,
        token,
      );

      yield UpdateBillingInfoSuccess();
    } on RecurlyException catch (e) {
      yield UpdateBillingInfoError(e.message);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } on UpdateBillingInfoException catch (e) {
      yield UpdateBillingInfoError(e.message);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield UpdateBillingInfoError(
          'Unable to update your Billing Info. Please try again.');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
