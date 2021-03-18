part of 'edit_lawn_profile_bloc.dart';

abstract class EditLawnProfileState extends Equatable {
  const EditLawnProfileState();

  @override
  List<Object> get props => [];
}

class EditLawnProfileStateInitial extends EditLawnProfileState {}

class EditLawnProfileStateLoading extends EditLawnProfileState {}

class EditLawnProfileStateSuccess extends EditLawnProfileState {
  final LawnData lawnData;

  EditLawnProfileStateSuccess({
    this.lawnData,
  });

  @override
  List<Object> get props => [lawnData];
}

class EditLawnProfileStateError extends EditLawnProfileState {
  final String errorMessage;

  EditLawnProfileStateError({
    this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
