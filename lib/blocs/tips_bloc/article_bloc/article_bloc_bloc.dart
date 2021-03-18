import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';
import 'package:pedantic/pedantic.dart';

part 'article_bloc_event.dart';
part 'article_bloc_state.dart';

class ArticleBloc extends Bloc<ArticleBlocEvent, ArticleBlocState> {
  final TipsService _service;
  ArticleBloc(this._service)
      : assert(_service != null, 'Tips Service is required to use ArticleBloc'),
        super(ArticleBlocInitial());

  @override
  Stream<ArticleBlocState> mapEventToState(
    ArticleBlocEvent event,
  ) async* {
    if (event is ArticleFetch) {
      try {
        yield ArticleBlocLoading();
        final article = await _service.getArticle(event.articleId);
        yield ArticleBlocSuccess(article);
      } catch (exception) {
        yield ArticleBlocError();
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
    if (event is ArticleOpened) {
      try {
        yield ArticleBlocInitial();
      } catch (exception) {
        yield ArticleBlocError();
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
  }
}
