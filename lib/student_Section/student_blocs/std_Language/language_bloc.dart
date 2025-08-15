import 'package:anjalim/student_Section/services/profile_update_searvices/language_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageRepository repository;

  LanguageBloc(this.repository) : super(LanguageInitial()) {
    on<FetchLanguages>((event, emit) async {
      emit(LanguageLoading());
      try {
        final langs = await repository.fetchLanguageSkills();
        emit(LanguageLoaded(langs));
      } catch (e) {
        emit(LanguageError(e.toString()));
      }
    });

    on<AddLanguage>((event, emit) async {
      emit(LanguageLoading());
      try {
        await repository.addLanguage(event.language, event.level);
        final langs = await repository.fetchLanguageSkills();
        emit(LanguageLoaded(langs));
        emit(LanguageActionSuccess("${event.language} added successfully"));
      } catch (e) {
        emit(LanguageError(e.toString()));
      }
    });

    on<DeleteLanguage>((event, emit) async {
      emit(LanguageLoading());
      try {
        await repository.deleteLanguage(event.id);
        final langs = await repository.fetchLanguageSkills();
        emit(LanguageLoaded(langs));
        emit(LanguageActionSuccess("Language deleted successfully"));
      } catch (e) {
        emit(LanguageError(e.toString()));
      }
    });
  }
}
