import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_tab.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';

typedef OnTabSelectionChanged = Function(CalendarTab tab);

const _tabsName = <Event, String>{
  Event.products: 'PRODUCTS',
  Event.tasks: 'TASKS',
  Event.notes: 'NOTES',
  Event.water: 'WATER',
};

const _tabsColor = <Event, Color>{
  Event.products: Styleguide.color_green_2,
  Event.tasks: Styleguide.color_gray_4,
  Event.notes: Styleguide.color_accents_yellow_1,
  Event.water: Styleguide.color_accents_blue_3,
};

class TabWidget extends StatelessWidget {
  const TabWidget({
    @required this.calendarTab,
    @required this.onTabSelectionChanged,
    Key key,
  }) : super(key: key);

  final CalendarTab calendarTab;
  final OnTabSelectionChanged onTabSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTabSelectionChanged(calendarTab),
      child: Container(
        decoration: BoxDecoration(
          color: calendarTab.selected
              ? _tabsColor[calendarTab.event]
              : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Text(
            _tabsName[calendarTab.event],
            style: TextStyle(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    return !calendarTab.selected || calendarTab.event == Event.notes
        ? Styleguide.color_gray_9
        : Styleguide.color_gray_0;
  }
}
