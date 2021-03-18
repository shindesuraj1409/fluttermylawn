import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_data.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProductState extends ProductState {}

class BlocReadyState extends ProductState {}

class LoadingProductState extends ProductState {}

class ErrorProductState extends ProductState {
  final String errorMessage;

  ErrorProductState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProductFetchedState extends ProductState {
  final Product product;
  final bool isFakeActivity;
  ProductFetchedState({this.product, this.isFakeActivity});

  @override
  List<Object> get props => [product, isFakeActivity];
}
