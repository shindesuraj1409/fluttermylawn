import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({this.date, this.isSelected = false, Key key})
      : super(key: key);

  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context).textTheme;
    return Center(
      child: Container(
        width: 26,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Styleguide.color_green_4 : null,
        ),
        child: Text(
          '${date.day}',
          style: _theme.subtitle1.copyWith(
              fontSize: 16.0,
              color: isSelected
                  ? Styleguide.color_gray_0
                  : Styleguide.color_gray_9),
        ),
      ),
    );
  }
}
