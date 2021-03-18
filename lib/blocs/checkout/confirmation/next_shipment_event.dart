part of 'next_shipment_bloc.dart';

class NextShipmentEvent extends Equatable {
  final String customerId;
  const NextShipmentEvent(this.customerId);

  @override
  List<Object> get props => [customerId];
}
