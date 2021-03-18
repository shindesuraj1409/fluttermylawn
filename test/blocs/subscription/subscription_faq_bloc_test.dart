import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_bloc.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_event.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_state.dart';
import 'package:my_lawn/data/faq_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:test/test.dart';

class MockContentfulService extends Mock implements ContentfulService {}

void main() {
  group('', () {
    ContentfulService contentfulService;
    FaqBloc faqBloc;

    setUp(() {
      contentfulService = MockContentfulService();
      faqBloc = FaqBloc(contentfulService: contentfulService);
    });

    test('initial state is FaqInitialState', () {
      expect(faqBloc.state, FaqInitialState());
      faqBloc.close();
    });

    setUp(() {
      when(contentfulService.getEntries(
          params: {'content_type': 'faqBlock', 'include': '3'})).thenAnswer(
        (_) async => {
          'includes': {
            'Entry': [
              {
                'sys': {'id': 'aas'},
                'fields': {
                  'listTitle': 'test',
                  'questionAndAnswer': [
                    {
                      'sys': {'id': 'testQA'}
                    }
                  ]
                },
              },
              {
                'sys': {'id': 'testQA'},
                'fields': {
                  'question': 'tst',
                  'answer': {'': ''},
                  'showOnMobile': true
                },
              },
            ]
          }
        },
      );
    });

    blocTest<FaqBloc, FaqState>(
      'invokes ContentfulService getEntries',
      build: () => faqBloc,
      act: (bloc) => bloc.add(FetchFaqEvent()),
      verify: (_) {
        verify(contentfulService.getEntries(
            params: {'content_type': 'faqBlock', 'include': '3'})).called(1);
      },
    );

    blocTest<FaqBloc, FaqState>(
      'invokes ContentfulService getEntries',
      build: () => faqBloc,
      act: (bloc) => bloc.add(FetchFaqEvent()),
      verify: (_) {
        verify(contentfulService.getEntries(
            params: {'content_type': 'faqBlock', 'include': '3'})).called(1);
      },
    );

    blocTest<FaqBloc, FaqState>(
      'emits [TipsLoadInProgress, TipsFetched, TipsLoadSuccess] when fetching data succeds',
      build: () => faqBloc,
      act: (bloc) => bloc.add(FetchFaqEvent()),
      expect: <FaqState>[
        FaqLoadingState(),
        FaqSuccessState(faqList: [
          FaqData(category: FaqCategory.unknown, faqItems: [
            FaqItem(answer: {'': ''}, question: 'tst')
          ])
        ]),
      ],
    );
  });
}
