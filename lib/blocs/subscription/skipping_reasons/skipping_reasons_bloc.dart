import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:pedantic/pedantic.dart';

class SkippingReasonsBloc
    extends Bloc<SkippingReasonsEvent, SkippingReasonsState> {
  final ContentfulService _contentfulService;

  SkippingReasonsBloc({ContentfulService contentfulService})
      : _contentfulService = contentfulService ?? registry<ContentfulService>(),
        super(SkippingReasonsInitialState());

  @override
  Stream<SkippingReasonsState> mapEventToState(
      SkippingReasonsEvent event) async* {
    if (event is FetchSkippingReasonsEvent) {
      yield SkippingReasonsLoadingState();
      try {
        final contentfulSkippingReasonsJson = await _contentfulService
            .getEntries(params: {'content_type': 'skipReason'});

        final skippingReasonsList =
            contentfulSkippingReasonsJson['items'].toList();

        final List<SkippingReasons> contentfulSkippingReasonsList =
            skippingReasonsList
                .map<SkippingReasons>((e) => SkippingReasons.fromJson(e))
                .toList();

        contentfulSkippingReasonsList.sort((e, j) => e.id.compareTo(j.id));

        yield SkippingReasonsSuccessState(
            skippingReasonsList: contentfulSkippingReasonsList);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));

        yield SkippingReasonsErrorState(
            errorMessage: 'Something went wrong. Please try again');
      }
    }
  }
}
