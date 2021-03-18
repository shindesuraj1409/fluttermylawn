import 'package:localytics_plugin/events/localytics_event.dart';

class CompleteCheckoutEvent extends LocalyticsEvent {
  CompleteCheckoutEvent({
    this.zoneName,
    this.subscriptionType,
    this.lawnSize,
    this.grassType,
    this.lawnColor,
    this.lawnThickness,
    this.lawnWeeds,
    this.spreaderType,
  }) : super(
          eventName: 'Complete checkout',
          extraAttributes: {
            'Zone Name': zoneName,
            'Subscription type': subscriptionType,
            'Lawn Size': lawnSize,
            'Grass Type': grassType,
            'Lawn Condition - Thickness': lawnThickness,
            'Lawn Condition - Color': lawnColor,
            'Lawn Condition - Weeds': lawnWeeds,
            'Spreader Type': spreaderType,
          },
        );

  final String zoneName;
  final String subscriptionType;
  final String lawnSize;
  final String grassType;
  final String lawnColor;
  final String lawnThickness;
  final String lawnWeeds;
  final String spreaderType;
}
