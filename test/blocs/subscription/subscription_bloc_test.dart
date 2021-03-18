import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/services/subscription/modify_subscription/modify_subscription_service.dart';

class MockFindSubscriptionByCustomerIdService extends Mock
    implements FindSubscriptionsByCustomerIdService {}

class MockModifySubscriptionService extends Mock
    implements ModifySubscriptionService {}

class MockSameRecommendationAuthenticationBloc extends Mock
    implements AuthenticationBloc {
  @override
  AuthenticationState get state =>
      AuthenticationState.loggedIn(sameRecommendationUser, LawnData());
}

class MockDifferentRecommendationAuthenticationBloc extends Mock
    implements AuthenticationBloc {
  @override
  AuthenticationState get state =>
      AuthenticationState.loggedIn(differentRecommendationUser, LawnData());
}

const customerId = 'customerId';
const subscriptionId = 123;
const recommendationId = 'recommendationId';
const differentRecommendationId = 'differentRecommendationId';
final sameRecommendationUser = User(
  email: 'test@test.com',
  recommendationId: recommendationId,
  customerId: customerId,
);
final differentRecommendationUser = User(
  email: 'test@test.com',
  recommendationId: differentRecommendationId,
  customerId: customerId,
);

void main() {
  group('SubscriptionBloc', () {
    SubscriptionBloc bloc;
    SubscriptionBloc differentRecommendationBloc;
    FindSubscriptionsByCustomerIdService findSubscriptionByCustomeridService;
    ModifySubscriptionService modifySubscriptionService;

    final authenticationBloc = MockSameRecommendationAuthenticationBloc();
    final differentAuthenticationBloc =
        MockDifferentRecommendationAuthenticationBloc();

    final subscriptionDataActive = SubscriptionData(
        subscriptionStatus: SubscriptionStatus.active, id: subscriptionId);
    final subxListActive = <SubscriptionData>[subscriptionDataActive];

    final subscriptionDataPending =
        SubscriptionData(subscriptionStatus: SubscriptionStatus.pending);
    final subxListPending = <SubscriptionData>[subscriptionDataPending];

    final subscriptionDataCanceled = SubscriptionData(
        subscriptionStatus: SubscriptionStatus.canceled,
        recommendationId: sameRecommendationUser.recommendationId);
    final subxListCanceled = <SubscriptionData>[subscriptionDataCanceled];

    final subscriptionDataNone =
        SubscriptionData(subscriptionStatus: SubscriptionStatus.none);
    final subxListNone = <SubscriptionData>[subscriptionDataNone];

    final subxListEmpty = <SubscriptionData>[];

    setUp(() {
      findSubscriptionByCustomeridService =
          MockFindSubscriptionByCustomerIdService();
      modifySubscriptionService = MockModifySubscriptionService();
      bloc = SubscriptionBloc(
          findSubscriptionByCustomeridService, modifySubscriptionService,
          authenticationBloc: authenticationBloc);
      differentRecommendationBloc = SubscriptionBloc(
          findSubscriptionByCustomeridService, modifySubscriptionService,
          authenticationBloc: differentAuthenticationBloc);
    });

    tearDown(() {
      bloc.close();
      differentRecommendationBloc.close();
      authenticationBloc.close();
      differentAuthenticationBloc.close();
    });

    test('throws AssertionError when SubscriptionBloc is null', () {
      expect(() => SubscriptionBloc(null, null), throwsAssertionError);
    });

    test('initial state is SubscriptionState.none()', () {
      expect(bloc.state, SubscriptionState.none());
    });

    group('FindSubscription event states', () {
      blocTest<SubscriptionBloc, SubscriptionState>(
          'emits [SubscriptionState, SubscriptionState.active()]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListActive);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          verify: (_) => verify(findSubscriptionByCustomeridService
                  .findSubscriptionsByCustomerId(customerId))
              .called(1));

      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionStatus.loading, SubscriptionStatus.active]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListActive);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.active(subxListActive, SubscriptionStatus.active),
          ]);

      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionStatus.loading, SubscriptionState.pending]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListPending);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.pending(
                subxListPending, SubscriptionStatus.pending),
          ]);
      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionStatus.loading, SubscriptionState.canceled]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListCanceled);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.canceled(
                subxListCanceled, SubscriptionStatus.canceled),
          ]);
      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionStatus.loading, SubscriptionState.none] when canceled and has a new recommendationId',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListCanceled);
            return differentRecommendationBloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.none(),
          ]);
      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionStatus.loading, SubscriptionState.none]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListNone);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.none(),
          ]);
      blocTest<SubscriptionBloc, SubscriptionState>(
          'when empty expects [SubscriptionStatus.loading, SubscriptionState.none]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListEmpty);
            return bloc;
          },
          act: (bloc) => bloc.add(FindSubscription(customerId)),
          expect: <SubscriptionState>[
            SubscriptionState.loading(),
            SubscriptionState.none(),
          ]);
    });
    group('SubscritionModificationPreview event states', () {
      blocTest<SubscriptionBloc, SubscriptionState>(
          'emits [SubscriptionState, SubscriptionState.preview()]',
          build: () {
            when(findSubscriptionByCustomeridService
                    .findSubscriptionsByCustomerId(customerId))
                .thenAnswer((_) async => subxListActive);
            when(modifySubscriptionService.modificationPreview(
                    subscriptionId.toString(), recommendationId))
                .thenAnswer((_) async => subxListActive);
            return bloc;
          },
          act: (bloc) {
            bloc.add(FindSubscription(customerId));
            bloc.add(SubscriptionModificationPreview(recommendationId));
          },
          verify: (_) => verify(modifySubscriptionService.modificationPreview(
                  subscriptionId.toString(), recommendationId))
              .called(1));
      blocTest<SubscriptionBloc, SubscriptionState>(
          'expects [SubscriptionState, SubscriptionState.preview()]',
          build: () {
        when(findSubscriptionByCustomeridService
                .findSubscriptionsByCustomerId(customerId))
            .thenAnswer((_) async => subxListActive);
        when(modifySubscriptionService.modificationPreview(
                subscriptionId.toString(), recommendationId))
            .thenAnswer((_) async => subxListActive);
        return bloc;
      }, act: (bloc) {
        bloc.add(FindSubscription(customerId));
        bloc.add(SubscriptionModificationPreview(recommendationId));
      }, expect: <SubscriptionState>[
        SubscriptionState.loading(),
        SubscriptionState.active(subxListActive, SubscriptionStatus.active),
        SubscriptionState.preview(subxListActive),
      ]);
    });
  });
}
