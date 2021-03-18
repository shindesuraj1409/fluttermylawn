import 'package:localytics_plugin/events/localytics_event.dart';

class AddOnEvent extends LocalyticsEvent {
  AddOnEvent() : super(eventName: 'Add add-on');
}

class CancelSubscriptionLocalyticsEvent extends LocalyticsEvent {
  CancelSubscriptionLocalyticsEvent() : super(eventName: 'Cancel subscription');
}

class SkipShipmentEvent extends LocalyticsEvent {
  SkipShipmentEvent() : super(eventName: 'Skip a shipment');
}
