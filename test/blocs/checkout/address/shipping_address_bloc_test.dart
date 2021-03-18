import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_bloc.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_event.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_state.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/order/order_responses.dart';

import '../../../resources/address_data.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  group(
    'ShippingAddressBloc',
    () {
      CartService _cartService;

      final _validAddress = validAddress;
      final _invalidAddress = inValidAddress;

      final _validAddressResponse =
          ShippingAddressResponse.fromJson(vaildAddressResponse);

      setUp(() {
        _cartService = MockCartService();
      });

      test('throws AssertionError when CartService is null', () {
        expect(() => ShippingAddressBloc(null), throwsAssertionError);
      });

      test('initial state is ShippingAddressInitialState()', () {
        final bloc = ShippingAddressBloc(_cartService);
        expect(bloc.state, ShippingAddressInitialState());
        bloc.close();
      });

      group('Set Shipping Address', () {
        const cartId = 'valid_cart_id';

        blocTest<ShippingAddressBloc, ShippingAddressState>(
          'invokes setShippingAddress on CartService',
          build: () => ShippingAddressBloc(_cartService),
          act: (bloc) =>
              bloc.add(AddShippingAddressToCartEvent(_validAddress, cartId)),
          verify: (_) {
            verify(_cartService.setShippingAddress(validAddress, cartId))
                .called(1);
          },
        );

        blocTest<ShippingAddressBloc, ShippingAddressState>(
          'emits [ShippingAddressAddingState, ShippingAddressValidationSuccess] when user sends correct address with correct zip code',
          build: () {
            when(_cartService.setShippingAddress(_validAddress, cartId))
                .thenAnswer((_) async => _validAddressResponse);
            return ShippingAddressBloc(_cartService);
          },
          act: (bloc) =>
              bloc.add(AddShippingAddressToCartEvent(_validAddress, cartId)),
          expect: <ShippingAddressState>[
            ShippingAddressAddingState(),
            ShippingAddressValidationSuccess(verifiedAddress: _validAddress),
          ],
        );

        blocTest<ShippingAddressBloc, ShippingAddressState>(
          'emits [ShippingAddressAddingState, ShippingAddressZipMismatchFailure] when user sends correct address with wrong zip code',
          build: () {
            when(_cartService.setShippingAddress(any, cartId))
                .thenAnswer((_) async => _validAddressResponse);
            return ShippingAddressBloc(_cartService);
          },
          act: (bloc) =>
              bloc.add(AddShippingAddressToCartEvent(_invalidAddress, cartId)),
          expect: <ShippingAddressState>[
            ShippingAddressAddingState(),
            ShippingAddressZipMismatchFailure(),
          ],
        );

        blocTest<ShippingAddressBloc, ShippingAddressState>(
          'emits [ShippingAddressAddingState, ShippingAddressValidationFailure] when api throws [ShippingAddressException]',
          build: () {
            when(_cartService.setShippingAddress(any, cartId)).thenThrow(
                ShippingAddressException(
                    'The shipping address failed validation.'));
            return ShippingAddressBloc(_cartService);
          },
          act: (bloc) =>
              bloc.add(AddShippingAddressToCartEvent(_invalidAddress, cartId)),
          expect: <ShippingAddressState>[
            ShippingAddressAddingState(),
            ShippingAddressValidationFailure(
                errorMessage: 'The shipping address failed validation.'),
          ],
        );

        blocTest<ShippingAddressBloc, ShippingAddressState>(
          'emits [ShippingAddressAddingState, ShippingAddressValidationFailure] when api throws GenericException',
          build: () {
            when(_cartService.setShippingAddress(_validAddress, cartId))
                .thenThrow(Exception());
            return ShippingAddressBloc(_cartService);
          },
          act: (bloc) =>
              bloc.add(AddShippingAddressToCartEvent(_validAddress, cartId)),
          expect: <ShippingAddressState>[
            ShippingAddressAddingState(),
            ShippingAddressValidationFailure(errorMessage: genericErrorMessage),
          ],
        );
      });
    },
  );
}
