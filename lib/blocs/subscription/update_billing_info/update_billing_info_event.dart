part of 'update_billing_info_bloc.dart';

class UpdateBillingInfoEvent extends Equatable {
  final CreditCardData creditCardData;
  final AddressData billingAddress;

  const UpdateBillingInfoEvent({
    this.creditCardData,
    @required this.billingAddress,
  });

  @override
  List<Object> get props => [
        creditCardData,
        billingAddress,
      ];
}
