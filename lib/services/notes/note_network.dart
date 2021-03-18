class NoteRequest {
  NoteRequest({this.recommendationId, this.title, this.description});

  final String title;
  final String description;
  final String recommendationId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'recommendationId': recommendationId,
    };
  }
}

class NoteResponse {
  NoteResponse(
      {this.imagePath, this.notesId, this.title, this.description, this.date});

  final int notesId;
  final String title;
  final String description;
  final String date;
  final String imagePath;

  NoteResponse.fromJson(Map<String, dynamic> map)
      : notesId = map['notesId'] as int,
        title = map['title'] as String,
        description = map['description'] as String,
        date = map['createdAt'] as String,
        imagePath = map['image'] as String;
}

class NotesListResponse {
  final List<NoteResponse> notes;

  NotesListResponse.fromJson(Map<String, dynamic> map)
      : notes = List<NoteResponse>.from(
          map['notes']?.map(
                (note) => NoteResponse.fromJson(note),
              ) ??
              [],
        );
}
