import 'package:data/data.dart';

class NoteData extends Data {
  NoteData({
    this.notesId,
    this.title,
    this.description,
    this.imagePath,
    this.date,
  });

  final int notesId;
  final String title;
  final String description;
  final String imagePath;
  final DateTime date;

  @override
  List<Object> get props => [
        notesId,
        title,
        description,
        imagePath,
        date,
        imagePath,
      ];

  NoteData copyWith({
    int notesId,
    String title,
    String description,
    String imagePath,
    DateTime date,
    Map<String, String> imageHeaders,
  }) {
    return NoteData(
      date: date ?? this.date,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      notesId: notesId ?? this.notesId,
      title: title ?? this.title,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is NoteData &&
          runtimeType == other.runtimeType &&
          notesId == other.notesId &&
          title == other.title &&
          description == other.description &&
          imagePath == other.imagePath &&
          date == other.date;

  @override
  int get hashCode =>
      super.hashCode ^
      notesId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      imagePath.hashCode ^
      date.hashCode;
}
