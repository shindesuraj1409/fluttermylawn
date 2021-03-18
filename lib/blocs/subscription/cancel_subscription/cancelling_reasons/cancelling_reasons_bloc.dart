import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/cancelling_reasons_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:pedantic/pedantic.dart';

class CancellingReasonsBloc
    extends Bloc<CancellingReasonsEvent, CancellingReasonsState> {
  final ContentfulService _contentfulService;

  CancellingReasonsBloc({ContentfulService contentfulService})
      : _contentfulService = contentfulService ?? registry<ContentfulService>(),
        super(CancellingReasonsInitialState());

  @override
  Stream<CancellingReasonsState> mapEventToState(
      CancellingReasonsEvent event) async* {
    if (event is FetchCancellingReasonsEvent) {
      yield CancellingReasonsLoadingState();
      try {
        final contentfulCancellingReasonsJson = await _contentfulService
            .getEntries(params: {'content_type': 'cancelReason'});

        final cancellingReasonsList =
            contentfulCancellingReasonsJson['items'].toList();

        final List<CancellingReasons> contentfulCancellingReasonsList =
            cancellingReasonsList
                .map<CancellingReasons>((e) => CancellingReasons.fromJson(e))
                .toList();

        contentfulCancellingReasonsList.sort((e, j) => e.id.compareTo(j.id));

        yield CancellingReasonsSuccessState(
            cancellingReasonsList: contentfulCancellingReasonsList);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));

        yield CancellingReasonsErrorState(
            errorMessage: 'Something went wrong. Please try again');
      }
    }
  }
}
