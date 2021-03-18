import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    this.child,
    this.margin,
    this.width,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets margin;
  final double width;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: SizedBox(
        width: width,
        child: ButtonTheme(
          minWidth: width,
          height: 52.0,
          child: RaisedButton(
            color: Colors.white,
            child: child,
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}