import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/data/order_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/subscription/order_details/order_details_service.dart';
import 'package:test/test.dart';

class MockOrderDetailsService extends Mock implements OrderDetailsService {}

void main() {
  group('Test OrderDetailsBloc', () {
    OrderDetailsBloc bloc;
    OrderDetailsService service;

    setUp(() {
      service = MockOrderDetailsService();
      bloc = OrderDetailsBloc(service);
    });

    test('Initial state is OrderDetailsInitial', () {
      expect(bloc.state, OrderDetailsInitial());
      bloc.close();
    });

    group('Get order details', () {
      final orderId = 'pro12312';
      final shipment = SubscriptionShipment(orderId: orderId);
      final shipments = <SubscriptionShipment>[shipment];
      final order = OrderData(orderId: orderId);

      setUp(() {
        when(service.getOrder(orderId)).thenAnswer((_) async => order);
      });

      blocTest<OrderDetailsBloc, OrderDetailsState>(
        'invokes OrderDetailsService getOrder',
        build: () => bloc,
        act: (bloc) => bloc.add(GetOrderDetails(shipments)),
        verify: (_) {
          verify(service.getOrder(orderId)).called(1);
        },
      );
    });

    group('yield OrderDetailsSuccess', () {
      final orderId = 'pro12312';
      final shipment = SubscriptionShipment(orderId: orderId);
      final shipments = <SubscriptionShipment>[shipment];
      final order = OrderData(orderId: orderId);
      final orders = <OrderData>[order];

      setUp(() {
        when(service.getOrder(orderId)).thenAnswer((_) async => order);
      });

      blocTest<OrderDetailsBloc, OrderDetailsState>(
          'yield OrderDetailsSuccess',
          build: () => bloc,
          act: (bloc) => bloc.add(GetOrderDetails(shipments)),
          expect: <OrderDetailsState>[
            OrderDetailsLoading(),
            OrderDetailsSuccess(orders: orders),
          ]);
    });
  });
}
