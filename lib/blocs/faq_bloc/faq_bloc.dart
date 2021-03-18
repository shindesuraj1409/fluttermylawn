import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_event.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/faq_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:pedantic/pedantic.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final ContentfulService _contentfulService;

  FaqBloc({ContentfulService contentfulService})
      : _contentfulService = contentfulService ?? registry<ContentfulService>(),
        super(FaqInitialState());

  @override
  Stream<FaqState> mapEventToState(FaqEvent event) async* {
    if (event is FetchFaqEvent) {
      yield FaqLoadingState();
      try {
        final contentfulFaqJson = await _contentfulService
            .getEntries(params: {'content_type': 'faqBlock', 'include': '3'});

        final entries = contentfulFaqJson['includes']['Entry'] as List;

        final faqList = entries
            .where((element) => element['fields'].keys.contains('listTitle'))
            .toList();

        final contentfulFaqList =
            faqList.map((e) => FaqData.fromJson(e, entries)).toList();

        yield FaqSuccessState(faqList: contentfulFaqList);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));

        yield FaqErrorState(
            errorMessage: 'Something went wrong. Please try again');
      }
    }
  }
}
