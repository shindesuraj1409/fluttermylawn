import 'dart:convert';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';
import 'package:my_lawn/services/notes/note_network.dart';
import 'package:my_lawn/services/notes/notes_exception.dart';
import 'package:my_lawn/services/scotts_api_client.dart';

import 'package:path/path.dart' as path;

class NotesServiceImpl implements NotesService {
  NotesServiceImpl() : _apiClient = registry<ScottsApiClient>();

  final ScottsApiClient _apiClient;

  @override
  Future<NoteData> createNote(
      String customerId, String recommendationId, NoteData noteData) async {
    final requestBody = NoteRequest(
      title: noteData.title,
      description: noteData.description,
      recommendationId: recommendationId,
    ).toJson();

    final response = await _apiClient.post(
      '/notes/v1/notes/$customerId',
      body: requestBody,
    );

    if (response.statusCode != 201) {
      throw NotesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    final noteResponse = NoteResponse.fromJson(jsonDecode(response.body));
    final note = NoteData(
      title: noteResponse.title,
      description: noteResponse.description,
      notesId: noteResponse.notesId,
    );
    // Lets make sort of a transaction here, if the image fails, rollback
    try {
      if (noteData.imagePath.isNotEmpty) {
        final imageResponse = await _apiClient.uploadFile(
            '/notes/v1/notes/$customerId/${note.notesId}/image',
            noteData.imagePath,
            imageName: 'image' + path.extension(noteData.imagePath));
        if (imageResponse.statusCode != 201) {
          imageResponse.statusCode == 413
              ? throw NotesException(
                  message:
                      'The image size is too large. Please select a smaller image')
              : throw NotesException(
                  message: 'Something went wrong. Please try again');
        }
      }
      return note;
    } catch (e) {
      await deleteNote(customerId, note);

      rethrow;
    }
  }

  @override
  Future<List<NoteData>> getAllNotes(String customerId) async {
    final response = await _apiClient.get('/notes/v1/notes/$customerId');

    final notesResponse = NotesListResponse.fromJson(jsonDecode(response.body));

    return notesResponse.notes.map((note) {
      return NoteData(
        title: note.title,
        description: note.description,
        notesId: note.notesId,
        date: DateTime.parse(note.date),
        imagePath: note.imagePath,
      );
    }).toList();
  }

  @override
  Future<NoteData> updateNote(
      String customerId, NoteData noteData, bool isUpdatingImage) async {
    final requestBody = NoteRequest(
      title: noteData.title,
      description: noteData.description,
    ).toJson();

    final response = await _apiClient.put(
      '/notes/v1/notes/$customerId/${noteData.notesId}',
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw NotesException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    final note = NoteResponse.fromJson(jsonDecode(response.body));

    if (isUpdatingImage) {
      var imageResponse;
      if (noteData.imagePath.isNotEmpty) {
        imageResponse = await _apiClient.uploadFile(
            '/notes/v1/notes/$customerId/${note.notesId}/image',
            noteData.imagePath,
            imageName: 'image' + path.extension(noteData.imagePath));
      } else {
        imageResponse = await _apiClient.delete(
            '/notes/v1/notes/$customerId/${note.notesId}/image/${note.imagePath}');
      }
      if (!(imageResponse.statusCode == 200 ||
          imageResponse.statusCode == 201)) {
        imageResponse.statusCode == 413
            ? throw NotesException(
                message:
                    'The image size is too large. Please select a smaller image')
            : throw NotesException(
                message: 'Something went wrong. Please try again');
      }
    }

    return NoteData(
      title: note.title,
      description: note.description,
      notesId: note.notesId,
    );
  }

  @override
  Future<void> deleteNote(String customerId, NoteData noteData) {
    return _apiClient.delete('/notes/v1/notes/$customerId/${noteData.notesId}');
  }

  @override
  String getNoteWithImagePath(String customerId, int noteId, String imagePath) {
    return _apiClient.prepareImagePath(
        '/notes/v1/notes/$customerId/${noteId.toString()}/image/$imagePath');
  }

  @override
  Future<Map<String, String>> prepareImageHeader() async {
    return await _apiClient.prepareImageHeader();
  }
}
