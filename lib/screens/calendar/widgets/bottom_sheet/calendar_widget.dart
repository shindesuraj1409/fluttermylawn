import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/screens/calendar/widgets/bottom_sheet/calendar_item.dart';
import 'package:navigation/navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_bottom_sheet_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    @required this.date,
    @required this.events,
    @required this.onNewDateSelected,
    Key key,
  }) : super(key: key);

  final DateTime date;
  final Map<DateTime, List<CalendarEvents>> events;
  final OnNewDateSelected onNewDateSelected;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return TableCalendar(
      calendarController: _calendarController,
      events: widget.events,
      initialCalendarFormat: CalendarFormat.month,
      locale: 'en_US',
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      initialSelectedDay: widget.date,
      rowHeight: 38.5,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: _textTheme.headline3,
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dowWeekdayBuilder: (context, weekday) => Container(
          width: 26,
          height: 24,
          alignment: Alignment.topCenter,
          child: Text(
            '${weekday[0]}',
            style: _textTheme.subtitle1.copyWith(fontSize: 11.0),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Styleguide.color_gray_2,
                width: 1,
              ),
            ),
          ),
        ),
        markersBuilder: (context, date, events, _) {
          final children = <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (events.isNotEmpty)
                  ...events
                      .map((event) => EventMarker(date: date, event: event))
                      .toList()
              ],
            ),
          ];
          return children;
        },
        selectedDayBuilder: (context, date, _) => CalendarItem(
          date: date,
          isSelected: true,
        ),
        dayBuilder: (context, date, _) => CalendarItem(
          date: date,
        ),
      ),
      onDaySelected: (date, _, __) {
        _animationController.forward(from: 0.0);
        widget.onNewDateSelected(date);
        registry<Navigation>().pop();
      },
    );
  }
}

class EventMarker extends StatelessWidget {
  const EventMarker({Key key, this.date, this.event}) : super(key: key);

  final CalendarEvents event;
  final DateTime date;

  Color get color {
    switch (event.event) {
      case Event.products:
        return Styleguide.color_green_2;
        break;
      case Event.tasks:
        return Styleguide.color_gray_4;
        break;
      case Event.notes:
        return Styleguide.color_accents_yellow_1;
        break;
      case Event.water:
        return Styleguide.color_accents_blue_3;
        break;
      default:
        return Styleguide.color_gray_4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 4.0,
      height: 4.0,
    );
  }
}
