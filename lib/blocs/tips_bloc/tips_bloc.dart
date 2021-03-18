import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

const tipsPerLoad = 10;
const videoTab = 'videos';
const articleTab = 'articles';
const latestTab = 'latest';

class TipsBloc extends Bloc<TipsEvent, TipsState> {
  final TipsService _tipsService;
  List<TipsArticleData> _bodyArticles;
  List<TipsArticleData> _heroArticles;
  List<FilterBlockData> _filters;

  TipsBloc({TipsService tipsService})
      : _tipsService = tipsService ?? registry<TipsService>(),
        super(TipsInitial());

  @override
  Stream<Transition<TipsEvent, TipsState>> transformEvents(
    Stream<TipsEvent> events,
    TransitionFunction<TipsEvent, TipsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<TipsState> mapEventToState(TipsEvent event) async* {
    final currentState = state;
    if (event is TabChanged) {
      if (currentState is TipsLoadSuccess &&
          currentState.appliedFilters.isEmpty) {
        yield currentState.copyWith(hasReachedMax: false);
      }
    }
    if ((event is TipsFetchEvent) && !_hasReachedMax(currentState)) {
      try {
        if (currentState is TipsLoadSuccess && event is InitialTipsFetch) {
          yield currentState;
        }

        if (currentState is TipsInitial) {
          yield TipsLoadInProgress();
          _bodyArticles = await _tipsService.getBodyTips();
          _heroArticles = await _tipsService.getHeroTips();
          _filters = await _tipsService.getFilters();
          if (_bodyArticles.isEmpty) {
            throw Error;
          }
          yield FiltersFetched(articles: _bodyArticles, filters: _filters);

          final articlesPerTab = getArticlesPerTab(_bodyArticles);
          final latest = articlesPerTab[latestTab];
          final videos = articlesPerTab[videoTab];
          final articles = articlesPerTab[articleTab];

          yield TipsLoadSuccess(
            heroTips: _heroArticles,
            bodyTips: _bodyArticles,
            latest: latest,
            videos: videos,
            articles: articles,
            filters: _filters,
            appliedFilters: [],
            hasReachedMax: false,
          );
        }
        if (currentState is TipsLoadSuccess) {
          if (event is ArticleTipsFetch) {
            final tips = _fetchPosts(
                source: _bodyArticles
                    .where((element) => !element.isVideoArticle)
                    .toList(),
                offset: currentState.articles.length);
            yield tips.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : TipsLoadSuccess(
                    filters: currentState.filters,
                    heroTips: currentState.heroTips,
                    bodyTips: _bodyArticles,
                    articles: currentState.articles + tips,
                    appliedFilters: [],
                    latest: currentState.latest,
                    videos: currentState.videos,
                    hasReachedMax: false,
                  );
          }
          if (event is VideoTipsFetch) {
            final tips = _fetchPosts(
                source: _bodyArticles
                    .where((element) => element.isVideoArticle)
                    .toList(),
                offset: currentState.videos.length);
            yield tips.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : TipsLoadSuccess(
                    filters: currentState.filters,
                    heroTips: currentState.heroTips,
                    bodyTips: _bodyArticles,
                    articles: currentState.articles,
                    latest: currentState.latest,
                    videos: currentState.videos + tips,
                    appliedFilters: [],
                    hasReachedMax: false,
                  );
          }
          if (event is LatestTipsFetch) {
            final tips = _fetchPosts(
                source: _bodyArticles, offset: currentState.latest.length);
            yield tips.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : TipsLoadSuccess(
                    filters: currentState.filters,
                    heroTips: currentState.heroTips,
                    bodyTips: _bodyArticles,
                    articles: currentState.articles,
                    latest: currentState.latest + tips,
                    videos: currentState.videos,
                    appliedFilters: [],
                    hasReachedMax: false,
                  );
          }
        }
      } catch (exception) {
        yield TipsLoadFailure(
            errorMessage: 'Something went wrong. Please try again');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
    if (event is TipsFilter) {
      final filters = event.tipsIdList;
      final filteredArticles = <TipsArticleData>[];
      for (var filter in filters) {
        filteredArticles.addAll(_bodyArticles
            .where((article) => article.typeIdList.contains(filter)));
      }
      final result =
          LinkedHashSet<TipsArticleData>.from(filteredArticles).toList();
      yield TipsLoadSuccess(
          filters: _filters,
          heroTips: _heroArticles,
          bodyTips: filteredArticles,
          videos: filteredArticles
              .where((element) => element.isVideoArticle)
              .toList(),
          articles: filteredArticles
              .where((element) => !element.isVideoArticle)
              .toList(),
          latest: filteredArticles,
          filteredTips: result,
          appliedFilters: event.tipsIdList,
          hasReachedMax: true);
    }
    if (event is TipsClearedFilter) {
      final articlesPerTab = getArticlesPerTab(_bodyArticles);
      final latest = articlesPerTab[latestTab];
      final videos = articlesPerTab[videoTab];
      final articles = articlesPerTab[articleTab];

      yield TipsLoadSuccess(
          filters: _filters,
          heroTips: _heroArticles,
          bodyTips: _bodyArticles,
          articles: articles,
          latest: latest,
          videos: videos,
          appliedFilters: [],
          hasReachedMax: false);
    }
  }

  bool _hasReachedMax(TipsState state) =>
      state is TipsLoadSuccess && state.hasReachedMax;

  List<TipsArticleData> _fetchPosts(
      {@required List<TipsArticleData> source, int offset}) {
    assert(source != null, 'source is null');
    var limit = tipsPerLoad;
    final quantity = source.length;
    if (offset > quantity) return [];

    if (limit > quantity) {
      limit = quantity;
    }
    if (offset + limit > quantity) {
      limit = quantity - offset;
    }
    return source.sublist(offset, offset + limit);
  }

  Map<String, List<TipsArticleData>> getArticlesPerTab(
      List<TipsArticleData> articles) {
    final videos = _bodyArticles
        .where((element) => element.isVideoArticle)
        .take(tipsPerLoad)
        .toList();
    final articles = _bodyArticles
        .where((element) => !element.isVideoArticle)
        .take(tipsPerLoad)
        .toList();
    final latest = _bodyArticles.take(tipsPerLoad).toList();

    return {videoTab: videos, articleTab: articles, latestTab: latest};
  }
}
