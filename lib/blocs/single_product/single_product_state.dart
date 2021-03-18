part of 'single_product_bloc.dart';

abstract class SingleProductState extends Equatable {
  const SingleProductState();

  @override
  List<Object> get props => [];
}

class SingleProductInitial extends SingleProductState {}

class SingleProductLoading extends SingleProductState {}

class SingleProductSuccess extends SingleProductState {
  final Product product;
  final String title;

  SingleProductSuccess({
    this.product,
    this.title,
  });

  @override
  List<Object> get props => [product, title];
}

class SingleProductError extends SingleProductState {}
