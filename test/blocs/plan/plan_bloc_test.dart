import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_state.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/data/user_data.dart';

import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/plan/i_plan_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/utils/plan_state_combinator.dart';
import 'package:test/test.dart';

class MockRecommendationService extends Mock implements RecommendationService {}

class MockPlanService extends Mock implements PlanService {}

class MockActivitiesService extends Mock implements ActivitiesService {}

class MockProductService extends Mock implements ProductsService {}

class MockGuestAuthenticationBloc extends Mock implements AuthenticationBloc {
  @override
  AuthenticationState get state =>
      AuthenticationState.guest(guestUser, LawnData());
}

class MockLoggedInAuthenticationBloc extends Mock
    implements AuthenticationBloc {
  @override
  AuthenticationState get state =>
      AuthenticationState.loggedIn(loggedInUser, LawnData());
}

class MockStateCombinatorStream extends Mock
    implements Stream<PlanStateCombinator> {}

final recommendation = Recommendation(
    recommendationId: 'testabc',
    plan: Plan(
      products: [
        Product(childProducts: [
          Product(
            sku: '000',
          )
        ])
      ],
    ));

final subscription = SubscriptionData(
  subscriptionStatus: SubscriptionStatus.active,
);

final activities = [
  ActivityData(
    recommendationId: 'testabc',
    activityType: ActivityType.recommended,
    childProducts: [Product(sku: '000')],
  )
];

final combination = PlanStateCombinator(
  subscription: subscription,
  recommendation: recommendation,
  activities: activities,
);

final combinationWithoutActivity = PlanStateCombinator(
  subscription: null,
  recommendation: recommendation,
  activities: [],
);

final loggedInUser = User(email: 'test@test.com', recommendationId: 'testabc');
final guestUser = User(recommendationId: 'testabc');

void main() {
  final combinatorStream = MockStateCombinatorStream();
  when(combinatorStream.first).thenAnswer((_) => Future.value(combination));

  group('', () {
    PlanService planService;
    ActivitiesService activitiesService;
    PlanBloc planBloc;
    ProductsService productsService;
    AuthenticationBloc guestAuthenticationBloc;
    AuthenticationBloc loggedInAuthenticationBloc;

    setUp(() {
      planService = MockPlanService();
      activitiesService = MockActivitiesService();
      productsService = MockProductService();
      guestAuthenticationBloc = MockGuestAuthenticationBloc();
      loggedInAuthenticationBloc = MockLoggedInAuthenticationBloc();
      planBloc = PlanBloc(
        stateCombinatorStream: combinatorStream,
        planService: planService,
        activitiesService: activitiesService,
        authenticationBloc: guestAuthenticationBloc,
        productsService: productsService,
      );
    });

    test('initial state is PlanInitialState', () {
      expect(planBloc.state, PlanInitialState());
      planBloc.close();
      guestAuthenticationBloc.close();
      loggedInAuthenticationBloc.close();
    });

    group('when a activity is emmited the state updates', () {
      setUp(() {
        when(activitiesService.copyWithGraphQL()).thenAnswer((_) async => [
              ActivityData(recommendationId: 'testabc', childProducts: [
                Product(childProducts: [Product(sku: '000')])
              ])
            ]);
        when(combinatorStream.listen(any)).thenAnswer((Invocation invocation) {
          final callback = invocation.positionalArguments.single;
          return callback(combination);
        });
        when(planService.copyWithGraphQL(
            plan: recommendation.plan,
            products: ['000'])).thenAnswer((_) async => recommendation.plan);
        when(activitiesService.copyWithGraphQL(
            activities: activities,
            products: ['000'])).thenAnswer((_) async => activities);
        when(productsService.getProducts(skuList: []))
            .thenAnswer((_) async => []);
      });
      blocTest<PlanBloc, PlanState>('',
          build: () => PlanBloc(
                stateCombinatorStream: combinatorStream,
                planService: planService,
                activitiesService: activitiesService,
                productsService: productsService,
                authenticationBloc: loggedInAuthenticationBloc,
              ),
          act: (bloc) => bloc,
          expect: <PlanState>[
            PlanLoadingState(),
            PlanSuccessState(
                recommendationImages: [''],
                plan: Plan(products: [
                  Product(
                      sku: '000',
                      isSubscribed: true,
                      applied: false,
                      isAddedByMe: false,
                      isArchived: false,
                      skipped: false,
                      miniClaim1: '',
                      miniClaim2: '',
                      miniClaim3: '',
                      miniClaimImage1: '',
                      miniClaimImage2: '',
                      miniClaimImage3: '',
                      childProducts: [
                        Product(
                          sku: '000',
                          isSubscribed: true,
                          applied: false,
                          isAddedByMe: false,
                          isArchived: false,
                          skipped: false,
                          miniClaim1: '',
                          miniClaim2: '',
                          miniClaim3: '',
                          miniClaimImage1: '',
                          miniClaimImage2: '',
                          miniClaimImage3: '',
                        )
                      ])
                ]),
                subscription: subscription),
          ]);
    });
    group('', () {
      setUp(() {
        when(combinatorStream.listen(any)).thenAnswer((Invocation invocation) {
          final callback = invocation.positionalArguments.single;
          return callback(combination);
        });
        when(planService.copyWithGraphQL(
            plan: recommendation.plan,
            products: ['000'])).thenAnswer((_) async => recommendation.plan);
      });
      blocTest<PlanBloc, PlanState>(
          'when a recommendation is emmited and is a guest user, the state updates',
          build: () => PlanBloc(
              stateCombinatorStream: combinatorStream,
              planService: planService,
              activitiesService: activitiesService,
              productsService: productsService,
              authenticationBloc: guestAuthenticationBloc),
          act: (bloc) => bloc,
          expect: <PlanState>[
            PlanLoadingState(),
            PlanSuccessState(
              recommendationImages: [''],
              subscription: subscription,
              plan: Plan(products: [
                Product(
                    isSubscribed: false,
                    applied: false,
                    isAddedByMe: false,
                    isArchived: false,
                    skipped: false,
                    childProducts: [
                      Product(
                        sku: '000',
                        isSubscribed: false,
                        applied: false,
                        isAddedByMe: false,
                        isArchived: false,
                        skipped: false,
                      )
                    ])
              ]),
            )
          ]);
    });
  });
}
