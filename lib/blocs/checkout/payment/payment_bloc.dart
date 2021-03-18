import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_event.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_state.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';
import 'package:pedantic/pedantic.dart';

const genericErrorMessage = 'Something went wrong. Please try again';

class PaymentBloc
    extends Bloc<PaymentVerificationEvent, PaymentVerificationState> {
  final CartService _cartService;
  final RecurlyService _recurlyService;
  PaymentBloc(this._cartService, this._recurlyService)
      : assert(
            _cartService != null, 'Cart Service is required to use CartBloc'),
        assert(_recurlyService != null,
            'Recurly Service is required to use CartBloc'),
        super(PaymentVerificationInitialState());

  // actions

  void verifyPayment(AddressData billingData, AddressData shippingData,
      CreditCardData creditCardData, String cart_mask_id) {
    add(PaymentVerificationEvent(
      billingData,
      shippingData,
      creditCardData,
      cart_mask_id,
    ));
  }

  @override
  Stream<PaymentVerificationState> mapEventToState(
      PaymentVerificationEvent event) async* {
    if (event is PaymentVerificationEvent) {
      yield (PaymentVerificationLoadingState());

      final billingAddress = event.billingData;
      final shippingAddress = event.shippingData;
      final cart_id = event.cart_mask_id;
      final card = event.creditCardData;
      try {
        await _cartService.setBillingAddress(
          shippingAddress,
          billingAddress,
          cart_id,
        );

        final recurly_token =
            await _recurlyService.getToken(billingAddress, card);

        yield (PaymentVerificationVerifiedState(
          recurly_token: recurly_token,
        ));
      } on BillingAddressException catch (e) {
        yield (BillingAddressValidationFailure());
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } on RecurlyException catch (e) {
        yield (PaymentVerificationFailure(errorMessage: e.message));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield (PaymentVerificationFailure(errorMessage: genericErrorMessage));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
  }
}
