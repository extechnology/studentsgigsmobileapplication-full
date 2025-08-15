import 'package:equatable/equatable.dart';

abstract class WorkPreferenceEvent extends Equatable {
  const WorkPreferenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchWorkPreference extends WorkPreferenceEvent {}

class UpdateWorkPreference extends WorkPreferenceEvent {
  final String jobType;
  final String? salaryRange;
  final String? availability;
  final String? transportation;

  const UpdateWorkPreference({
    required this.jobType,
    this.salaryRange,
    this.availability,
    this.transportation,
  });

  @override
  List<Object?> get props =>
      [jobType, salaryRange, availability, transportation];
}
