import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_tab.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/screens/calendar/widgets/tab_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';

typedef SelectedTabsUpdated = Function(List<Event> tabs);

class TabsWidget extends StatelessWidget {
  const TabsWidget({
    @required this.selectedTabs,
    @required this.selectedTabsUpdated,
    Key key,
  }) : super(key: key);

  final List<Event> selectedTabs;
  final SelectedTabsUpdated selectedTabsUpdated;

  void _onTabSelectionChanged(CalendarTab calendarTab) {
    final tabs = List<Event>.from(selectedTabs);
    if (calendarTab.selected) {
      tabs..remove(calendarTab.event);
    } else {
      tabs..add(calendarTab.event);
    }

    sendTabSelectedAnalytic(tabs);

    selectedTabsUpdated(tabs);
  }

  void sendTabSelectedAnalytic(List<Event> tabs) {
    registry<AdobeRepository>().trackAppState(
      CalendarScreenAdobeState(tabEventList: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 8,
      children: List.generate(
        Event.values.length,
        (index) => _buildTab(Event.values[index]),
      ),
    );
  }

  Widget _buildTab(Event event) {
    return TabWidget(
      calendarTab: CalendarTab(
        event: event,
        selected: selectedTabs.contains(event),
      ),
      onTabSelectionChanged: _onTabSelectionChanged,
    );
  }
}
