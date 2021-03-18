import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_bloc.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_event.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_state.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/order/order_responses.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';

import '../../../resources/address_data.dart';
import '../../../resources/credit_card_data.dart';

class MockCartService extends Mock implements CartService {}

class MockRecurlyService extends Mock implements RecurlyService {}

void main() {
  group(
    'PaymentBloc',
    () {
      CartService _cartService;
      RecurlyService _recurlyService;
      final _validAddress = validAddress;
      final _invalidAddress = inValidAddress;
      final _validAddressResponse =
          ShippingAddressResponse.fromJson(vaildBillingAddressResponse);
      final _invalidAddressResponse = inValidAddressResponse;
      final _creditCard = validCreditCard;
      final _recurly_token = 'valid_token';
      final _invalid_recurly_token = 'invalid_recurly_token';

      setUp(() {
        _cartService = MockCartService();
        _recurlyService = MockRecurlyService();
      });

      test('throws AssertionError when CartService is null', () {
        expect(() => PaymentBloc(null, _recurlyService), throwsAssertionError);
      });

      test('throws AssertionError when RecurlyService is null', () {
        expect(() => PaymentBloc(_cartService, null), throwsAssertionError);
      });

      test('initial state is PaymentVerificationInitialState()', () {
        final bloc = PaymentBloc(_cartService, _recurlyService);
        expect(bloc.state, PaymentVerificationInitialState());
        bloc.close();
      });

      group('Set Billing Address', () {
        final cartId = 'valid_cart_id';

        blocTest<PaymentBloc, PaymentVerificationState>(
          'invokes setBillingAddress on CartService',
          build: () => PaymentBloc(_cartService, _recurlyService),
          act: (bloc) => bloc.add(PaymentVerificationEvent(
              _validAddress, _validAddress, _creditCard, cartId)),
          verify: (_) {
            verify(_cartService.setBillingAddress(
                    _validAddress, _validAddress, cartId))
                .called(1);
            verify(_recurlyService.getToken(_validAddress, _creditCard))
                .called(1);
          },
        );

        blocTest<PaymentBloc, PaymentVerificationState>(
          'emits [loading, success] when api returns valid address information',
          build: () {
            when(_cartService.setBillingAddress(
                    _validAddress, _validAddress, cartId))
                .thenAnswer((_) async => _validAddressResponse);
            when(_recurlyService.getToken(_validAddress, _creditCard))
                .thenAnswer((_) async => _recurly_token);
            return PaymentBloc(_cartService, _recurlyService);
          },
          act: (bloc) => bloc.add(PaymentVerificationEvent(
              _validAddress, _validAddress, _creditCard, cartId)),
          expect: <PaymentVerificationState>[
            PaymentVerificationLoadingState(),
            PaymentVerificationVerifiedState(recurly_token: _recurly_token),
          ],
        );

        blocTest<PaymentBloc, PaymentVerificationState>(
          'emits [loading, error] when api returns no address information',
          build: () {
            when(_cartService.setBillingAddress(
                    _invalidAddress, _invalidAddress, cartId))
                .thenThrow(
                    RecurlyException(_invalidAddressResponse['message']));
            when(_recurlyService.getToken(_invalidAddress, _creditCard))
                .thenAnswer((_) async => _invalid_recurly_token);
            return PaymentBloc(_cartService, _recurlyService);
          },
          act: (bloc) => bloc.add(PaymentVerificationEvent(
              _invalidAddress, _invalidAddress, _creditCard, cartId)),
          expect: <PaymentVerificationState>[
            PaymentVerificationLoadingState(),
            PaymentVerificationFailure(
                errorMessage: _invalidAddressResponse['message']),
          ],
        );

        blocTest<PaymentBloc, PaymentVerificationState>(
          'emits [loading, error] when billing address api throws BillingAddressException',
          build: () {
            when(_cartService.setBillingAddress(
                    _invalidAddress, _invalidAddress, cartId))
                .thenThrow(BillingAddressException(
                    _invalidAddressResponse['message']));
            return PaymentBloc(_cartService, _recurlyService);
          },
          act: (bloc) => bloc.add(PaymentVerificationEvent(
              _invalidAddress, _invalidAddress, _creditCard, cartId)),
          expect: <PaymentVerificationState>[
            PaymentVerificationLoadingState(),
            BillingAddressValidationFailure(),
          ],
        );

        blocTest<PaymentBloc, PaymentVerificationState>(
          'emits [loading, error] when api returns no address information',
          build: () {
            when(_cartService.setBillingAddress(
                    _validAddress, _validAddress, cartId))
                .thenThrow(Exception());
            return PaymentBloc(_cartService, _recurlyService);
          },
          act: (bloc) => bloc.add(PaymentVerificationEvent(
              _validAddress, _validAddress, _creditCard, cartId)),
          expect: <PaymentVerificationState>[
            PaymentVerificationLoadingState(),
            PaymentVerificationFailure(errorMessage: genericErrorMessage),
          ],
        );
      });
    },
  );
}
