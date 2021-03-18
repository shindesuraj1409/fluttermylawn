part of 'article_bloc_bloc.dart';

abstract class ArticleBlocState extends Equatable {
  const ArticleBlocState();

  @override
  List<Object> get props => [];
}

class ArticleBlocInitial extends ArticleBlocState {}

class ArticleBlocLoading extends ArticleBlocState {}

class ArticleBlocError extends ArticleBlocState {}

class ArticleBlocSuccess extends ArticleBlocState {
  final TipsArticleData article;

  ArticleBlocSuccess(this.article);
  @override
  List<Object> get props => [article];
}
