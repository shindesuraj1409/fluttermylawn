import 'package:equatable/equatable.dart';

abstract class TipsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class TipsFetchEvent extends TipsEvent {}

class InitialTipsFetch extends TipsFetchEvent {}

class LatestTipsFetch extends TipsFetchEvent {}

class ArticleTipsFetch extends TipsFetchEvent {}

class VideoTipsFetch extends TipsFetchEvent {}

class TabChanged extends TipsEvent {
  final int tab;

  TabChanged({this.tab});

  @override
  List<Object> get props => [tab];
}

class TipsFilter extends TipsEvent {
  final List<String> tipsIdList;

  TipsFilter(
    this.tipsIdList,
  );

  @override
  List<Object> get props => tipsIdList;
}

class TipsClearedFilter extends TipsEvent {}
