import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/address_data.dart';

class AddShippingAddressToCartEvent extends Equatable {
  final AddressData addressData;
  final String cartId;
  AddShippingAddressToCartEvent(this.addressData, this.cartId);

  @override
  List<Object> get props => [addressData, cartId];
}
