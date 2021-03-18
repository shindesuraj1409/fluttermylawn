import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_state.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:test/test.dart';
import 'response.dart';

class MockContentfulService extends Mock implements ContentfulService {}

void main() {
  group('', () {
    ContentfulService contentfulService;
    SkippingReasonsBloc skippingReasons;

    setUp(() {
      contentfulService = MockContentfulService();
      skippingReasons =
          SkippingReasonsBloc(contentfulService: contentfulService);
    });

    test('initial state is HelpInitialState', () {
      expect(skippingReasons.state, SkippingReasonsInitialState());
      skippingReasons.close();
    });

    setUp(() {
      when(contentfulService.getEntries(params: {'content_type': 'skipReason'}))
          .thenAnswer(
        (_) async => response,
      );
    });

    blocTest<SkippingReasonsBloc, SkippingReasonsState>(
      'invokes ContentfulService getEntries',
      build: () => skippingReasons,
      act: (bloc) => bloc.add(FetchSkippingReasonsEvent()),
      verify: (_) {
        verify(contentfulService
            .getEntries(params: {'content_type': 'skipReason'})).called(1);
      },
    );

    blocTest<SkippingReasonsBloc, SkippingReasonsState>(
      'emits [TipsLoadInProgress, TipsFetched, TipsLoadSuccess] when fetching data succeds',
      build: () => skippingReasons,
      act: (bloc) => bloc.add(FetchSkippingReasonsEvent()),
      expect: <SkippingReasonsState>[
        SkippingReasonsLoadingState(),
        SkippingReasonsSuccessState(skippingReasonsList: [
          SkippingReasons(id: 1, reason: 'test'),
        ]),
      ],
    );
  });
}
