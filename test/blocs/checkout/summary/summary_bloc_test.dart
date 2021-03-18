import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_bloc.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_event.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_state.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/cart/cart_api_exceptions.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';

import '../../../resources/cart_totals_data.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  group(
    'OrderSummaryBloc',
    () {
      CartService _cartService;
      final _cartId = 'valid_cart_id';
      final _invalidCartId = 'invalid_cart_id';
      final _selectedSubscriptionType = SubscriptionType.annual;
      final _addOnSkus = ['1150831'];
      final cartTotalsForAnnualPlan = CartTotals.fromJson(annualCartTotals);
      final cartTotalsSummaryForAnnualPlan =
          cartTotalsForAnnualPlan.copyWith(cartItems: [
        CartItemData(
          id: -1,
          cartId: _cartId,
          name: 'Annual Subscription',
          rowTotal: 69.96,
          qty: 4,
        )
      ]);

      setUp(() {
        _cartService = MockCartService();
      });

      test('throws AssertionError when CartService is null', () {
        expect(() => OrderSummaryBloc(null), throwsAssertionError);
      });

      test('initial state is OrderSummaryInitialState()', () {
        final bloc = OrderSummaryBloc(_cartService);
        expect(bloc.state, OrderSummaryInitialState());
        bloc.close();
      });

      group('Get Cart Totals', () {
        blocTest<OrderSummaryBloc, OrderSummaryState>(
          'invokes getCartTotals on CartService',
          build: () => OrderSummaryBloc(_cartService),
          act: (bloc) => bloc.add(OrderSummaryEvent(
              _cartId, _selectedSubscriptionType, _addOnSkus)),
          verify: (_) {
            verify(_cartService.getCartTotals(_cartId)).called(1);
          },
        );

        blocTest<OrderSummaryBloc, OrderSummaryState>(
          'emits [loading, success] when api returns valid cart totals',
          build: () {
            when(_cartService.getCartTotals(_cartId))
                .thenAnswer((_) async => cartTotalsForAnnualPlan);
            return OrderSummaryBloc(_cartService);
          },
          act: (bloc) => bloc.add(OrderSummaryEvent(
              _cartId, _selectedSubscriptionType, _addOnSkus)),
          expect: <OrderSummaryState>[
            OrderSummaryLoadingState(),
            OrderSummarySuccessState(
                cartTotals: cartTotalsSummaryForAnnualPlan),
          ],
        );

        blocTest<OrderSummaryBloc, OrderSummaryState>(
          'emits [loading, error] when api returns no cart totals',
          build: () {
            when(_cartService.getCartTotals(_invalidCartId)).thenThrow(
                GetCartTotalsException('Error! Cannot get cart summary'));
            return OrderSummaryBloc(_cartService);
          },
          act: (bloc) => bloc.add(OrderSummaryEvent(
              _invalidCartId, _selectedSubscriptionType, _addOnSkus)),
          expect: <OrderSummaryState>[
            OrderSummaryLoadingState(),
            OrderSummaryFailure(errorMessage: 'Error! Cannot get cart summary'),
          ],
        );

        blocTest<OrderSummaryBloc, OrderSummaryState>(
          'emits [loading, error] when api returns no cart totals',
          build: () {
            when(_cartService.getCartTotals(_cartId)).thenThrow(Exception());
            return OrderSummaryBloc(_cartService);
          },
          act: (bloc) => bloc.add(OrderSummaryEvent(
              _cartId, _selectedSubscriptionType, _addOnSkus)),
          expect: <OrderSummaryState>[
            OrderSummaryLoadingState(),
            OrderSummaryFailure(errorMessage: genericErrorMessage),
          ],
        );
      });
    },
  );
}
