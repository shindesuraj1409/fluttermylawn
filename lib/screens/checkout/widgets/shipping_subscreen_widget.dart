import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_bloc.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/checkout/widgets/address_form_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/address_validation_failure_dialog_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/maybe_spinner_button_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/confirmation_screen/state.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';

class ShippingSubscreen extends StatefulWidget {
  final AddressData initialShippingAddress;
  final AddressData disabledAddressFields;
  final String cart_id;

  final Function({
    AddressData shippingAddress,
    bool isDone,
  }) onChanged;

  ShippingSubscreen({
    this.initialShippingAddress,
    this.disabledAddressFields,
    this.cart_id,
    this.onChanged,
  });

  @override
  _ShippingSubscreenState createState() => _ShippingSubscreenState();
}

class _ShippingSubscreenState extends State<ShippingSubscreen> {
  AddressData _shippingAddress;
  ShippingAddressBloc _bloc;
  String _cart_id;
  final addressValidationFailureMessage = '''
We’re sorry, but we could not find your address. Please confirm that you have typed in your address correctly. 
                
If you are still encountering problems, our consumer services team is available to help. Please contact us at''';

  final addressZipMismatchFailureMessage = '''
The products in your plan are based on the ZIP code provided previously in the lawn size step of the quiz. 

The address you have entered does not match your ZIP code. To ship to this address, you will need to create a new plan to ensure the products are suitable for your area. 

For questions, email us at''';
  @override
  void initState() {
    _shippingAddress = widget.initialShippingAddress ?? AddressData();
    _cart_id = widget.cart_id;

    super.initState();

    _bloc = registry<ShippingAddressBloc>();
  }

  bool _validateAddress() {
    return (_shippingAddress.firstName != null &&
            _shippingAddress.firstName.isNotEmpty) &&
        (_shippingAddress.lastName != null &&
            _shippingAddress.lastName.isNotEmpty) &&
        (_shippingAddress.address1 != null &&
            _shippingAddress.address1.isNotEmpty) &&
        (_shippingAddress.city != null && _shippingAddress.city.isNotEmpty) &&
        (_shippingAddress.state != null && _shippingAddress.state.isNotEmpty) &&
        (_shippingAddress.phone != null &&
            _shippingAddress.phone.isNotEmpty &&
            _shippingAddress.phone.length == 14);
  }

  Widget _buildContinueToPaymentButton() {
    return BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
      cubit: _bloc,
      builder: (context, state) {
        return FractionallySizedBox(
          widthFactor: 1,
          child: RaisedButton(
            child: _validateAddress()
                ? MaybeSpinnerButton(
                    spinner: (state is ShippingAddressAddingState),
                    spinnerText: 'VERIFYING ADDRESS',
                    text: 'CONTINUE TO PAYMENT',
                  )
                : Text('CONTINUE TO PAYMENT'),
            onPressed:
                (state is ShippingAddressAddingState || !_validateAddress())
                    ? null
                    : () {
                        if (_validateAddress()) {
                          //TODO: add promocode from AddPromocode dialog
                          registry<AdobeRepository>().trackAppState(
                            CheckoutScreenAdobeState(promoCode: ''),
                          );

                          _bloc.verifyAddress(
                            _shippingAddress,
                            _cart_id,
                          );
                        }
                      },
          ),
        );
      },
      listener: (context, state) {
        if (state is ShippingAddressValidationSuccess) {
          widget.onChanged(
            shippingAddress: _shippingAddress,
            isDone: true,
          );
        } else if (state is ShippingAddressValidationFailure) {
          showAddressValidationFailureDialog(
            context: context,
            title: 'Address Not Found',
            content: addressValidationFailureMessage,
            address: _shippingAddress,
          );
        } else if (state is ShippingAddressZipMismatchFailure) {
          showAddressValidationFailureDialog(
            context: context,
            title: 'Address Must Match Zip Code',
            content: addressZipMismatchFailureMessage,
          );
        }
      },
    );
  }

  void _didTapLockedField(AddressData addressData) {
    final theme = Theme.of(context);
    if (addressData.zip != null) {
      showBottomSheetDialog(
        context: context,
        title: Expanded(
            child: Text(
                'The shipping zip code has to be the same as the lawn address',
                style: theme.textTheme.headline2)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Text(
            'We send the right products based on your location and lawn conditions.',
            style: theme.textTheme.subtitle1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
            cubit: _bloc,
            builder: (context, state) {
              return AddressForm(
                initialAddress: _shippingAddress,
                disabledFields: widget.disabledAddressFields,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                onChanged: (state is ShippingAddressAddingState)
                    ? null
                    : (address) {
                        setState(() {
                          _shippingAddress = address;
                        });

                        widget.onChanged(
                          shippingAddress: _shippingAddress,
                          isDone: false,
                        );
                      },
                onDisabledTap: (addressData) => _didTapLockedField(addressData),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: _buildContinueToPaymentButton(),
          ),
        ],
      );
}
