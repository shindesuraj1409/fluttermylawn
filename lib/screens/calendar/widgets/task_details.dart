import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/screens/calendar/widgets/details_header.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:navigation/navigation.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    Key key,
    @required this.activityData,
    @required this.onDeleteTap,
  }) : super(key: key);

  final ActivityData activityData;
  final VoidCallback onDeleteTap;

  void _onEditTap() {
    registry<Navigation>().pop();
    registry<Navigation>().push('/activity', arguments: activityData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DetailsHeader(
          onDeleteTap: onDeleteTap,
          date: activityData.activityDate,
          title: activityData.activityType.title,
          iconPath: activityData.activityType.icon,
        ),
        if (activityData.frequency?.isNotEmpty ?? false)
          _buildText('Repeat', activityData.frequency),
        if (activityData.description?.isNotEmpty ?? false)
          _buildText('Notes', activityData.description),
        _buildEditButton(),
      ],
    );
  }

  Widget _buildText(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: FullTextButton(
        text: 'EDIT',
        onTap: _onEditTap,
        color: Styleguide.color_green_4,
      ),
    );
  }
}
