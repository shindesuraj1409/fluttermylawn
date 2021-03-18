import 'package:flutter/material.dart';

class SelectedPeriodIcon extends StatelessWidget {
  const SelectedPeriodIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/completed.png',
      width: 20,
      fit: BoxFit.fill,
    );
  }
}
