import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/note/add_note_event.dart';
import 'package:my_lawn/blocs/note/add_note_state.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';
import 'package:my_lawn/services/notes/notes_exception.dart';
import 'package:pedantic/pedantic.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  AddNoteBloc(
    this._notesService,
    this._authenticationBloc,
  ) : super(AddNoteInitialState());

  final NotesService _notesService;
  final AuthenticationBloc _authenticationBloc;

  @override
  Stream<AddNoteState> mapEventToState(AddNoteEvent event) async* {
    if (event is SaveNoteEvent) {
      try {
        yield AddNoteLoadingState();

        final user = _authenticationBloc.state.user;
        final note = NoteData(
          description: event.description,
          imagePath: event.imagePath,
          notesId: event.noteId,
        );
        final isUpdatingImage = event.isUpdatingImage;
        if (event.noteId != null) {
          await _notesService.updateNote(
              user.customerId, note, isUpdatingImage);
        } else {
          await _notesService.createNote(
            user.customerId,
            user.recommendationId,
            note,
          );
        }

        yield AddNoteSuccessState();
      } catch (exception) {
        if (exception is NotesException) {
          yield AddNoteErrorState(errorMessage: exception.message);
        } else {
          yield AddNoteErrorState(
              errorMessage: 'Something went wrong. Please try again');
        }

        unawaited(FirebaseCrashlytics.instance.recordError(
          exception,
          StackTrace.current,
        ));
      }
    }
  }
}
