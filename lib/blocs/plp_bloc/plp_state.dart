import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';

abstract class PlpState extends Equatable {
  const PlpState();

  @override
  List<Object> get props => [];
}

class PlpInitialState extends PlpState {}

class PlpLoadingState extends PlpState {}

class PlpLoadedState extends PlpState {
  final ProductCategory category;
  final List<Product> productList;
  final List<ProductFilterBlockData> inititalFilters;

  PlpLoadedState({this.inititalFilters, this.productList, this.category});

  @override
  List<Object> get props => [category, productList, inititalFilters];
}

class PlpErrorState extends PlpState {
  final String errorMessage;

  PlpErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
