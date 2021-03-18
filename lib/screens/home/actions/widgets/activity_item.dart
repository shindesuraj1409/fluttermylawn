import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/actions/localytics/customize_plan_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';
import 'package:navigation/navigation.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({Key key, this.type}) : super(key: key);

  final ActivityType type;

  void addAdobeAnalyticState(ActivityType type) {
    registry<AdobeRepository>().trackAppState(
        AddTaskTypeScreenAdobeState(taskType: type.title.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Ink(
        width: double.infinity,
        decoration: _radioDecoration(),
        child: InkWell(
          onTap: () {
            addAdobeAnalyticState(type);

            registry<LocalyticsService>().tagEvent(AddTaskEvent(type.title));
            registry<Navigation>().push('/activity', arguments: type);
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                type.icon,
                color: Styleguide.color_green_2,
                width: 72,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                type.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Styleguide.color_gray_9,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _radioDecoration() {
    return BoxDecoration(
      color: Styleguide.color_gray_0,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
