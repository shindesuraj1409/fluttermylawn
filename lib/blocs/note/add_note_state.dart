import 'package:equatable/equatable.dart';

abstract class AddNoteState extends Equatable {
  const AddNoteState();

  @override
  List<Object> get props => [];
}

class AddNoteInitialState extends AddNoteState {}

class AddNoteLoadingState extends AddNoteState {}

class AddNoteSuccessState extends AddNoteState {}

class AddNoteErrorState extends AddNoteState {
  AddNoteErrorState({this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
