import 'package:equatable/equatable.dart';

abstract class SavedJobEvent extends Equatable {
  const SavedJobEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedJobs extends SavedJobEvent {}

class ToggleSaveJob extends SavedJobEvent {
  final Map<String, dynamic> job;

  const ToggleSaveJob(this.job);

  @override
  List<Object> get props => [job];
}
