part of 'experience_bloc.dart';

abstract class ExperienceState extends Equatable {
  const ExperienceState();

  @override
  List<Object> get props => [];
}

class ExperienceInitial extends ExperienceState {}

class ExperienceLoading extends ExperienceState {}

class ExperienceLoaded extends ExperienceState {
  final List<Experiences> experiences;

  const ExperienceLoaded(this.experiences);

  @override
  List<Object> get props => [experiences];
}

class ExperienceAdded extends ExperienceState {
  final List<Experiences> experiences;

  const ExperienceAdded(this.experiences);

  @override
  List<Object> get props => [experiences];
}

class JobTitlesLoading extends ExperienceState {}

class JobTitlesLoaded extends ExperienceState {
  final List<Map<String, String>> jobTitles;

  const JobTitlesLoaded(this.jobTitles);

  @override
  List<Object> get props => [jobTitles];
}

class ExperienceError extends ExperienceState {
  final String message;

  const ExperienceError(this.message);

  @override
  List<Object> get props => [message];
}
