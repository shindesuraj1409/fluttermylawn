import 'package:my_lawn/data/activity_data.dart';

abstract class ActivityEvent {}

class SaveActivityEvent extends ActivityEvent {
  SaveActivityEvent(this.activityData);

  final ActivityData activityData;
}
