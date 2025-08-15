import 'package:anjalim/student_Section/models_std/employee_Profile/language_model.dart';
import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final List<LanguageSkill> languages;

  LanguageLoaded(this.languages);

  @override
  List<Object?> get props => [languages];
}

class LanguageError extends LanguageState {
  final String message;

  LanguageError(this.message);

  @override
  List<Object?> get props => [message];
}

class LanguageActionSuccess extends LanguageState {
  final String message;

  LanguageActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
