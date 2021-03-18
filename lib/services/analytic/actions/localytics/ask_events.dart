import 'package:localytics_plugin/events/localytics_event.dart';

class SentEmailEvent extends LocalyticsEvent {
  SentEmailEvent(this.email)
      : super(
          eventName: 'Sent email',
          extraAttributes: {'Email': email},
        );

  final String email;
}

class CalledScottsEvent extends LocalyticsEvent {
  final String call;

  CalledScottsEvent({this.call})
      : super(
          eventName: 'Called Scotts',
          extraAttributes: {'Call': call},
        );
}

class TextedEvent extends LocalyticsEvent {
  TextedEvent(this.text)
      : super(
          eventName: 'Texted',
          extraAttributes: {'Text': text},
        );

  final String text;
}

class FeedActivitiesEvent extends LocalyticsEvent {
  FeedActivitiesEvent() : super(eventName: 'Feed & Seed Activities engage');
}

class RainfallEvent extends LocalyticsEvent {
  RainfallEvent() : super(eventName: 'Rain fall total engage');
}
