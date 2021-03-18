import 'package:flutter/material.dart';

class AdditionalInformationBullet extends StatelessWidget {
  final Text text;
  const AdditionalInformationBullet({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/bullet_point.png',
          height: 12,
        ),
        SizedBox(
          width: 4.5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: text,
          ),
        )
      ],
    );
  }
}
