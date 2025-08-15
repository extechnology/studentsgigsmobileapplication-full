import 'dart:async';
import 'package:anjalim/student_Section/models_std/employee_Profile/skill/technicalSkills.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/skills.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'technical_skill_event.dart';
part 'technical_skill_state.dart';

class TechnicalSkillBloc
    extends Bloc<TechnicalSkillEvent, TechnicalSkillState> {
  final SkillsService _skillsService;
  bool isProcessing = false;

  TechnicalSkillBloc({required SkillsService skillsService})
      : _skillsService = skillsService,
        super(TechnicalSkillInitial()) {
    on<LoadTechnicalSkills>(_onLoadTechnicalSkills);
    on<AddTechnicalSkill>(_onAddTechnicalSkill);
    on<DeleteTechnicalSkill>(_onDeleteTechnicalSkill);
    on<ResetTechnicalSkillForm>(_onResetTechnicalSkillForm);
  }

  Future<void> _onLoadTechnicalSkills(
      LoadTechnicalSkills event, Emitter<TechnicalSkillState> emit) async {
    if (isProcessing) return;
    isProcessing = true;

    emit(TechnicalSkillLoading());
    try {
      final skills = await _skillsService.fetchSkills(event.context);
      emit(TechnicalSkillLoaded(loadedSkills: skills));
    } catch (e) {
      emit(TechnicalSkillError(message: e.toString()));
    } finally {
      isProcessing = false;
    }
  }

  Future<void> _onAddTechnicalSkill(
      AddTechnicalSkill event, Emitter<TechnicalSkillState> emit) async {
    if (isProcessing) return;
    isProcessing = true;

    if (state is TechnicalSkillLoaded) {
      final currentSkills = (state as TechnicalSkillLoaded).loadedSkills;
      emit(TechnicalSkillProcessing(processingSkills: currentSkills));

      try {
        // Validate level before sending to API
        final validLevels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];
        if (!validLevels.contains(event.level)) {
          throw Exception(
              'Invalid skill level: ${event.level}. Please select from: ${validLevels.join(', ')}');
        }

        await _skillsService.postSkills(
            event.skill, event.level, event.context);
        print("success in skill----${event.skill} at ${event.level} level");

        // Fetch fresh data from server
        final updatedSkills = await _skillsService.fetchSkills(event.context);

        // Emit the loaded state with fresh data - no success state needed
        emit(TechnicalSkillLoaded(loadedSkills: updatedSkills));
      } catch (e) {
        String errorMessage = 'Failed to add skill';

        // Handle specific error cases
        if (e.toString().contains('Invalid skill level')) {
          errorMessage = e.toString();
        } else if (e.toString().contains('400')) {
          errorMessage = 'Invalid skill or level. Please check your selection.';
        } else if (e.toString().contains('422')) {
          errorMessage =
              'Skill level not supported. Please select a different level.';
        } else if (e.toString().contains('500')) {
          errorMessage = 'Server error occurred. Please try again later.';
        } else if (e.toString().toLowerCase().contains('network') ||
            e.toString().toLowerCase().contains('connection')) {
          errorMessage =
              'Network error. Please check your connection and try again.';
        } else {
          errorMessage = 'Unknown error occurred: ${e.toString()}';
        }

        print("Error in add skill----$e");
        emit(TechnicalSkillError(
          message: errorMessage,
          currentSkills: currentSkills,
        ));
      } finally {
        isProcessing = false;
      }
    }
  }

  Future<void> _onDeleteTechnicalSkill(
      DeleteTechnicalSkill event, Emitter<TechnicalSkillState> emit) async {
    if (isProcessing) return;
    isProcessing = true;

    if (state is TechnicalSkillLoaded) {
      final currentSkills = (state as TechnicalSkillLoaded).loadedSkills;

      // Show optimistic update
      final optimisticSkills =
          currentSkills.where((s) => s.id != event.id).toList();
      emit(TechnicalSkillProcessing(processingSkills: optimisticSkills));

      try {
        await _skillsService.deleteSkill(event.id, event.context);
        print("success in delete skill----${event.id}");

        // Fetch fresh data from server to ensure consistency
        final updatedSkills = await _skillsService.fetchSkills(event.context);

        // Emit the loaded state - no success state needed
        emit(TechnicalSkillLoaded(loadedSkills: updatedSkills));
      } catch (e) {
        print("Error in delete skill----$e");
        // Revert to original state on error
        emit(TechnicalSkillError(
          message: 'Failed to delete skill: ${e.toString()}',
          currentSkills: currentSkills,
        ));
      } finally {
        isProcessing = false;
      }
    }
  }

  void _onResetTechnicalSkillForm(
      ResetTechnicalSkillForm event, Emitter<TechnicalSkillState> emit) {
    if (state is TechnicalSkillLoaded) {
      emit(TechnicalSkillLoaded(
        loadedSkills: (state as TechnicalSkillLoaded).loadedSkills,
      ));
    }
  }
}
