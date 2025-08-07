import 'package:equatable/equatable.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object> get props => [];
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<Map<String, dynamic>> jobs;

  const JobsLoaded({required this.jobs});

  @override
  List<Object> get props => [jobs];
}

class JobsError extends JobsState {
  final String message;

  const JobsError({required this.message});

  @override
  List<Object> get props => [message];
}
