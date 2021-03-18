import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_bloc.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/models/credit_card_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/checkout/widgets/address_form_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/address_validation_failure_dialog_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/credit_card_form_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/maybe_spinner_button_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/confirmation_screen/state.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:pedantic/pedantic.dart';

enum PaymentType {
  googlePay,
  applePay,
  payPal,
  creditCard,
  visa,
  mastercard,
  none,
}

class PaymentSubscreen extends StatefulWidget {
  final PaymentType initalPaymentType;
  final CreditCardData initialCreditCard;
  final AddressData initialBillingAddress;
  final AddressData shippingAdress;
  final String cart_id;

  final Function({
    PaymentType paymentType,
    CreditCardData creditCard,
    CreditCardIssuer creditCardIssuer,
    CreditCardValidity creditCardValidity,
    AddressData billingAddress,
    bool isDone,
    String recurlyToken,
  }) onChanged;

  PaymentSubscreen({
    this.initalPaymentType,
    this.initialCreditCard,
    this.shippingAdress,
    this.initialBillingAddress,
    this.cart_id,
    this.onChanged,
  });

  @override
  _PaymentSubscreenState createState() => _PaymentSubscreenState();
}

class _PaymentSubscreenState extends State<PaymentSubscreen> {
  PaymentBloc _bloc;
  ThemeData _theme;

  PaymentType _activePaymentType;

  CreditCardData _creditCard;
  CreditCardIssuer _creditCardIssuer;
  String _recurlyToken;
  CreditCardValidity _creditCardValidity;

  bool _isBillingSameAsShipping;
  AddressData _billingAddress;
  AddressData _shippingAddress;
  String _cart_id;

  final addressValidationFailureMessage = '''
We’re sorry, but we could not find your address. Please confirm that you have typed in your address correctly. 
                
If you are still encountering problems, our consumer services team is available to help. Please contact us at''';

  @override
  void initState() {
    _activePaymentType = widget.initalPaymentType ?? PaymentType.none;
    _creditCard = widget.initialCreditCard ?? CreditCardData();
    _creditCardIssuer = CreditCardIssuer.unknown;
    _shippingAddress = widget.shippingAdress;
    _creditCardValidity = CreditCardValidity();
    _isBillingSameAsShipping = widget.initialBillingAddress == null;
    _billingAddress = widget.initialBillingAddress ?? AddressData();
    _cart_id = widget.cart_id;

    super.initState();
    _bloc = registry<PaymentBloc>();
  }

  bool _validateAddress() {
    return _isBillingSameAsShipping
        ? true
        : (_billingAddress.firstName != null &&
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

  Future<void> _showDialog({String title, String content}) async {
    await showBottomSheetDialog(
      context: context,
      title: DialogTitle(title: title),
      child: DialogContent(content: content),
    );
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);

    super.didChangeDependencies();
  }

  void _onChanged([bool isDone = false]) => widget.onChanged(
        paymentType: _activePaymentType,
        billingAddress:
            _isBillingSameAsShipping ? _shippingAddress : _billingAddress,
        creditCard: _creditCard,
        creditCardIssuer: _creditCardIssuer,
        creditCardValidity: _creditCardValidity,
        isDone: isDone,
        recurlyToken: _recurlyToken,
      );

  void _onCreditCardChanged({
    CreditCardData data,
    CreditCardIssuer issuer,
    CreditCardValidity validity,
  }) {
    if (data != null) {
      _creditCard = data;
    }
    if (issuer != null) {
      _creditCardIssuer = issuer;
    }
    if (validity != null) {
      _creditCardValidity = validity;
    }

    _onChanged(false);
  }

  Widget _buildSubsectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(title, style: _theme.textTheme.headline4),
      );

