part of 'next_shipment_bloc.dart';

abstract class NextShipmentState extends Equatable {
  const NextShipmentState();

  @override
  List<Object> get props => [];
}

class NextShipmentInitial extends NextShipmentState {}

class NextShipmentLoading extends NextShipmentState {}

class NextShipmentSuccess extends NextShipmentState {
  final List<ShipmentProduct> products;
  final DateTime firstShipmentDate;
  const NextShipmentSuccess({
    @required this.products,
    @required this.firstShipmentDate,
  });
}

class NextShipmentError extends NextShipmentState {
  final String errorMessage;
  const NextShipmentError(this.errorMessage);
}
