import 'package:equatable/equatable.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object> get props => [];
}

class LoadPopularJobs extends JobsEvent {}

class RefreshJobs extends JobsEvent {}

class ToggleSaveJob extends JobsEvent {
  final String jobId;
  final String jobType;
  final bool isCurrentlySaved;

  const ToggleSaveJob({
    required this.jobId,
    required this.jobType,
    required this.isCurrentlySaved,
  });

  @override
  List<Object> get props => [jobId, jobType, isCurrentlySaved];
}