  Widget _buildBillingAddressSwitch() => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Same as Shipping Address'),
            Switch(
              value: _isBillingSameAsShipping,
              onChanged: (value) {
                setState(() => _isBillingSameAsShipping = value);
                _onChanged(false);
              },
              key: Key('same_as_shipping_address'),
            ),
          ],
        ),
      );

  Widget _buildGooglePay() => Container();

  Widget _buildApplePay() => Container();

  Widget _buildPayPal() => Container();

  Widget _buildCreditCardPayment() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubsectionTitle('Credit Card'),
          CreditCardForm(
            initialCreditCard: _creditCard,
            padding: const EdgeInsets.only(top: 8),
            onChanged: _onCreditCardChanged,
          ),
          _buildSubsectionTitle('Billing Address'),
          _buildBillingAddressSwitch(),
          if (!_isBillingSameAsShipping)
            BlocBuilder<PaymentBloc, PaymentVerificationState>(
              cubit: _bloc,
              builder: (context, state) {
                return AddressForm(
                  initialAddress: _billingAddress,
                  padding: const EdgeInsets.only(bottom: 16),
                  onChanged: (state is PaymentVerificationLoadingState)
                      ? null
                      : (address) {
                          setState(() {
                            _billingAddress = address;
                            _onChanged(false);
                          });
                        },
                );
              },
            ),
        ],
      );

  Widget _buildMainPaymentPicker() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSubsectionTitle('Choose payment method'),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: RaisedButton(
                color: Styleguide.color_gray_0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/payment_mastercard.png',
                      height: 24,
                      key: Key('master_card_image'),
                    ),
                    SizedBox(width: 4),
                    Image.asset(
                      'assets/icons/payment_visa.png',
                      height: 24,
                      key: Key('visa_card_image'),
                    ),
                    SizedBox(width: 8),
                    Text('Credit Card'),
                  ],
                ),
                onPressed: () => _updatePaymentType(PaymentType.creditCard),
              ),
            ),
          ],
        ),
      );

  void _updatePaymentType(PaymentType paymentType) {
    if (_activePaymentType != paymentType) {
      _activePaymentType = paymentType;
      setState(() => null);
      _onChanged(false);
    }
  }

  Widget _buildContinueToOrderSummaryButton() {
    return BlocConsumer<PaymentBloc, PaymentVerificationState>(
      cubit: _bloc,
      builder: (context, state) {
        return FractionallySizedBox(
          widthFactor: 1,
          child: RaisedButton(
            child: _validateAddress()
                ? MaybeSpinnerButton(
                    spinner: (state is PaymentVerificationLoadingState),
                    spinnerText: 'VERIFYING ADDRESS',
                    text: 'CONTINUE TO ORDER SUMMARY',
                  )
                : Text('CONTINUE TO ORDER SUMMARY'),
            onPressed:
                (state is PaymentVerificationLoadingState || !_validateAddress()
                    ? null
                    : () {
                        switch (_activePaymentType) {
                          case PaymentType.creditCard:
                            {
                              if (!_creditCardValidity.isValid) {
                                unawaited(
                                  _showDialog(
                                    title: 'Credit Card Not Valid',
                                    content:
                                        'We were unable to validate the entered credit card information. '
                                        'Please check that all fields are correct, and try again.',
                                  ),
                                );
                              } else {
                                if (!_isBillingSameAsShipping &&
                                    !_validateAddress()) {
                                  unawaited(
                                    _showDialog(
                                      title: 'Validation Error',
                                      content:
                                          'Please check that all fields are correct, and try again.',
                                    ),
                                  );
                                }
                                _bloc.verifyPayment(
                                  _isBillingSameAsShipping
                                      ? _shippingAddress
                                      : _billingAddress,
                                  _shippingAddress,
                                  _creditCard,
                                  _cart_id,
                                );
                              }
                              break;
                            }
                          case PaymentType.googlePay:
                            {
                              // TODO: TBA later on.
                              break;
                            }
                          case PaymentType.applePay:
                            {
                              // TODO: TBA later on.
                              break;
                            }
                          case PaymentType.payPal:
                            {
                              // TODO: TBA later on.
                              break;
                            }
                          case PaymentType.none:
                            {
                              // TODO: TBA later on.
                              break;
                            }
                          case PaymentType.visa:
                            // TODO: TBA later on.
                            break;
                          case PaymentType.mastercard:
                            // TODO: TBA later on.
                            break;
                        }

                        registry<AdobeRepository>().trackAppState(
                          //TODO: add promocode value from promocode dialog
                          PaymentScreenAdobeState(
                            promoCode: '',
                          ),
                        );
                      }),
          ),
        );
      },
      listener: (context, state) {
        if (state is PaymentVerificationVerifiedState) {
          _recurlyToken = state.recurly_token;
          _onChanged(true);
        } else if (state is PaymentVerificationFailure) {
          var message =
              'We were unable to validate the entered credit card information. '
              'Please check that all fields are correct, and try again.';
          if (state.errorMessage != null) {
            message = state.errorMessage.replaceAll('_', ' ');
          }

          unawaited(
            _showDialog(
              title: 'Credit Card Not Valid',
              content: message,
            ),
          );
        } else if (state is BillingAddressValidationFailure) {
          showAddressValidationFailureDialog(
            context: context,
            title: 'Address Not Found',
            content: addressValidationFailureMessage,
            address: _billingAddress,
          );
        }
      },
    );
  }

  Widget _buildActivePayment() {
    switch (_activePaymentType) {
      case PaymentType.googlePay:
        return _buildGooglePay();
      case PaymentType.applePay:
        return _buildApplePay();
      case PaymentType.payPal:
        return _buildPayPal();
      case PaymentType.creditCard:
        return _buildCreditCardPayment();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activePaymentType == PaymentType.none) {
      return _buildMainPaymentPicker();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivePayment(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildContinueToOrderSummaryButton(),
          ),
        ],
      ),
    );
  }
}
