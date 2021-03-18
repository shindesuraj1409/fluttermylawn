import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_item.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';
import 'package:navigation/navigation.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  void initState() {
    super.initState();

    sendAdobeStateAnalytic();
  }

  void sendAdobeStateAnalytic() {
    registry<AdobeRepository>().trackAppState(
      AddTaskScreenAdobeState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityTypes = ActivityType.values
        .where((element) => element.isDisplayable == true)
        .toList();
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  activityTypes.length,
                  (index) => ActivityItem(type: activityTypes[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        'Add Task',
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 35),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        key: Key('cancel_button_task_screen'),
        icon: Icon(
          Icons.close,
          size: 32,
          color: Styleguide.color_gray_9,
        ),
        onPressed: () => returnToHome(),
      ),
    );
  }

  void returnToHome() {
    registry<Navigation>().popToRoot();
  }
}
