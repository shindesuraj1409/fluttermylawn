import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_state.dart';
import 'package:my_lawn/data/cancelling_reasons_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:test/test.dart';
import 'response.dart';

class MockContentfulService extends Mock implements ContentfulService {}

void main() {
  group('', () {
    ContentfulService contentfulService;
    CancellingReasonsBloc cancellingReasons;

    setUp(() {
      contentfulService = MockContentfulService();
      cancellingReasons =
          CancellingReasonsBloc(contentfulService: contentfulService);
    });

    test('initial state is HelpInitialState', () {
      expect(cancellingReasons.state, CancellingReasonsInitialState());
      cancellingReasons.close();
    });

    setUp(() {
      when(contentfulService
          .getEntries(params: {'content_type': 'cancelReason'})).thenAnswer(
        (_) async => response,
      );
    });

    blocTest<CancellingReasonsBloc, CancellingReasonsState>(
      'invokes ContentfulService getEntries',
      build: () => cancellingReasons,
      act: (bloc) => bloc.add(FetchCancellingReasonsEvent()),
      verify: (_) {
        verify(contentfulService
            .getEntries(params: {'content_type': 'cancelReason'})).called(1);
      },
    );

    blocTest<CancellingReasonsBloc, CancellingReasonsState>(
      'emits [TipsLoadInProgress, TipsFetched, TipsLoadSuccess] when fetching data succeds',
      build: () => cancellingReasons,
      act: (bloc) => bloc.add(FetchCancellingReasonsEvent()),
      expect: <CancellingReasonsState>[
        CancellingReasonsLoadingState(),
        CancellingReasonsSuccessState(cancellingReasonsList: [
          CancellingReasons(id: 1, reason: 'test'),
        ]),
      ],
    );
  });
}
