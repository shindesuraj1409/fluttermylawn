import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/data/water_model_data.dart';

class AddNoteEvent extends LocalyticsEvent {
  AddNoteEvent() : super(eventName: 'Add a note');
}

class AddTaskEvent extends LocalyticsEvent {
  AddTaskEvent(this.type)
      : super(
          eventName: 'Add a task',
          extraAttributes: {'Type': type},
        );

  final String type;
}

class TaskCompletedEvent extends LocalyticsEvent {
  TaskCompletedEvent(this.type, this.date)
      : super(
          eventName: 'Task Completed',
          extraAttributes: {
            'Type': type,
            'Date completed': date,
          },
        );

  final String type;
  final String date;
}

class MyLawnPlanEvent extends LocalyticsEvent {
  MyLawnPlanEvent() : super(eventName: 'My lawn Care Plan');
}

class WaterLawnEvent extends LocalyticsEvent {
  WaterLawnEvent() : super(eventName: 'Water Lawn');
}

class UseThisFlowRateEvent extends LocalyticsEvent {
  UseThisFlowRateEvent(this.sprinklerType)
      : super(
          eventName: 'Use this Flow rate',
          extraAttributes: {'Sprinkler type': sprinklerType.name},
        );

  final NozzleType sprinklerType;
}
