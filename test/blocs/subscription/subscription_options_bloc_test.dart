import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/subscription_options/subscription_options_bloc.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';

import '../../resources/recommendation_data.dart';

class MockRecommendationService extends Mock implements RecommendationService {}

class MockRecommendationStream extends Mock implements Stream<Recommendation> {}

void main() {
  group(
    'SubscriptionOptionsBloc',
    () {
      RecommendationService recommendationService;
      MockRecommendationStream recommendationStream;

      const recommendationId = '123';
      const invalidRecommendationId = 'xyz';

      final validRecommendation =
          Recommendation.fromJson(validRecommendationData);
      final validPlan = validRecommendation.plan;

      final invalidRecommendation =
          Recommendation.fromJson(invalidRecommendationData);

      final expiredRecommendation =
          Recommendation.fromJson(expiredRecommendationData);

      final emptyRecommendation = Recommendation();

      final exception = NotFoundException();

      setUp(() {
        recommendationService = MockRecommendationService();
        recommendationStream = MockRecommendationStream();
      });

      test('throws AssertionError when RecommendationService is null', () {
        expect(
            () => SubscriptionOptionsBloc(
                  service: null,
                  recommendationStream: null,
                ),
            throwsAssertionError);
      });

      test('throws AssertionError when RecommendationStream is null', () {
        expect(
            () => SubscriptionOptionsBloc(
                  service: recommendationService,
                  recommendationStream: null,
                ),
            throwsAssertionError);
      });

      test('initial state is SubscriptionOptionsState.initial()', () {
        final bloc = SubscriptionOptionsBloc(
          service: recommendationService,
          recommendationStream: recommendationStream,
        );
        expect(bloc.state, SubscriptionOptionsState.initial());
        bloc.close();
      });

      group(
        'Fetch Recommendation Plan',
        () {
          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'invokes [getRecommendation] on [RecommendationService] when [RecommendationStream] cache is empty',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(emptyRecommendation);
              });

              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(recommendationId),
            verify: (_) {
              verify(recommendationService.getRecommendation(recommendationId))
                  .called(1);
            },
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'doesn not invokes [getRecommendation] on [RecommendationService] when [RecommendationStream] cache contains Recommendation',
            build: () {
              when(recommendationStream.first)
                  .thenAnswer((_) async => validRecommendation);
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(recommendationId),
            verify: (_) {
              verifyNever(
                  recommendationService.getRecommendation(recommendationId));
            },
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationSuccess] when [RecommendationStream] cache returns a valid recommendation plan',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(validRecommendation);
              });
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(recommendationId),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationSuccess(
                  validPlan.getUpdatedPlanWithPricesCalculated()),
            ],
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationError] when [RecommendationStream] cache and [RecommendationService] both return an invalid recommendation plan',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(invalidRecommendation);
              });
              when(recommendationService.getRecommendation(recommendationId))
                  .thenAnswer((_) async => invalidRecommendation);
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(recommendationId),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationError(
                  invalidRecommendationPlanErrorMessage),
            ],
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationSuccess] when [RecommendationService] returns a valid recommendation plan',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(emptyRecommendation);
              });
              when(recommendationService.getRecommendation(recommendationId))
                  .thenAnswer((_) async => validRecommendation);
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(recommendationId),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationSuccess(
                  validPlan.getUpdatedPlanWithPricesCalculated()),
            ],
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationError] when [RecommendationService] returns an invalid recommendation plan',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(emptyRecommendation);
              });
              when(recommendationService.getRecommendation(recommendationId))
                  .thenAnswer((_) async => invalidRecommendation);
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.add(FetchRecommendationEvent(recommendationId)),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationError(
                  invalidRecommendationPlanErrorMessage),
            ],
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationError] when [RecommendationService] finds no recommendation plan with recommendationId',
            build: () {
              when(recommendationStream.listen(any))
                  .thenAnswer((Invocation invocation) {
                final callback = invocation.positionalArguments.single;
                return callback(emptyRecommendation);
              });
              when(recommendationService
                      .getRecommendation(invalidRecommendationId))
                  .thenThrow(exception);
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.fetchRecommendation(invalidRecommendationId),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationError(
                  exception.message),
            ],
          );

          blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
            'emits [fetchingRecommendation, fetchRecommendationError] when [RecommendationService] fails with GenericException',
            build: () {
              when(recommendationStream.first)
                  .thenAnswer((_) async => emptyRecommendation);
              when(recommendationService.getRecommendation(recommendationId))
                  .thenThrow(Exception());
              return SubscriptionOptionsBloc(
                service: recommendationService,
                recommendationStream: recommendationStream,
              );
            },
            act: (bloc) => bloc.add(FetchRecommendationEvent(recommendationId)),
            expect: <SubscriptionOptionsState>[
              SubscriptionOptionsState.fetchingRecommendation(),
              SubscriptionOptionsState.fetchRecommendationError(
                  genericErrorMessage),
            ],
          );
        },
      );

      group('Regenerate Recommendation', () {
        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'invokes [regenerateRecommendation] on [RecommendationService] when recommendation plan is expired',
          build: () {
            when(recommendationStream.listen(any))
                .thenAnswer((Invocation invocation) {
              final callback = invocation.positionalArguments.single;
              return callback(expiredRecommendation);
            });
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.fetchRecommendation(recommendationId),
          verify: (_) {
            verify(recommendationService
                    .regenerateRecommendation(recommendationId))
                .called(1);
          },
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'does not invokes [regenerateRecommendation] on [RecommendationService] when recommendation plan is valid(and not expired)',
          build: () {
            when(recommendationStream.listen(any))
                .thenAnswer((Invocation invocation) {
              final callback = invocation.positionalArguments.single;
              return callback(validRecommendation);
            });
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.fetchRecommendation(recommendationId),
          verify: (_) {
            verifyNever(recommendationService
                .regenerateRecommendation(recommendationId));
          },
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'emits [regeneratingRecommendation, regenerateRecommendationSuccess] when [RecommendationService] regenerates a valid recommendation plan',
          build: () {
            when(recommendationStream.listen(any))
                .thenAnswer((Invocation invocation) {
              final callback = invocation.positionalArguments.single;
              return callback(expiredRecommendation);
            });
            when(recommendationService
                    .regenerateRecommendation(recommendationId))
                .thenAnswer((_) async => validRecommendation);
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.fetchRecommendation(recommendationId),
          expect: <SubscriptionOptionsState>[
            SubscriptionOptionsState.fetchingRecommendation(),
            SubscriptionOptionsState.regeneratingRecommendation(),
            SubscriptionOptionsState.regenerateRecommendationSuccess(
                validPlan.getUpdatedPlanWithPricesCalculated()),
          ],
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'emits [regeneratingRecommendation, regenerateRecommendationError] when [RecommendationService] throws NotFoundException',
          build: () {
            when(recommendationStream.listen(any))
                .thenAnswer((Invocation invocation) {
              final callback = invocation.positionalArguments.single;
              return callback(expiredRecommendation);
            });
            when(recommendationService
                    .regenerateRecommendation(recommendationId))
                .thenThrow(NotFoundException());
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.fetchRecommendation(recommendationId),
          expect: <SubscriptionOptionsState>[
            SubscriptionOptionsState.fetchingRecommendation(),
            SubscriptionOptionsState.regeneratingRecommendation(),
            SubscriptionOptionsState.regenerateRecommendationError(
                regenerateRecommendationErrorMessage),
          ],
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'emits [regeneratingRecommendation, regenerateRecommendationError] when [RecommendationService] throws Generic Exception',
          build: () {
            when(recommendationStream.listen(any))
                .thenAnswer((Invocation invocation) {
              final callback = invocation.positionalArguments.single;
              return callback(expiredRecommendation);
            });
            when(recommendationService
                    .regenerateRecommendation(recommendationId))
                .thenThrow(Exception());
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.fetchRecommendation(recommendationId),
          expect: <SubscriptionOptionsState>[
            SubscriptionOptionsState.fetchingRecommendation(),
            SubscriptionOptionsState.regeneratingRecommendation(),
            SubscriptionOptionsState.regenerateRecommendationError(
                regenerateRecommendationErrorMessage),
          ],
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'emits [regeneratingRecommendation, regenerateRecommendationSuccess] when user retries [RecommendationService] regenerate recommendation failure and it succeeds',
          build: () {
            when(recommendationStream.first)
                .thenAnswer((_) async => expiredRecommendation);
            when(recommendationService
                    .regenerateRecommendation(recommendationId))
                .thenAnswer((_) async => validRecommendation);
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.regenerateRecommendation(recommendationId),
          seed: SubscriptionOptionsState.regenerateRecommendationError(
              regenerateRecommendationErrorMessage),
          expect: <SubscriptionOptionsState>[
            SubscriptionOptionsState.regeneratingRecommendation(),
            SubscriptionOptionsState.regenerateRecommendationSuccess(
                validPlan.getUpdatedPlanWithPricesCalculated()),
          ],
        );

        blocTest<SubscriptionOptionsBloc, SubscriptionOptionsState>(
          'emits [regeneratingRecommendation, regenerateRecommendationSuccess] when user retries [RecommendationService] regenerate recommendation failure and it fails again',
          build: () {
            when(recommendationStream.first)
                .thenAnswer((_) async => expiredRecommendation);
            when(recommendationService
                    .regenerateRecommendation(recommendationId))
                .thenThrow(Exception());
            return SubscriptionOptionsBloc(
              service: recommendationService,
              recommendationStream: recommendationStream,
            );
          },
          act: (bloc) => bloc.regenerateRecommendation(recommendationId),
          seed: SubscriptionOptionsState.regenerateRecommendationError(
              regenerateRecommendationErrorMessage),
          expect: <SubscriptionOptionsState>[
            SubscriptionOptionsState.regeneratingRecommendation(),
            SubscriptionOptionsState.regenerateRecommendationError(
                regenerateRecommendationErrorMessage),
          ],
        );
      });
    },
  );
}
