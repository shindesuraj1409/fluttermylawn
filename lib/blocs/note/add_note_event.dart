abstract class AddNoteEvent {}

class SaveNoteEvent extends AddNoteEvent {
  SaveNoteEvent({
    this.description,
    this.imagePath,
    this.noteId,
    this.isUpdatingImage,
  });

  final int noteId;
  final String description;
  final String imagePath;
  final bool isUpdatingImage;
}
