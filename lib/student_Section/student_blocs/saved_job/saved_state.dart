import 'package:equatable/equatable.dart';

abstract class SavedJobState extends Equatable {
  const SavedJobState();

  @override
  List<Object> get props => [];
}

class SavedJobInitial extends SavedJobState {}

class SavedJobLoading extends SavedJobState {}

class SavedJobLoaded extends SavedJobState {
  final List<Map<String, dynamic>> savedJobs;

  const SavedJobLoaded({required this.savedJobs});

  @override
  List<Object> get props => [savedJobs];
}

class SavedJobError extends SavedJobState {
  final String message;

  const SavedJobError({required this.message});

  @override
  List<Object> get props => [message];
}
