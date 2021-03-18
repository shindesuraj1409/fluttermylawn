import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_state.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';
import 'package:test/test.dart';

class MockTipsService extends Mock implements TipsService {}

class MockCrashlyticsService extends Mock implements FirebaseCrashlytics {}

void main() {
  group('', () {
    TipsService tipsService;
    TipsBloc tipsBloc;

    setUp(() {
      tipsService = MockTipsService();
      tipsBloc = TipsBloc(tipsService: tipsService);
    });

    test('initial state is TipsInitial', () {
      expect(tipsBloc.state, TipsInitial());
      tipsBloc.close();
    });

    group('fetch tips', () {
      final article = [TipsArticleData(isVideoArticle: false)];
      final filters = [FilterBlockData()];

      setUp(() {
        when(tipsService.getBodyTips()).thenAnswer((_) async => article);
        when(tipsService.getHeroTips()).thenAnswer((_) async => article);
        when(tipsService.getFilters()).thenAnswer((_) async => filters);
      });

      blocTest<TipsBloc, TipsState>(
        'invokes ContentfulService getEntries',
        build: () => tipsBloc,
        act: (bloc) => bloc.add(InitialTipsFetch()),
        verify: (_) {
          verify(tipsService.getHeroTips()).called(1);
          verify(tipsService.getBodyTips()).called(1);
          verify(tipsService.getFilters()).called(1);
        },
      );
      group('', () {
        TipsService tips9Service;
        TipsBloc tips9Bloc;
        TipsService tips10Service;
        TipsBloc tips10Bloc;
        TipsService tips11Service;
        TipsBloc tips11Bloc;
        final article9 = [
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
        ];
        final article10 = [
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
        ];
        final article11 = [
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
          TipsArticleData(isVideoArticle: false),
        ];
        tearDown(() {
          tips9Bloc.close();
          tips10Bloc.close();
          tips11Bloc.close();
        });

        blocTest<TipsBloc, TipsState>(
          'emits [TipsLoadInProgress, TipsFetched, TipsLoadSuccess] when fetching data succeds',
          build: () => tipsBloc,
          act: (bloc) => bloc.add(InitialTipsFetch()),
          wait: const Duration(milliseconds: 501),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article, filters: filters),
            TipsLoadSuccess(
                heroTips: article,
                bodyTips: article,
                articles: article,
                latest: article,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );

        setUp(() {
          tips9Service = MockTipsService();
          tips9Bloc = TipsBloc(tipsService: tips9Service);
          tips10Service = MockTipsService();
          tips10Bloc = TipsBloc(tipsService: tips10Service);
          tips11Service = MockTipsService();
          tips11Bloc = TipsBloc(tipsService: tips11Service);
          when(tips9Service.getBodyTips()).thenAnswer((_) async => article9);
          when(tips9Service.getHeroTips()).thenAnswer((_) async => article9);
          when(tips9Service.getFilters()).thenAnswer((_) async => filters);
          when(tips10Service.getBodyTips()).thenAnswer((_) async => article10);
          when(tips10Service.getHeroTips()).thenAnswer((_) async => article10);
          when(tips10Service.getFilters()).thenAnswer((_) async => filters);
          when(tips11Service.getBodyTips()).thenAnswer((_) async => article11);
          when(tips11Service.getHeroTips()).thenAnswer((_) async => article11);
          when(tips11Service.getFilters()).thenAnswer((_) async => filters);
        });

        blocTest<TipsBloc, TipsState>(
          'if less than 10 articles are fetched, return all the articles',
          build: () => tips9Bloc,
          act: (bloc) => bloc.add(InitialTipsFetch()),
          wait: const Duration(milliseconds: 501),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article9, filters: filters),
            TipsLoadSuccess(
                heroTips: article9,
                bodyTips: article9,
                articles: article9,
                latest: article9,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );

        blocTest<TipsBloc, TipsState>(
          'if exactly 10 articles are fetched, return all the articles',
          build: () => tips10Bloc,
          act: (bloc) => bloc.add(InitialTipsFetch()),
          wait: const Duration(milliseconds: 501),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article10, filters: filters),
            TipsLoadSuccess(
                heroTips: article10,
                bodyTips: article10,
                articles: article10,
                latest: article10,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );

        blocTest<TipsBloc, TipsState>(
          'if more than 10 articles are fetched, return the first 10',
          build: () => tips11Bloc,
          act: (bloc) => bloc.add(InitialTipsFetch()),
          wait: const Duration(milliseconds: 501),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article11, filters: filters),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11.sublist(0, 10),
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );
        blocTest<TipsBloc, TipsState>(
          'try to lazy load more latest articles when there are no more',
          build: () => tips9Bloc,
          act: (bloc) async {
            bloc.add(InitialTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
          },
          wait: const Duration(milliseconds: 1000),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article9, filters: filters),
            TipsLoadSuccess(
                heroTips: article9,
                bodyTips: article9,
                articles: article9,
                latest: article9,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article9,
                bodyTips: article9,
                articles: article9,
                latest: article9,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: true),
          ],
        );
        blocTest<TipsBloc, TipsState>(
          'lazy load more latest articles',
          build: () => tips11Bloc,
          act: (bloc) async {
            bloc.add(InitialTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
          },
          wait: const Duration(milliseconds: 1000),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article11, filters: filters),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11.sublist(0, 10),
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );
        blocTest<TipsBloc, TipsState>(
          'lazy load more latest and non video articles',
          build: () => tips11Bloc,
          act: (bloc) async {
            bloc.add(InitialTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(ArticleTipsFetch());
          },
          wait: const Duration(milliseconds: 1300),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article11, filters: filters),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11.sublist(0, 10),
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11,
                latest: article11,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
          ],
        );
        blocTest<TipsBloc, TipsState>(
          'try to lazy load more latest but max is reached',
          build: () => tips11Bloc,
          act: (bloc) async {
            bloc.add(InitialTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
            await Future.delayed(Duration(milliseconds: 600));
            bloc.add(LatestTipsFetch());
          },
          wait: const Duration(milliseconds: 2500),
          expect: <TipsState>[
            TipsLoadInProgress(),
            FiltersFetched(articles: article11, filters: filters),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11.sublist(0, 10),
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: false),
            TipsLoadSuccess(
                heroTips: article11,
                bodyTips: article11,
                articles: article11.sublist(0, 10),
                latest: article11,
                videos: [],
                appliedFilters: [],
                filters: filters,
                hasReachedMax: true),
          ],
        );
      });
    });
  });
}
