import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/widgets/bottom_sheet/calendar_widget.dart';

typedef OnNewDateSelected = Function(DateTime selectedDate);

class CalendarBottomSheetWidget extends StatelessWidget {
  const CalendarBottomSheetWidget({
    @required this.date,
    @required this.events,
    @required this.onNewDateSelected,
    Key key,
  }) : super(key: key);

  final DateTime date;
  final Map<DateTime, List<CalendarEvents>> events;
  final OnNewDateSelected onNewDateSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.4),
      color: Styleguide.color_gray_1,
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: CalendarWidget(
        date: date,
        events: events,
        onNewDateSelected: onNewDateSelected,
      ),
    );
  }
}
