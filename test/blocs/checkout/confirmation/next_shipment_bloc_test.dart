import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/checkout/confirmation/next_shipment_bloc.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';

import '../../../resources/subscription_data.dart';

class MockFindSubscriptionsService extends Mock
    implements FindSubscriptionsByCustomerIdService {}

class MockAdobeRepository extends Mock implements AdobeRepository {}

void main() {
  group('NextShipmentBloc', () {
    FindSubscriptionsByCustomerIdService service;
    MockAdobeRepository adobeRepository;

    final customerId = 'f465feed-bc48-4062-a4c8-6ce5a0160cb3';

    final subscriptions = List<SubscriptionData>.from(
      subscriptionData.map(
            (subscription) => SubscriptionData.fromMap(subscription),
          ) ??
          [],
    );

    final shipments = subscriptions.first.shipments;
    // Get first "Subscription Products" shipment
    // and shipmentDate
    final firstSubscriptionShipment =
        shipments.firstWhere((shipment) => shipment.planCode != 'add-ons');
    final firstShipmentDate =
        firstSubscriptionShipment.products.first.shippingStartDate;

    // Get "Add-on Products" shipment
    final addOnShipment = shipments.firstWhere(
        (shipment) => shipment.planCode == 'add-ons',
        orElse: () => null);

    // See if there is "Add-on Products" shipment contains any
    // product with shipping date before or same as first
    // "Subscription Products" shipment
    final addOnProductsInFirstShipment = addOnShipment?.products
            ?.where((product) =>
                product.shippingStartDate.isBefore(
                  firstShipmentDate,
                ) ||
                product.shippingStartDate
                        .difference(firstShipmentDate)
                        .inDays ==
                    0)
            ?.toList() ??
        [];

    final shipmentProducts = [
      ...firstSubscriptionShipment.products,
      ...addOnProductsInFirstShipment
    ];

    setUp(() {
      service = MockFindSubscriptionsService();
      adobeRepository = MockAdobeRepository();
    });

    test(
        'throws AssertionError when FindSubscriptionsByCustomerIdService is null',
        () {
      expect(
          () =>
              NextShipmentBloc(service: null, adobeRepository: adobeRepository),
          throwsAssertionError);
    });

    test('initial state is NextShipmentInitial()', () {
      final bloc =
          NextShipmentBloc(service: service, adobeRepository: adobeRepository);
      expect(bloc.state, NextShipmentInitial());
      bloc.close();
    });

    group('Get Shipments', () {
      blocTest<NextShipmentBloc, NextShipmentState>(
        'invokes [findSubscriptionsByCustomerId] when [NextShipmentEvent] is sent',
        build: () => NextShipmentBloc(
            service: service, adobeRepository: adobeRepository),
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        verify: (_) {
          verify(service.findSubscriptionsByCustomerId(customerId)).called(1);
        },
      );

      blocTest<NextShipmentBloc, NextShipmentState>(
        'invokes [findSubscriptionsByCustomerId] when [NextShipmentEvent] is sent on re-try',
        build: () => NextShipmentBloc(
            service: service, adobeRepository: adobeRepository),
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        seed: NextShipmentError(errorMessage),
        verify: (_) {
          verify(service.findSubscriptionsByCustomerId(customerId)).called(1);
        },
      );

      blocTest<NextShipmentBloc, NextShipmentState>(
        'emits [NextShipmentLoading, NextShipmentSuccess] when service returns a valid Subscription',
        build: () {
          when(service.findSubscriptionsByCustomerId(customerId))
              .thenAnswer((_) async => subscriptions);
          return NextShipmentBloc(
              service: service, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        expect: <NextShipmentState>[
          NextShipmentLoading(),
          NextShipmentSuccess(
              products: shipmentProducts, firstShipmentDate: firstShipmentDate),
        ],
      );

      blocTest<NextShipmentBloc, NextShipmentState>(
        'emits [NextShipmentLoading, NextShipmentSuccess] when retried after failure and service returns a valid subscription on 2nd attempt',
        build: () {
          when(service.findSubscriptionsByCustomerId(customerId))
              .thenAnswer((_) async => subscriptions);
          return NextShipmentBloc(
              service: service, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        seed: NextShipmentError(errorMessage),
        expect: <NextShipmentState>[
          NextShipmentLoading(),
          NextShipmentSuccess(
              products: shipmentProducts, firstShipmentDate: firstShipmentDate),
        ],
      );

      blocTest<NextShipmentBloc, NextShipmentState>(
        'emits [NextShipmentLoading, NextShipmentError] when service throws [FindSubscriptionByCustomerIdException]',
        build: () {
          when(service.findSubscriptionsByCustomerId(customerId))
              .thenThrow(FindSubscriptionByCustomerIdException());
          return NextShipmentBloc(
              service: service, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        expect: <NextShipmentState>[
          NextShipmentLoading(),
          NextShipmentError(errorMessage),
        ],
      );

      blocTest<NextShipmentBloc, NextShipmentState>(
        'emits [NextShipmentLoading, NextShipmentError] when service throws Generic Exception',
        build: () {
          when(service.findSubscriptionsByCustomerId(customerId))
              .thenThrow(Exception());
          return NextShipmentBloc(
              service: service, adobeRepository: adobeRepository);
        },
        act: (bloc) => bloc.add(NextShipmentEvent(customerId)),
        expect: <NextShipmentState>[
          NextShipmentLoading(),
          NextShipmentError(errorMessage),
        ],
      );
    });
  });
}
