import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';

class CalendarEvents {
  CalendarEvents({
    this.eventDate,
    this.event,
    this.task,
    this.note,
  });

  final DateTime eventDate;
  final Event event;
  final ActivityData task;
  final NoteData note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEvents &&
          runtimeType == other.runtimeType &&
          eventDate == other.eventDate &&
          event == other.event &&
          task == other.task &&
          note == other.note;

  @override
  int get hashCode =>
      eventDate.hashCode ^ event.hashCode ^ task.hashCode ^ note.hashCode;

  @override
  String toString() {
    return 'CalendarEvents{eventDate: $eventDate, event: $event, task: $task, note: $note}';
  }
}
