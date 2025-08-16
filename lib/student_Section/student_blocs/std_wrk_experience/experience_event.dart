part of 'experience_bloc.dart';

abstract class ExperienceEvent extends Equatable {
  const ExperienceEvent();

  @override
  List<Object?> get props => [];
}

class LoadExperiences extends ExperienceEvent {}

class AddExperience extends ExperienceEvent {
  final String companyName;
  final String jobTitle;
  final String startDate;
  final String endDate;
  final bool isWorking;

  const AddExperience({
    required this.companyName,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
    required this.isWorking,
  });

  @override
  List<Object> get props =>
      [companyName, jobTitle, startDate, endDate, isWorking];
}

class DeleteExperience extends ExperienceEvent {
  final int id;

  const DeleteExperience(this.id);

  @override
  List<Object> get props => [id];
}

class LoadJobTitles extends ExperienceEvent {}
