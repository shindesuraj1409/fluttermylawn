part of 'edit_lawn_profile_bloc.dart';

abstract class EditLawnProfileEvent extends Equatable {
  const EditLawnProfileEvent();

  @override
  List<Object> get props => [];
}

class EditLawnProfileEventLoad extends EditLawnProfileEvent {
  final String screenPath;
  final Object lawnData;

  const EditLawnProfileEventLoad({this.screenPath, this.lawnData});

  @override
  List<Object> get props => [screenPath, lawnData];
}
