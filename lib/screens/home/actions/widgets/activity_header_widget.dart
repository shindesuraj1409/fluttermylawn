import 'package:flutter/material.dart';
import 'package:my_lawn/data/activity_type.dart';

class ActivityHeaderWidget extends StatelessWidget {
  const ActivityHeaderWidget({
    @required this.activityType,
    Key key,
  }) : super(key: key);

  final ActivityType activityType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              activityType.title,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 35,
                  ),
            ),
          ),
          Image.asset(
            activityType.icon,
            width: 50,
            height: 50,
            key: Key('task_screen_icon'),
          )
        ],
      ),
    );
  }
}
