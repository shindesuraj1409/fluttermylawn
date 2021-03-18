import 'package:my_lawn/data/note_data.dart';

abstract class NotesService {
  Future<NoteData> createNote(
      String customerId, String recommendationId, NoteData noteData);

  Future<NoteData> updateNote(
      String customerId, NoteData noteData, bool isUpdatingImage);

  Future<List<NoteData>> getAllNotes(String customerId);

  Future<void> deleteNote(String customerId, NoteData noteData);

  String getNoteWithImagePath(String customerId, int noteId, String imagePath);

  Future<Map<String, String>> prepareImageHeader();
}
