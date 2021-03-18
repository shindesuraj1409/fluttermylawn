part of 'article_bloc_bloc.dart';

abstract class ArticleBlocEvent extends Equatable {
  const ArticleBlocEvent();

  @override
  List<Object> get props => [];
}

class ArticleFetch extends ArticleBlocEvent {
  final String articleId;

  ArticleFetch(this.articleId);
  @override
  List<Object> get props => [articleId];
}

class ArticleOpened extends ArticleBlocEvent {}
