import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/product/product_data.dart';

abstract class PlpSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlpSearchInitialEvent extends PlpSearchEvent {
  final List<Product> productList;

  PlpSearchInitialEvent({this.productList});

  @override
  List<Object> get props => [productList];
}

class PlpSearchUpdateEvent extends PlpSearchEvent {
  final String searchString;

  PlpSearchUpdateEvent(this.searchString);

  @override
  List<Object> get props => [searchString];
}
