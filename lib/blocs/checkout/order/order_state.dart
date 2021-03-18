import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderInitialState extends OrderState {}

class CreatingOrderState extends OrderState {}

class OrderFailureState extends OrderState {
  final String errorMessage;
  OrderFailureState({
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class OrderSuccessState extends OrderState {
  final String orderId;
  OrderSuccessState(this.orderId);

  @override
  List<Object> get props => [orderId];
}
