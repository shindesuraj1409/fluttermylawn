import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/cancelling_reasons_data.dart';

abstract class CancellingReasonsState extends Equatable {
  const CancellingReasonsState();

  @override
  List<Object> get props => [];
}

class CancellingReasonsInitialState extends CancellingReasonsState {}

class CancellingReasonsLoadingState extends CancellingReasonsState {}

class CancellingReasonsSuccessState extends CancellingReasonsState {
  final List<CancellingReasons> cancellingReasonsList;

  CancellingReasonsSuccessState({this.cancellingReasonsList});

  @override
  List<Object> get props => [cancellingReasonsList];
}

class CancellingReasonsErrorState extends CancellingReasonsState {
  final String errorMessage;

  CancellingReasonsErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
