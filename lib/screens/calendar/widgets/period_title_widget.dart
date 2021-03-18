import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/calendar/widgets/selected_period_icon.dart';

class PeriodTitleWidget extends StatelessWidget {
  const PeriodTitleWidget({
    @required this.onTap,
    @required this.selected,
    @required this.text,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool selected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 22,
                  color: Styleguide.color_gray_9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (selected) const SelectedPeriodIcon(),
          ],
        ),
      ),
    );
  }
}
