import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';

abstract class TipsState extends Equatable {
  const TipsState();
  @override
  List<Object> get props => [];
}

class TipsInitial extends TipsState {}

class TipsLoadInProgress extends TipsState {}

class FiltersFetched extends TipsState {
  final List<TipsArticleData> articles;
  final List<FilterBlockData> filters;

  FiltersFetched({this.filters, this.articles});

  @override
  List<Object> get props => [articles, filters];
}

class TipsLoadSuccess extends TipsState {
  final List<TipsArticleData> heroTips;
  final List<TipsArticleData> bodyTips;
  final List<TipsArticleData> videos;
  final List<TipsArticleData> latest;
  final List<TipsArticleData> articles;
  final List<TipsArticleData> filteredTips;
  final List<String> appliedFilters;
  final List<FilterBlockData> filters;
  final bool hasReachedMax;

  TipsLoadSuccess({
    this.videos,
    this.latest,
    this.articles,
    this.appliedFilters,
    @required this.filters,
    @required this.heroTips,
    @required this.bodyTips,
    this.filteredTips,
    this.hasReachedMax,
  }) : assert(heroTips != null && bodyTips != null);

  TipsLoadSuccess copyWith({
    List<TipsArticleData> heroTips,
    List<TipsArticleData> bodyTips,
    List<TipsArticleData> articles,
    List<TipsArticleData> latest,
    List<TipsArticleData> videos,
    List<TipsArticleData> filteredTips,
    List<String> appliedFilters,
    List<FilterBlockData> filters,
    bool hasReachedMax,
  }) {
    return TipsLoadSuccess(
      appliedFilters: appliedFilters ?? this.appliedFilters,
      filters: filters ?? this.filters,
      latest: latest ?? this.latest,
      articles: articles ?? this.articles,
      videos: videos ?? this.videos,
      heroTips: heroTips ?? this.heroTips,
      bodyTips: bodyTips ?? this.bodyTips,
      filteredTips: filteredTips ?? this.filteredTips,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        appliedFilters,
        filters,
        heroTips,
        bodyTips,
        latest,
        articles,
        videos,
        filteredTips,
        hasReachedMax,
      ];
}

class TipsLoadFailure extends TipsState {
  final String errorMessage;

  TipsLoadFailure({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
