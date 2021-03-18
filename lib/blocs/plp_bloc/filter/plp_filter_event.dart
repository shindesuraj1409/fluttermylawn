import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';

abstract class PlpFilterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlpInitialFilterEvent extends PlpFilterEvent {
  final ProductCategory productCategory;
  final List<ProductFilterBlockData> filters;
  final List<Product> productList;
  final Bloc plpBloc;

  PlpInitialFilterEvent({
    this.plpBloc,
    this.productCategory,
    this.productList,
    this.filters,
  });

  @override
  List<Object> get props => [productCategory, productList, plpBloc, filters];
}

class PlpAddFilterEvent extends PlpFilterEvent {
  final ProductFilterBlockData filter;

  PlpAddFilterEvent({this.filter});

  @override
  List<Object> get props => [filter];
}

class PlpRemoveFilterEvent extends PlpFilterEvent {
  final ProductFilterBlockData filter;

  PlpRemoveFilterEvent({this.filter});

  @override
  List<Object> get props => [filter];
}
