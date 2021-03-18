import 'package:bus/bus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/models/credit_card_model.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';

class CreditCardForm extends StatefulWidget {
  final CreditCardData initialCreditCard;
  final EdgeInsets padding;
  final void Function({
    CreditCardData data,
    CreditCardIssuer issuer,
    CreditCardValidity validity,
  }) onChanged;

  CreditCardForm({
    this.initialCreditCard,
    this.padding = EdgeInsets.zero,
    this.onChanged,
  });

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  static final _amexMask = '#### ###### #####';
  static final _ccMask = '#### #### #### ####';
  static final _filter = {'#': RegExp(r'[0-9]')};

  final _cardNumberFormatter = MaskTextInputFormatter(
    mask: _ccMask,
    filter: _filter,
  );
  final _expirationDateFormatter = MaskTextInputFormatter(
    mask: '## / ##',
    filter: _filter,
  );
  final _cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: _filter,
  );

  CreditCardModel _creditCardModel;

  CreditCardData get _creditCard => _creditCardModel.snapshot<CreditCardData>();

  @override
  void initState() {
    super.initState();

    _creditCardModel =
        CreditCardModel(initialCreditCardData: widget.initialCreditCard);

    _creditCardModel
        .stream<CreditCardData>()
        .takeWhile((_) => _creditCardModel.isInitialized)
        .forEach(
          (data) => widget.onChanged?.call(data: data),
        );
    _creditCardModel
        .stream<CreditCardIssuer>()
        .takeWhile((_) => _creditCardModel.isInitialized)
        .forEach(
      (issuer) {
        _cardNumberFormatter.updateMask(
          mask: issuer == CreditCardIssuer.americanExpress15
              ? _amexMask
              : _ccMask,
          filter: _filter,
        );
        widget.onChanged?.call(issuer: issuer);
      },
    );
    _creditCardModel
        .stream<CreditCardValidity>()
        .takeWhile((_) => _creditCardModel.isInitialized)
        .forEach(
          (validity) => widget.onChanged?.call(validity: validity),
        );

    if (widget.initialCreditCard != null) {
      _creditCardModel.publish(data: widget.initialCreditCard);
    }
  }

  @override
  void dispose() {
    _creditCardModel?.destroy();

    super.dispose();
  }

  String _createInitialValue(MaskTextInputFormatter formatter) {
    String value;
    if (formatter == _cardNumberFormatter) {
      value = _creditCard.number;
    } else if (formatter == _expirationDateFormatter) {
      value = _creditCard.expiration;
    } else if (formatter == _cvvFormatter) {
      value = _creditCard.cvv;
    } else {
      throw ArgumentError('invalid formatter');
    }
    return formatter
        .formatEditUpdate(
          TextEditingValue(),
          TextEditingValue(text: value),
        )
        .text;
  }

  Widget _buildCreditCardIssuerWidget(CreditCardIssuer issuer) {
    switch (issuer) {
      case CreditCardIssuer.americanExpress15:
        return Image.asset('assets/icons/payment_amex.png', key: Key('amex_image'));
      case CreditCardIssuer.dinersClub16:
      case CreditCardIssuer.mastercard16:
        return Image.asset('assets/icons/payment_mastercard.png', key: Key('master_card_image'));
      case CreditCardIssuer.visa16:
        return Image.asset('assets/icons/payment_visa.png', key: Key('visa_image'));
      case CreditCardIssuer.unknown:
      default:
        return Container(width: 0, height: 0);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.padding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputField(
              labelText: 'Card Number',
              labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Styleguide.color_gray_4,
                    letterSpacing: 0.15,
                  ),
              initialValue: _createInitialValue(_cardNumberFormatter),
              onChanged: (_) => _creditCardModel.publish<CreditCardData>(
                publisher: (creditCard) => creditCard.copyWith(
                  number: _cardNumberFormatter.getUnmaskedText(),
                ),
              ),
              textInputType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              textInputFormatters: [_cardNumberFormatter],
              suffixIcon: busStreamBuilder<CreditCardModel, CreditCardIssuer>(
                busInstance: _creditCardModel,
                builder: (context, bus, issuer) =>
                    _buildCreditCardIssuerWidget(issuer),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextInputField(
                    labelText: 'Expiration Date',
                    labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Styleguide.color_gray_4,
                          letterSpacing: 0.15,
                        ),
                    initialValue: _createInitialValue(_expirationDateFormatter),
                    onChanged: (_) => _creditCardModel.publish<CreditCardData>(
                      publisher: (creditCard) => creditCard.copyWith(
                        expiration: _expirationDateFormatter.getUnmaskedText(),
                      ),
                    ),
                    textInputType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    textInputFormatters: [_expirationDateFormatter],
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: TextInputField(
                    labelText: 'CVV',
                    labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Styleguide.color_gray_4,
                          letterSpacing: 0.15,
                        ),
                    initialValue: _createInitialValue(_cvvFormatter),
                    onChanged: (_) => _creditCardModel.publish<CreditCardData>(
                      publisher: (creditCard) => creditCard.copyWith(
                        cvv: _cvvFormatter.getUnmaskedText(),
                      ),
                    ),
                    textInputFormatters: [_cvvFormatter],
                    textInputType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
