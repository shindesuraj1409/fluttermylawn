import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/help_data.dart';

abstract class HelpState extends Equatable {
  const HelpState();

  @override
  List<Object> get props => [];
}

class HelpInitialState extends HelpState {}

class HelpLoadingState extends HelpState {}

class HelpSuccessState extends HelpState {
  final List<HelpData> helpList;
  final String helpPage;

  HelpSuccessState(this.helpList, this.helpPage);

  @override
  List<Object> get props => [helpList, helpPage];
}

class HelpErrorState extends HelpState {
  final String errorMessage;

  HelpErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
