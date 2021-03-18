import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancel_subscription_bloc.dart';
import 'package:my_lawn/services/subscription/cancel_subscription/cancel_subscription_service.dart';

class MockCancelSubscriptionService extends Mock
    implements CancelSubscriptionService {}

void main() {
  group('CancelSubscriptionBloc', () {
    CancelSubscriptionService cancelSubscriptionService;
    const orderId = 'LS0000141941';

    setUp(() {
      cancelSubscriptionService = MockCancelSubscriptionService();
    });

    test('throws AssertionError when CancelSubscriptionBloc is null', () {
      expect(() => CancelSubscriptionBloc(null), throwsAssertionError);
    });

    test('initial state is CancelSubscriptionInitial()', () {
      final bloc = CancelSubscriptionBloc(cancelSubscriptionService);
      expect(bloc.state, CancelSubscriptionStateInitial());
      bloc.close();
    });

    blocTest<CancelSubscriptionBloc, CancelSubscriptionState>(
        'emits [CancelSubscriptionState, CancelSubscriptionSuccess()]',
        build: () => CancelSubscriptionBloc(cancelSubscriptionService),
        act: (bloc) => bloc.add(CancelSubscriptionEvent(orderId)),
        verify: (_) =>
            verify(cancelSubscriptionService.cancelSubscription(orderId))
                .called(1));

    blocTest<CancelSubscriptionBloc, CancelSubscriptionState>(
        'emits [CancelSubscriptionState, CancelSubscriptionSuccess()]',
        build: () => CancelSubscriptionBloc(cancelSubscriptionService),
        act: (bloc) => bloc.add(PreviewSubscriptionRefundEvent(orderId)),
        verify: (_) =>
            verify(cancelSubscriptionService.previewSubscriptionRefund(orderId))
                .called(1));
  });
}
