import 'package:flutter/material.dart';

import 'package:my_lawn/config/colors_config.dart';

enum BadgeSize { Small, Regular }

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsets margin;
  final BadgeSize size;

  const Badge({
    this.text = '',
    this.color,
    this.margin = const EdgeInsets.all(0),
    this.size = BadgeSize.Regular,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;
    double height;
    EdgeInsets padding;

    switch (size) {
      case BadgeSize.Small:
        fontSize = 10;
        height = 16.0;
        padding = EdgeInsets.symmetric(horizontal: 5);
        break;
      case BadgeSize.Regular:
        fontSize = 12;
        height = 20.0;
        padding = EdgeInsets.symmetric(horizontal: 8);
        break;
      default:
    }

    return text.isNotEmpty
        ? Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color ?? Styleguide.color_accents_blue_1,
              borderRadius: BorderRadius.circular(2),
            ),
            height: height,
            margin: margin,
            padding: padding,
            child: Text(
              text,
              key: Key('added_by_me'),
              style: TextStyle(
                fontFamily: 'ProximaNova',
                fontSize: fontSize,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Styleguide.color_gray_0,
              ),
            ),
          )
        : Container();
  }
}
