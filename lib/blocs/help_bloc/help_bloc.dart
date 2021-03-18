import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/help_bloc/help_event.dart';
import 'package:my_lawn/blocs/help_bloc/help_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/help_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:pedantic/pedantic.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final ContentfulService _contentfulService;

  HelpBloc({ContentfulService contentfulService})
      : _contentfulService = contentfulService ?? registry<ContentfulService>(),
        super(HelpInitialState());

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is FetchHelpEvent) {
      yield HelpLoadingState();
      try {
        final contentfulHelpJson = await _contentfulService.getEntries(
          params: {'content_type': 'helpArticle', 'include': '3'},
        );

        final assets = contentfulHelpJson['includes']['Asset'] as List;

        final helpListJson = contentfulHelpJson['items'] as List;

        final helpList = helpListJson
            .map((e) => HelpData.fromJson(json: e, assets: assets))
            .toList();

        yield HelpSuccessState(helpList, event.helpPage);
      } catch (exception) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));

        yield HelpErrorState(
            errorMessage: 'Something went wrong. Please try again');
      }
    }
  }
}
