import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final Text text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 31),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              height: 1.0,
              color: Styleguide.color_gray_2,
            ),
          ),
          text,
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              height: 1.0,
              color: Styleguide.color_gray_2,
            ),
          ),
        ],
      ),
    );
  }
}
