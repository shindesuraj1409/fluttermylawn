import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';

abstract class PlpEvent extends Equatable {
  const PlpEvent();

  @override
  List<Object> get props => [];
}

class PlpInitialLoadEvent extends PlpEvent {
  final ProductCategory category;

  PlpInitialLoadEvent({this.category});
  @override
  List<Object> get props => [category];
}

class PlpApplyFilterEvent extends PlpEvent {
  final List<ProductFilterBlockData> appliedFilters;
  final List<Product> productList;

  PlpApplyFilterEvent({this.appliedFilters, this.productList});

  @override
  List<Object> get props => [appliedFilters, productList];
}

class PlpClearFilterEvent extends PlpEvent {}
