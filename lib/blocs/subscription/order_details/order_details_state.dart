part of 'order_details_bloc.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsError extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final List<OrderData> orders;
  OrderDetailsSuccess({
    this.orders,
  });
  @override
  List<Object> get props => [orders];
}
