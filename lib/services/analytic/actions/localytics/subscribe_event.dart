import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';

class SubscribeEvent extends LocalyticsEvent {
  SubscribeEvent(this.userType, this.zoneName)
      : super(
          eventName: 'Subscribe now',
          extraAttributes: {
            'User Type': userType.toString(),
            'Zone Name': zoneName,
          },
        );

  final UserType userType;
  final String zoneName;
}
