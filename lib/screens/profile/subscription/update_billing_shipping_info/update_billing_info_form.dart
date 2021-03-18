import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/subscription/update_billing_info/update_billing_info_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/models/credit_card_model.dart';
import 'package:my_lawn/screens/checkout/widgets/address_form_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/credit_card_form_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/maybe_spinner_button_widget.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class UpdateBillingInfoForm extends StatefulWidget {
  final AddressData billingAddress;
  final AddressData shippingAddress;
  const UpdateBillingInfoForm({
    @required this.billingAddress,
    @required this.shippingAddress,
  });

  @override
  _UpdateBillingInfoFormState createState() => _UpdateBillingInfoFormState();
}

class _UpdateBillingInfoFormState extends State<UpdateBillingInfoForm> {
  CreditCardData _cardData;
  CreditCardValidity _cardValidity;
  AddressData _billingAddress;
  AddressData _shippingAddress;
  bool _isBillingSameAsShipping = true;

  UpdateBillingInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _cardData = CreditCardData();
    _cardValidity = CreditCardValidity();
    _billingAddress = widget.billingAddress;
    _shippingAddress = widget.shippingAddress;

    _bloc = registry<UpdateBillingInfoBloc>();
  }

  void _onCreditCardChanged({
    CreditCardData data,
    CreditCardIssuer issuer,
    CreditCardValidity validity,
  }) {
    if (data != null) {
      _cardData = data;
    }
    if (validity != null) {
      _cardValidity = validity;
    }
  }

  bool _areAddressFieldsValid() {
    return _isBillingSameAsShipping
        ? true
        : widget.billingAddress != _billingAddress &&
            (_billingAddress.firstName != null &&
                _billingAddress.firstName.isNotEmpty) &&
            (_billingAddress.lastName != null &&
                _billingAddress.lastName.isNotEmpty) &&
            (_billingAddress.address1 != null &&
                _billingAddress.address1.isNotEmpty) &&
            (_billingAddress.city != null && _billingAddress.city.isNotEmpty) &&
            (_billingAddress.state != null &&
                _billingAddress.state.isNotEmpty) &&
            (_billingAddress.phone != null &&
                _billingAddress.phone.isNotEmpty &&
                _billingAddress.phone.length == 14);
  }

  bool _isCardDataEnteredAndInvalid() =>
      (_cardData.number.isNotEmpty ||
          _cardData.expiration.isNotEmpty ||
          _cardData.cvv.isNotEmpty) &&
      !_cardValidity.isValid;

  Future<void> _showDialog({String title, String content}) async {
    final theme = Theme.of(context);
    await showBottomSheetDialog(
      context: context,
      title: Text(
        title,
        style: theme.textTheme.headline2,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 16, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              content,
              style: theme.textTheme.subtitle2.copyWith(height: 1.5),
            ),
            SizedBox(height: 16),
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('UPDATE INFO'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Credit Card',
            style: textTheme.headline5,
          ),
          CreditCardForm(
            initialCreditCard: _cardData,
            padding: const EdgeInsets.only(top: 16),
            onChanged: _onCreditCardChanged,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Text(
              'Billing Address',
              style: textTheme.headline5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Same as Shipping Address',
                style: textTheme.headline6
                    .copyWith(height: 1.43, fontWeight: FontWeight.w600),
              ),
              Switch.adaptive(
                activeColor: theme.colorScheme.primary,
                value: _isBillingSameAsShipping,
                onChanged: (value) {
                  setState(() => _isBillingSameAsShipping = value);
                },
              ),
            ],
          ),
          if (!_isBillingSameAsShipping)
            AddressForm(
              initialAddress: AddressData(),
              padding: const EdgeInsets.only(bottom: 16),
              onChanged: (address) {
                setState(() {
                  _billingAddress = address;
                });
              },
            ),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 32),
            child: BlocConsumer<UpdateBillingInfoBloc, UpdateBillingInfoState>(
              cubit: _bloc,
              listener: (context, state) {
                if (state is UpdateBillingInfoSuccess) {
                  showSnackbar(
                    context: context,
                    text: 'Billing Info updated successfully',
                    duration: Duration(seconds: 2),
                  );
                  Future.delayed(
                    Duration(seconds: 2),
                    () => registry<Navigation>().pop<bool>(true),
                  );
                } else if (state is UpdateBillingInfoError) {
                  showSnackbar(
                    context: context,
                    text: state.errorMessage,
                    duration: Duration(seconds: 2),
                  );
                }
              },
              builder: (context, state) {
                return FractionallySizedBox(
                  widthFactor: 1,
                  child: RaisedButton(
                    child: MaybeSpinnerButton(
                      spinner: state is UpdatingBillingInfo,
                      spinnerText: 'UPDATING BILLING INFO...',
                      text: 'UPDATE BILLING INFO',
                    ),
                    onPressed: !(state is UpdatingBillingInfo) &&
                            _areAddressFieldsValid()
                        ? () {
                            if (_isCardDataEnteredAndInvalid()) {
                              unawaited(
                                _showDialog(
                                  title: 'Credit Card Not Valid',
                                  content:
                                      'We were unable to validate the entered credit card information. '
                                      'Please check that all fields are correct, and try again.',
                                ),
                              );
                              return;
                            }
                            if (_isBillingSameAsShipping) {
                              _bloc.updateBillingInfo(
                                _cardData,
                                _shippingAddress,
                              );
                            } else {
                              _bloc.updateBillingInfo(
                                _cardData,
                                _billingAddress,
                              );
                            }
                          }
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
