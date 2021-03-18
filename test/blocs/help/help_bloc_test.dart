import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/help_bloc/help_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_event.dart';
import 'package:my_lawn/blocs/help_bloc/help_state.dart';
import 'package:my_lawn/data/help_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:test/test.dart';

import 'assets.dart';
import 'response.dart';

class MockContentfulService extends Mock implements ContentfulService {}

void main() {
  group('', () {
    ContentfulService contentfulService;
    HelpBloc helpBloc;

    setUp(() {
      contentfulService = MockContentfulService();
      helpBloc = HelpBloc(contentfulService: contentfulService);
    });

    test('initial state is HelpInitialState', () {
      expect(helpBloc.state, HelpInitialState());
      helpBloc.close();
    });

    setUp(() {
      when(contentfulService.getEntries(
          params: {'content_type': 'helpArticle', 'include': '3'})).thenAnswer(
        (_) async => response,
      );
    });

    blocTest<HelpBloc, HelpState>(
      'invokes ContentfulService getEntries',
      build: () => helpBloc,
      act: (bloc) => bloc.add(FetchHelpEvent()),
      verify: (_) {
        verify(contentfulService.getEntries(
            params: {'content_type': 'helpArticle', 'include': '3'})).called(1);
      },
    );

    blocTest<HelpBloc, HelpState>(
      'invokes ContentfulService getEntries',
      build: () => helpBloc,
      act: (bloc) => bloc.add(FetchHelpEvent()),
      verify: (_) {
        verify(contentfulService.getEntries(
            params: {'content_type': 'helpArticle', 'include': '3'})).called(1);
      },
    );

    blocTest<HelpBloc, HelpState>(
      'emits [TipsLoadInProgress, TipsFetched, TipsLoadSuccess] when fetching data succeds',
      build: () => helpBloc,
      act: (bloc) => bloc.add(FetchHelpEvent(helpPage: 'rain')),
      expect: <HelpState>[
        HelpLoadingState(),
        HelpSuccessState(
          [
            HelpData(
              content: {'': ''},
              image:
                  'http://images.ctfassets.net/i52w2h2r1atp/6XW1t2s4DRpgpn8vE7gm9y/e9988ff42e4db80278c09fc15cfbce55/lawn_care_plan.png',
              isAboutTheAppArticle: true,
              title: 'About the app',
              assets: assets,
            ),
          ],
          'rain',
        ),
      ],
    );
  });
}
