import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_lawn/data/address_data.dart';

abstract class ShippingAddressState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShippingAddressInitialState extends ShippingAddressState {}

class ShippingAddressAddingState extends ShippingAddressState {}

class ShippingAddressValidationFailure extends ShippingAddressState {
  final String errorMessage;
  ShippingAddressValidationFailure({
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class ShippingAddressValidationSuccess extends ShippingAddressState {
  final AddressData verifiedAddress;
  ShippingAddressValidationSuccess({
    @required this.verifiedAddress,
  });

  @override
  List<Object> get props => [verifiedAddress];
}

class ShippingAddressZipMismatchFailure extends ShippingAddressState {}
