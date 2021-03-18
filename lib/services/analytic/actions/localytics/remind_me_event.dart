import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';

class RemindMeEvent extends LocalyticsEvent {
  RemindMeEvent(this.userType, this.zoneName)
      : super(
          eventName: 'Remind me next year',
          extraAttributes: {
            'User Type': userType.toString(),
            'Zone Name': zoneName,
          },
        );

  final UserType userType;
  final String zoneName;
}
