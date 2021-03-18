import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/screens/calendar/widgets/mark_done_widget.dart';
import 'package:my_lawn/screens/calendar/widgets/note_details.dart';
import 'package:my_lawn/screens/calendar/widgets/note_item.dart';
import 'package:my_lawn/screens/calendar/widgets/product_item.dart';
import 'package:my_lawn/screens/calendar/widgets/task_details.dart';
import 'package:my_lawn/screens/calendar/widgets/task_item.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:navigation/navigation.dart';

const _cardsColor = <Event, Color>{
  Event.products: Styleguide.color_green_2,
  Event.tasks: Styleguide.color_gray_4,
  Event.notes: Styleguide.color_accents_yellow_1,
  Event.water: Styleguide.color_accents_blue_3,
};

final _monthFormat = DateFormat('MMM');

class CalendarEventItem extends StatelessWidget {
  const CalendarEventItem({
    @required this.event,
    @required this.showDate,
    @required this.onDeleteTap,
    this.onMarkDoneTap,
    Key key,
  }) : super(key: key);

  final CalendarEvents event;
  final bool showDate;
  final VoidCallback onDeleteTap;
  final VoidCallback onMarkDoneTap;

  void sendAdobeStateAnalytic(Event event) {
    registry<AdobeRepository>().trackAppState(
      CalendarTaskViewScreenAdobeState(event: event),
    );
  }

  void _onItemTap(BuildContext context) async {
    sendAdobeStateAnalytic(event.event);
    if (event.event == Event.products) {
      final product = Product.fromActivity(event.task);
      await registry<Navigation>().push(
        '/product/detail',
        arguments: product,
      );
    } else if (event.note != null) {
      await showBottomSheetDialog(
        hasTopPadding: false,
        context: context,
        child: NoteDetails(
          noteData: event.note,
          onDeleteTap: () => _onDeleteTap(context),
        ),
      );
    } else if (event.task != null) {
      await showBottomSheetDialog(
        hasTopPadding: false,
        context: context,
        child: TaskDetails(
          activityData: event.task,
          onDeleteTap: () => _onDeleteTap(context),
        ),
      );
    } else {
      throw UnimplementedError('Unknown event type $event');
    }
  }

  Future<void> _onDeleteTap(BuildContext context) async {
    if (onDeleteTap == null) {
      return;
    }

    final delete = await showBottomSheetDialog(
      context: context,
      child: _buildDeleteActions(context),
    );

    Navigator.of(context).pop();
    if (delete ?? false) {
      onDeleteTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDate(),
        Expanded(child: _buildCard(context)),
      ],
    );
  }

  Widget _buildDate() {
    final isToday = _isToday();
    final textColor =
        isToday ? Styleguide.color_gray_0 : Styleguide.color_gray_9;

    return Container(
      width: 32,
      margin: const EdgeInsets.only(left: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color:
            isToday && showDate ? Styleguide.color_green_4 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: showDate
          ? Column(
              children: [
                Text(
                  event.eventDate.day.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  key: Key('event_date'),
                ),
                Text(
                  _monthFormat.format(event.eventDate),
                  style: TextStyle(fontSize: 10, color: textColor),
                  key: Key('event_month'),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      margin: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 20),
      child: Card(
        color: _cardsColor[event.event].withOpacity(0.08),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: InkWell(
          onTap: () => _onItemTap(context),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: _buildCardContent(),
              ),
              if ((event.event == Event.tasks || event.event == Event.water) &&
                  !event.task.applied)
                MarkDoneWidget(onTap: onMarkDoneTap)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    switch (event.event) {
      case Event.products:
        return ProductItem(event: event);
      case Event.notes:
        return NoteItem(event: event);
      default:
        return TaskItem(event: event);
    }
  }

  bool _isToday() {
    final date = event.eventDate;
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildDeleteActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: FullTextButton(
            text: 'DELETE ACTIVITY',
            onTap: () => Navigator.of(context).pop(true),
            color: Styleguide.color_green_4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: TappableText(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCEL',
              style: const TextStyle(color: Styleguide.color_green_4),
            ),
          ),
        ),
      ],
    );
  }
}
