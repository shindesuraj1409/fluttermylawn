import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    @required this.event,
    Key key,
  }) : super(key: key);

  final CalendarEvents event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 4),
        _buildContent(),
        _buildStatus(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            event.task.activityType.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _buildIcon(),
      ],
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      event.task.activityType.icon,
      width: 30,
      fit: BoxFit.fill,
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (event.task.frequency != null || event.task.duration != null)
          Text(
            _getFrequencyText(),
            style: TextStyle(
              fontSize: 12,
              color: Styleguide.color_gray_9.withOpacity(0.8),
            ),
          ),
        const SizedBox(height: 4),
        if (event.task.description != null)
          Text(
            event.task.description,
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildStatus() {
    if (event.task.applied) {
      return _buildIconRow('assets/icons/completed.png', 'Done');
    } else if (event.task.remind) {
      return _buildIconRow('assets/icons/notification.png', 'Remind me');
    } else {
      return const SizedBox();
    }
  }

  Widget _buildIconRow(String icon, String text) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 20,
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 11),
        )
      ],
    );
  }

  String _getFrequencyText() {
    if (event.task.frequency == null) {
      return '${event.task.duration}';
    } else if (event.task.duration == null) {
      return event.task.frequency;
    }
    return '${event.task.duration} • ${event.task.frequency}';
  }
}
