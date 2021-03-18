import 'package:equatable/equatable.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class InitialActivityState extends ActivityState {}

class SuccessActivityState extends ActivityState {}

class SuccessUpdateActivityState extends ActivityState {}

class LoadingActivityState extends ActivityState {}

class ErrorActivityState extends ActivityState {}
