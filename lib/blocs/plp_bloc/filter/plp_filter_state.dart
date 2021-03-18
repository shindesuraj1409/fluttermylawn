import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';

abstract class PlpFilterState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlpFilterInitialState extends PlpFilterState {}

class PlpFilterLoadingState extends PlpFilterState {}

class PlpFilterUpdatingingState extends PlpFilterState {}

class PlpFilterLoadedState extends PlpFilterState {
  final List<Product> productList;
  final List<ProductFilterBlockData> productFilters;
  final List<ProductFilterBlockData> appliedFilters;

  PlpFilterLoadedState(
      {this.productList, this.appliedFilters, this.productFilters});

  @override
  List<Object> get props => [productFilters, appliedFilters, productList];
}

class PlpFilterUpdatedState extends PlpFilterState {
  final List<Product> products;
  final List<ProductFilterBlockData> partialAppliedFilters;

  PlpFilterUpdatedState({this.partialAppliedFilters, this.products});

  @override
  List<Object> get props => [products, partialAppliedFilters];
}

class PlpFilterErrorState extends PlpFilterState {
  final String errorMessage;

  PlpFilterErrorState({this.errorMessage});
}
