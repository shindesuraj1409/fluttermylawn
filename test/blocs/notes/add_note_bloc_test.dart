import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/note/add_note_bloc.dart';
import 'package:my_lawn/blocs/note/add_note_event.dart';
import 'package:my_lawn/blocs/note/add_note_state.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';

class MockNotesService extends Mock implements NotesService {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {
  @override
  AuthenticationState get state =>
      AuthenticationState.loggedIn(user, LawnData());
}

final customerId = 'mockedCustomerId';
final recommendationId = '';
final user = User(customerId: customerId, recommendationId: recommendationId);

void main() {
  group('AddNoteBloc', () {
    final noteId = 1;
    final description = 'description';
    final image = 'image';
    final validNoteData = NoteData(description: description, imagePath: image);
    final editedNoteData =
        NoteData(description: description, imagePath: image, notesId: 1);
    final invalidNoteData = NoteData(description: null, imagePath: null);
    final exception = 'Something went wrong. Please try again';

    NotesService notesService;
    AuthenticationBloc authenticationBloc;

    setUp(() {
      notesService = MockNotesService();
      authenticationBloc = MockAuthenticationBloc();
      when(notesService.createNote(
              customerId, recommendationId, invalidNoteData))
          .thenThrow(exception);
      when(notesService.createNote(customerId, recommendationId, validNoteData))
          .thenAnswer((_) async => null);
      when(notesService.updateNote(customerId, editedNoteData, any))
          .thenAnswer((_) async => null);
    });

    test('initial state is AddNoteInitialState()', () {
      final bloc = AddNoteBloc(notesService, authenticationBloc);
      expect(bloc.state, AddNoteInitialState());
      bloc.close();
    });

    blocTest<AddNoteBloc, AddNoteState>(
      'emits [AddNoteLoadingState, AddNoteSuccessState]',
      build: () => AddNoteBloc(notesService, authenticationBloc),
      act: (bloc) => bloc.add(SaveNoteEvent(
        description: description,
        imagePath: image,
      )),
      expect: <AddNoteState>[
        AddNoteLoadingState(),
        AddNoteSuccessState(),
      ],
      verify: (_) {
        verify(notesService.createNote(
                customerId, recommendationId, validNoteData))
            .called(1);
        verifyNoMoreInteractions(authenticationBloc);
        verifyNoMoreInteractions(notesService);
      },
    );

    blocTest<AddNoteBloc, AddNoteState>(
      'emits [AddNoteLoadingState, AddNoteSuccessState]',
      build: () => AddNoteBloc(notesService, authenticationBloc),
      act: (bloc) => bloc.add(SaveNoteEvent(
          description: description,
          imagePath: image,
          noteId: noteId,
          isUpdatingImage: true)),
      expect: <AddNoteState>[
        AddNoteLoadingState(),
        AddNoteSuccessState(),
      ],
      verify: (_) {
        verify(notesService.updateNote(customerId, editedNoteData, true))
            .called(1);
        verifyNoMoreInteractions(authenticationBloc);
        verifyNoMoreInteractions(notesService);
      },
    );

    blocTest<AddNoteBloc, AddNoteState>(
      'emits [AddNoteLoadingState, AddNoteErrorState]',
      build: () => AddNoteBloc(notesService, authenticationBloc),
      act: (bloc) => bloc.add(SaveNoteEvent()),
      expect: <AddNoteState>[
        AddNoteLoadingState(),
        AddNoteErrorState(errorMessage: exception),
      ],
      verify: (_) {
        verify(notesService.createNote(
                customerId, recommendationId, invalidNoteData))
            .called(1);
        verifyNoMoreInteractions(authenticationBloc);
        verifyNoMoreInteractions(notesService);
      },
    );
  });
}
