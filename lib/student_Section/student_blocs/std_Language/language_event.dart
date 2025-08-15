import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLanguages extends LanguageEvent {}

class AddLanguage extends LanguageEvent {
  final String language;
  final String level;

  AddLanguage(this.language, this.level);

  @override
  List<Object?> get props => [language, level];
}

class DeleteLanguage extends LanguageEvent {
  final int id;

  DeleteLanguage(this.id);

  @override
  List<Object?> get props => [id];
}
