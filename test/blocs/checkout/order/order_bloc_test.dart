import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart' as cart_bloc;
import 'package:my_lawn/blocs/checkout/order/order_bloc.dart';
import 'package:my_lawn/blocs/checkout/order/order_event.dart';
import 'package:my_lawn/blocs/checkout/order/order_state.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/order/i_order_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';

class MockOrderService extends Mock implements OrderService {}

void main() {
  group(
    'OrderBloc',
    () {
      OrderService _orderService;
      final _cartId = 'valid_cart_id';
      final _recommendationId = 'xyz';
      final _cartType = cart_bloc.CartType.annual;
      final _customerId = 'abcd';
      final _selectedSubscriptionType = SubscriptionType.annual;
      final addOnSkus = <String>['1142844', '1142845', '1142846'];
      final _phone = '9999999999';
      final _recurlyToken = 'token';
      final _orderId = 'LS00000';
      final _subscriptionId = null; //No subscription
      setUp(() {
        _orderService = MockOrderService();
      });

      test('throws AssertionError when OrderService is null', () {
        expect(() => OrderBloc(null), throwsAssertionError);
      });

      test('initial state is OrderInitiateInitialState()', () {
        final bloc = OrderBloc(_orderService);
        expect(bloc.state, OrderInitialState());
        bloc.close();
      });

      group('Create Order', () {
        blocTest<OrderBloc, OrderState>(
          'invokes Create Order and Cart Info on [CreateOrderEvent]',
          build: () {
            when(_orderService.createOrder(any))
                .thenAnswer((_) async => _orderId);
            return OrderBloc(_orderService);
          },
          act: (bloc) => bloc.add(CreateOrderEvent(
            _recommendationId,
            _customerId,
            _cartId,
            _cartType,
            addOnSkus,
            _selectedSubscriptionType,
            _phone,
            _recurlyToken,
            _subscriptionId,
          )),
          verify: (_) {
            verify(_orderService.createOrder(any)).called(1);
          },
        );

        blocTest<OrderBloc, OrderState>(
          'emits [CreatingOrderState, OrderSuccessState] when CreateOrder api returns valid order Id',
          build: () {
            when(_orderService.createOrder(any))
                .thenAnswer((_) async => _orderId);
            return OrderBloc(_orderService);
          },
          act: (bloc) => bloc.add(CreateOrderEvent(
            _recommendationId,
            _customerId,
            _cartId,
            _cartType,
            addOnSkus,
            _selectedSubscriptionType,
            _phone,
            _recurlyToken,
            _subscriptionId,
          )),
          expect: <OrderState>[
            CreatingOrderState(),
            OrderSuccessState(_orderId),
          ],
        );

        blocTest<OrderBloc, OrderState>(
          'emits [CreatingOrderState, OrderFailureState] when CreateOrder api fails with OrderException',
          build: () {
            when(_orderService.createOrder(any))
                .thenThrow(OrderException('Unable to place order'));
            return OrderBloc(_orderService);
          },
          act: (bloc) => bloc.add(CreateOrderEvent(
            _recommendationId,
            _customerId,
            _cartId,
            _cartType,
            addOnSkus,
            _selectedSubscriptionType,
            _phone,
            _recurlyToken,
            _subscriptionId,
          )),
          expect: <OrderState>[
            CreatingOrderState(),
            OrderFailureState(errorMessage: 'Unable to place order'),
          ],
        );

        blocTest<OrderBloc, OrderState>(
          'emits [CreatingOrderState, OrderFailureState] when CreateOrder api fails with generic Exception',
          build: () {
            when(_orderService.createOrder(any)).thenThrow(Exception());
            return OrderBloc(_orderService);
          },
          act: (bloc) => bloc.add(CreateOrderEvent(
            _recommendationId,
            _customerId,
            _cartId,
            _cartType,
            addOnSkus,
            _selectedSubscriptionType,
            _phone,
            _recurlyToken,
            _subscriptionId,
          )),
          expect: <OrderState>[
            CreatingOrderState(),
            OrderFailureState(errorMessage: genericErrorMessage),
          ],
        );
      });
    },
  );
}
