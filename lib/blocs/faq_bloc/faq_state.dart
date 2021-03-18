import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/faq_data.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

class FaqInitialState extends FaqState {}

class FaqLoadingState extends FaqState {}

class FaqSuccessState extends FaqState {
  final List<FaqData> faqList;

  FaqSuccessState({this.faqList});

  @override
  List<Object> get props => [faqList];
}

class FaqErrorState extends FaqState {
  final String errorMessage;

  FaqErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
