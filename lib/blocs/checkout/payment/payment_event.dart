import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';

class PaymentVerificationEvent extends Equatable {
  final AddressData billingData;
  final AddressData shippingData;
  final CreditCardData creditCardData;
  final String cart_mask_id;
  PaymentVerificationEvent(this.billingData, this.shippingData,
      this.creditCardData, this.cart_mask_id);

  @override
  List<Object> get props =>
      [billingData, shippingData, creditCardData, cart_mask_id];
}
