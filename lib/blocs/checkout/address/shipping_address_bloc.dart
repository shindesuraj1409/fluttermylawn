import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_event.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_state.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:pedantic/pedantic.dart';

const genericErrorMessage = 'Something went wrong. Please try again';

class ShippingAddressBloc
    extends Bloc<AddShippingAddressToCartEvent, ShippingAddressState> {
  final CartService _cartService;
  ShippingAddressBloc(this._cartService)
      : assert(
            _cartService != null, 'Cart Service is required to use CartBloc'),
        super(ShippingAddressInitialState());

  // actions
  void verifyAddress(AddressData addressData, String cart_mask_id) {
    add(AddShippingAddressToCartEvent(
      addressData,
      cart_mask_id,
    ));
  }

  @override
  Stream<ShippingAddressState> mapEventToState(
      AddShippingAddressToCartEvent event) async* {
    if (event is AddShippingAddressToCartEvent) {
      yield (ShippingAddressAddingState());

      try {
        final shippingAddress = await _cartService.setShippingAddress(
          event.addressData,
          event.cartId,
        );

        final validAddress = shippingAddress.validAddress;
        if (validAddress?.postcode != null &&
            !validAddress.postcode.startsWith(event.addressData.zip)) {
          yield ShippingAddressZipMismatchFailure();
          return;
        }

        final address1 = validAddress.street?.first;
        final address2 = (validAddress.street.length > 1
            ? validAddress.street.elementAt(1)
            : '');

        final address = AddressData(
          firstName: validAddress.firstname,
          lastName: validAddress.lastname,
          address1: address1,
          address2: address2,
          city: validAddress.city,
          country: validAddress.country_id,
          phone: validAddress.telephone,
          state: validAddress.region_code,
          zip: validAddress.postcode,
        );

        yield (ShippingAddressValidationSuccess(verifiedAddress: address));
      } on ShippingAddressException catch (e) {
        yield (ShippingAddressValidationFailure(errorMessage: e.message));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield (ShippingAddressValidationFailure(
            errorMessage: genericErrorMessage));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
  }
}
