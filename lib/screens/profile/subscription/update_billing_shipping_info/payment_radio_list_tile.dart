import 'package:flutter/material.dart';

class PaymentRadioListTile extends StatelessWidget {
  const PaymentRadioListTile({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.textTheme,
    @required this.changeRadioButton,
    @required this.icon,
    @required this.lastDigits,
  }) : super(key: key);

  final int value;
  final int groupValue;
  final TextTheme textTheme;
  final Function changeRadioButton;
  final String icon;
  final String lastDigits;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: (value) => changeRadioButton(value),
      dense: true,
      title: Row(
        children: [
          Container(
            height: 24,
            width: 38,
            margin: EdgeInsets.only(right: 12),
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
              height: 24,
              width: 38,
            ),
          ),
          Text(
            lastDigits,
            style: textTheme.bodyText2.copyWith(fontSize: 13, height: 1.46),
          ),
        ],
      ),
    );
  }
}