import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';

class TipsFilterBloc extends Bloc<TipsFilterEvent, TipsFilterState> {
  TipsFilterBloc() : super(TipsFilterInitial());
  List<TipsArticleData> articles;

  @override
  Stream<TipsFilterState> mapEventToState(TipsFilterEvent event) async* {
    if (event is TipsFilterInitialLoad) {
      articles = event.filter.articles ?? articles;
      final filter = event.filter.copyWith(articles: articles);
      yield TipsFilterOpened(filter: filter);
    }

    if (event is ApplyTipsFilter) {
      event.filter.applyPartialFilters(event.filterIdList);
      yield TipsBeingFiltered(filter: event.filter);
    }

    if (event is RemoveTipsFilter) {
      event.filter.removePartialFilters(event.filterIdList);
      yield TipsBeingFiltered(filter: event.filter);
    }

    if (event is ShowTipsFiltered) {
      event.filter.appliedFilters = event.filter.partialFilters;
      yield TipsFiltered(filter: event.filter);
    }

    if (event is TipsFilterCanceled) {
      event.filter.partialFilters = [];

      yield TipsFiltered(filter: event.filter);
    }

    if (event is TipsFilterCleared) {
      final filter = event.filter;
      filter.appliedFilters = [];
      filter.partialFilters = [];

      yield TipsFiltered(
        filter: filter,
      );
      yield TipsBeingFiltered(filter: filter);
    }
  }
}
