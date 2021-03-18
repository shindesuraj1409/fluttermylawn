part of 'order_details_bloc.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();
}

class GetOrderDetails extends OrderDetailsEvent {
  final List<SubscriptionShipment> shipments;

  GetOrderDetails(this.shipments);
  @override
  List<Object> get props => [shipments];
}
