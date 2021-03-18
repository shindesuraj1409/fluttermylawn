import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';

class PlanSummaryEvent extends LocalyticsEvent {
  PlanSummaryEvent({
    this.zoneName,
    this.userType,
    this.lawnSize,
    this.grassType,
    this.lawnColor,
    this.lawnThickness,
    this.lawnWeeds,
    this.spreaderType,
  }) : super(
          eventName: 'Lawn Care Plan Summary',
          extraAttributes: {
            'Zone Name': zoneName,
            'User Type': userType.toString(),
            'Lawn Size': lawnSize,
            'Grass Type': grassType,
            'Lawn Condition - Thickness': lawnThickness,
            'Lawn Condition - Color': lawnColor,
            'Lawn Condition - Weeds': lawnWeeds,
            'Spreader Type': spreaderType,
          },
        );

  final String zoneName;
  final UserType userType;
  final String lawnSize;
  final String grassType;
  final String lawnColor;
  final String lawnThickness;
  final String lawnWeeds;
  final String spreaderType;
}
