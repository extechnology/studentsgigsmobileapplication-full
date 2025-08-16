// education_bloc/education_state.dart
part of 'education_bloc.dart';

abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object> get props => [];
}

class EducationInitial extends EducationState {}

class EducationLoading extends EducationState {}

class EducationLoaded extends EducationState {
  final List<EducationDetail> educations;

  const EducationLoaded(this.educations);

  @override
  List<Object> get props => [educations];
}

class EducationError extends EducationState {
  final String message;

  const EducationError(this.message);

  @override
  List<Object> get props => [message];
}

class FieldsOfStudyLoaded extends EducationState {
  final List<String> fields;

  const FieldsOfStudyLoaded(this.fields);

  @override
  List<Object> get props => [fields];
}

class UniversitiesLoaded extends EducationState {
  final List<String> universities;

  const UniversitiesLoaded(this.universities);

  @override
  List<Object> get props => [universities];
}

class EducationOperationSuccess extends EducationState {
  final String message;

  const EducationOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
