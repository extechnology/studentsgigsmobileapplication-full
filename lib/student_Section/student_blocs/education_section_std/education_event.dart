// education_bloc/education_event.dart
part of 'education_bloc.dart';

abstract class EducationEvent extends Equatable {
  const EducationEvent();

  @override
  List<Object> get props => [];
}

class LoadEducationDetails extends EducationEvent {}

class AddEducationDetail extends EducationEvent {
  final String fieldOfStudy;
  final String institution;
  final String graduationYear;
  final String academicLevel;
  final String achievement;

  const AddEducationDetail({
    required this.fieldOfStudy,
    required this.institution,
    required this.graduationYear,
    required this.academicLevel,
    required this.achievement,
  });

  @override
  List<Object> get props => [
        fieldOfStudy,
        institution,
        graduationYear,
        academicLevel,
        achievement,
      ];
}

class DeleteEducationDetail extends EducationEvent {
  final int id;

  const DeleteEducationDetail(this.id);

  @override
  List<Object> get props => [id];
}

class LoadFieldsOfStudy extends EducationEvent {}

class SearchUniversities extends EducationEvent {
  final String query;

  const SearchUniversities(this.query);

  @override
  List<Object> get props => [query];
}

class ClearUniversitySearch extends EducationEvent {}
