import 'package:flutter/material.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/payment_button.dart';

class PaymentButtonsRow extends StatelessWidget {
  const PaymentButtonsRow({
    this.onTap,
    Key key,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /* The only “or” option for phase 1 launch will be ‘Credit Card’ (Third Party Payers will be future enhancements/enablements) */
        /* PaymentButton(
          width: 104,
          margin: EdgeInsets.only(left: 16),
          onTap: onTap,
          child: Platform.isAndroid
              ? Image.asset(
                  'assets/icons/payment_google_pay.png',
                  height: 27,
                )
              : Image.asset(
                  'assets/icons/payment_apple_pay.png',
                  height: 24,
                ),
        ),
        PaymentButton(
          width: 104,
          margin: EdgeInsets.only(left: 8, right: 8),
          onTap: onTap,
          child: Image.asset(
            'assets/icons/payment_paypal.png',
            height: 30,
            width: 85,
          ),
        ), */
        PaymentButton(
          width: 104,
          margin: EdgeInsets.only(left: 16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/payment_mastercard.png',
                height: 23,
                width: 34,
              ),
              SizedBox(width: 4.0),
              Image.asset(
                'assets/icons/payment_visa.png',
                height: 23,
                width: 34,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentButtonsColumn extends StatelessWidget {
  const PaymentButtonsColumn({
    Key key,
    @required this.textTheme,
    @required this.onTap,
  }) : super(key: key);

  final TextTheme textTheme;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* The only “or” option for phase 1 launch will be ‘Credit Card’ (Third Party Payers will be future enhancements/enablements) */
        /*PaymentButton(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16),
          onTap: onTap,
          child: Platform.isAndroid
              ? Image.asset(
                  'assets/icons/payment_google_pay.png',
                  height: 27,
                )
              : Image.asset(
                  'assets/icons/payment_apple_pay.png',
                  height: 24,
                ),
        ),
        PaymentButton(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          onTap: onTap,
          child: Image.asset(
            'assets/icons/payment_paypal.png',
            height: 28,
          ),
        ), */
        PaymentButton(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/payment_mastercard.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 4.0),
              Image.asset(
                'assets/icons/payment_visa.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.0),
              Text(
                'Credit Card',
                style: textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
