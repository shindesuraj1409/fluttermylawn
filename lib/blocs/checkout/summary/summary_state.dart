import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';

abstract class OrderSummaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderSummaryInitialState extends OrderSummaryState {}

class OrderSummaryLoadingState extends OrderSummaryState {}

class OrderSummaryFailure extends OrderSummaryState {
  final String errorMessage;
  OrderSummaryFailure({
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class OrderSummarySuccessState extends OrderSummaryState {
  final CartTotals cartTotals;
  OrderSummarySuccessState({
    @required this.cartTotals,
  });

  @override
  List<Object> get props => [cartTotals];
}
