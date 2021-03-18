import 'package:localytics_plugin/events/localytics_event.dart';

class HomeScreenLoadingEvent extends LocalyticsEvent {
  HomeScreenLoadingEvent() : super(eventName: 'Home screen loading');
}
