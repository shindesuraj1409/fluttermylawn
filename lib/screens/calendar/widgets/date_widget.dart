import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/config/colors_config.dart';

final dayDateFormat = DateFormat('MMM d, yyyy');

class DateWidget extends StatelessWidget {
  const DateWidget({
    @required this.date,
    @required this.onDateTap,
    @required this.onTodayTap,
    Key key,
  }) : super(key: key);

  final DateTime date;
  final VoidCallback onTodayTap;
  final VoidCallback onDateTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildClickableDate(context),
        _buildTodayButton(context),
      ],
    );
  }

  Widget _buildClickableDate(BuildContext context) {
    return InkWell(
      onTap: onDateTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildYearText(Theme.of(context)),
          const SizedBox(width: 10),
          _buildArrowIcon(),
        ],
      ),
    );
  }

  Widget _buildYearText(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _getDateText(),
        style: theme.textTheme.headline1.copyWith(
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildArrowIcon() {
    return Image.asset(
      'assets/icons/arrow_button.png',
      width: 24,
      height: 24,
      key: Key('arrow_button'),
    );
  }

  Widget _buildTodayButton(context) {
    return GestureDetector(
      onTap: onTodayTap,
      child: Text(
        'TODAY',
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: Styleguide.color_green_4, fontSize: 13),
      ),
    );
  }

  String _getDateText() {
    return dayDateFormat.format(date);
  }
}
