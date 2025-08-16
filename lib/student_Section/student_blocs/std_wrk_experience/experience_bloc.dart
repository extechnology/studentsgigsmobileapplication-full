import 'dart:async';
import 'package:anjalim/student_Section/models_std/employee_Profile/experiencemodel.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/experience_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'experience_event.dart';
part 'experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExperienceService _experienceService;

  ExperienceBloc(this._experienceService) : super(ExperienceInitial()) {
    on<LoadExperiences>(_onLoadExperiences);
    on<AddExperience>(_onAddExperience);
    on<DeleteExperience>(_onDeleteExperience);
    on<LoadJobTitles>(_onLoadJobTitles);
  }

  Future<void> _onLoadExperiences(
      LoadExperiences event, Emitter<ExperienceState> emit) async {
    emit(ExperienceLoading());
    try {
      final experiences = await _experienceService.fetchExperience();
      emit(ExperienceLoaded(experiences));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  Future<void> _onAddExperience(
      AddExperience event, Emitter<ExperienceState> emit) async {
    emit(ExperienceLoading());
    try {
      await _experienceService.postExperience(
        event.companyName,
        event.jobTitle,
        event.startDate,
        event.endDate,
        event.isWorking,
      );

      // After successful addition, load the updated experiences
      final experiences = await _experienceService.fetchExperience();
      emit(ExperienceLoaded(experiences));

      // Emit a special state to indicate successful addition
      emit(ExperienceAdded(experiences));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }

  Future<void> _onDeleteExperience(
      DeleteExperience event, Emitter<ExperienceState> emit) async {
    if (state is ExperienceLoaded) {
      final currentState = state as ExperienceLoaded;
      emit(ExperienceLoading());
      try {
        final success = await _experienceService.deleteExperience(event.id);
        if (success) {
          final experiences = await _experienceService.fetchExperience();
          emit(ExperienceLoaded(experiences));
        } else {
          emit(ExperienceError('Failed to delete experience'));
        }
      } catch (e) {
        emit(ExperienceError(e.toString()));
        // Re-emit the previous state on error
        emit(currentState);
      }
    }
  }

  Future<void> _onLoadJobTitles(
      LoadJobTitles event, Emitter<ExperienceState> emit) async {
    emit(JobTitlesLoading());
    try {
      final jobTitles = await fetchJobTitle();
      emit(JobTitlesLoaded(jobTitles));
    } catch (e) {
      emit(ExperienceError(e.toString()));
    }
  }
}
