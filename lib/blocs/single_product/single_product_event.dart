part of 'single_product_bloc.dart';

abstract class SingleProductEvent extends Equatable {
  const SingleProductEvent();

  @override
  List<Object> get props => [];
}

class SingleProductLoad extends SingleProductEvent {
  final String category;
  final String productId;

  const SingleProductLoad({this.category, this.productId});

  @override
  List<Object> get props => [category, productId];
}

class SingleProductOpened extends SingleProductEvent {}
