import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_data.dart';

abstract class PlpSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlpSearchInitialState extends PlpSearchState {}

class PlpSearchInitializedState extends PlpSearchState {}

class PlpSearchLoadingState extends PlpSearchState {}

class PlpSearchErrorState extends PlpSearchState {
  final String errorMessage;

  PlpSearchErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class PlpSearchUpdatedState extends PlpSearchState {
  final List<Product> productList;

  PlpSearchUpdatedState({this.productList});

  @override
  List<Object> get props => productList;
}
