import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';

abstract class SkippingReasonsState extends Equatable {
  const SkippingReasonsState();

  @override
  List<Object> get props => [];
}

class SkippingReasonsInitialState extends SkippingReasonsState {}

class SkippingReasonsLoadingState extends SkippingReasonsState {}

class SkippingReasonsSuccessState extends SkippingReasonsState {
  final List<SkippingReasons> skippingReasonsList;

  SkippingReasonsSuccessState({this.skippingReasonsList});

  @override
  List<Object> get props => [skippingReasonsList];
}

class SkippingReasonsErrorState extends SkippingReasonsState {
  final String errorMessage;

  SkippingReasonsErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
