import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/tips_bloc/article_bloc/article_bloc_bloc.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';
import 'package:test/test.dart';

class MockTipsService extends Mock implements TipsService {}

void main() {
  group('Test Artcile Bloc', () {
    ArticleBloc articleBloc;
    TipsService tipsService;
    final articleId = 'articleId';

    setUp(() {
      tipsService = MockTipsService();
      articleBloc = ArticleBloc(tipsService);
    });

    test('Initial state is ArticleBlocInitial', () {
      expect(articleBloc.state, ArticleBlocInitial());
      articleBloc.close();
    });

    group('Fetch Article', () {
      final article = TipsArticleData();

      setUp(() {
        when(tipsService.getArticle(articleId))
            .thenAnswer((_) async => article);
      });
      blocTest<ArticleBloc, ArticleBlocState>(
        'invokes ContentfulService getEntries',
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleFetch(articleId)),
        verify: (_) {
          verify(tipsService.getArticle(articleId)).called(1);
        },
      );
    });
    group('Final state is ArticleBlocInitial', () {
      final article = TipsArticleData();

      setUp(() {
        when(tipsService.getArticle(articleId))
            .thenAnswer((_) async => article);
        articleBloc.add(ArticleFetch(articleId));
      });
      blocTest<ArticleBloc, ArticleBlocState>(
          'invokes ContentfulService getEntries',
          build: () => articleBloc,
          act: (bloc) => bloc.add(ArticleOpened()),
          expect: <ArticleBlocState>[
            ArticleBlocLoading(),
            ArticleBlocSuccess(article),
            ArticleBlocInitial(),
          ]);
    });
  });
}
