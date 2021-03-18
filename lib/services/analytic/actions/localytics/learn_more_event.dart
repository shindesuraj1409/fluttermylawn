import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';

class LearnMoreEvent extends LocalyticsEvent {
  LearnMoreEvent(this.userType, this.zoneName)
      : super(
          eventName: 'Learn More',
          extraAttributes: {
            'User Type': userType.toString(),
            'Zone Name': zoneName,
          },
        );

  final UserType userType;
  final String zoneName;
}
