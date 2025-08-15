import 'dart:async';
import 'package:anjalim/student_Section/models_std/employee_Profile/skill/skillsoft.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/soft_skill.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'soft_skill_event.dart';
part 'soft_skill_state.dart';

class SoftSkillBloc extends Bloc<SoftSkillEvent, SoftSkillState> {
  final SoftSkillsService _softSkillsService;

  SoftSkillBloc(this._softSkillsService) : super(SoftSkillInitial()) {
    on<LoadSoftSkills>(_onLoadSoftSkills);
    on<AddSoftSkill>(_onAddSoftSkill);
    on<DeleteSoftSkill>(_onDeleteSoftSkill);
    on<SelectSoftSkill>(_onSelectSoftSkill);
    on<ClearSelection>(_onClearSelection);
  }

  Future<void> _onLoadSoftSkills(
      LoadSoftSkills event, Emitter<SoftSkillState> emit) async {
    emit(SoftSkillLoading());
    try {
      final softSkills =
          await _softSkillsService.fetchSoftSkills(event.context);
      emit(SoftSkillLoaded(softSkills: softSkills));
    } catch (e) {
      emit(SoftSkillError(message: e.toString()));
    }
  }

  Future<void> _onAddSoftSkill(
      AddSoftSkill event, Emitter<SoftSkillState> emit) async {
    if (state is SoftSkillLoaded) {
      final currentState = state as SoftSkillLoaded;
      emit(SoftSkillLoading());
      try {
        await _softSkillsService.postSoftSkills(event.skill, event.context);
        final softSkills =
            await _softSkillsService.fetchSoftSkills(event.context);
        emit(SoftSkillLoaded(
          softSkills: softSkills,
          selectedSkill: null,
        ));
      } catch (e) {
        emit(SoftSkillError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteSoftSkill(
      DeleteSoftSkill event, Emitter<SoftSkillState> emit) async {
    if (state is SoftSkillLoaded) {
      final currentState = state as SoftSkillLoaded;

      // Optimistically remove the skill from UI
      final updatedSkills = List<SoftSkills>.from(currentState.softSkills)
        ..removeWhere((skill) => skill.id == event.id);

      emit(currentState.copyWith(softSkills: updatedSkills));

      try {
        await _softSkillsService.deleteSoftSkill(event.id, event.context);

        // Refresh the list from server to ensure consistency
        final softSkills =
            await _softSkillsService.fetchSoftSkills(event.context);
        emit(SoftSkillLoaded(softSkills: softSkills));
      } catch (e) {
        // If error occurs, revert to previous state
        emit(currentState);
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(content: Text('Failed to delete skill: ${e.toString()}')),
        );
      }
    }
  }

  void _onSelectSoftSkill(SelectSoftSkill event, Emitter<SoftSkillState> emit) {
    if (state is SoftSkillLoaded) {
      final currentState = state as SoftSkillLoaded;
      emit(currentState.copyWith(selectedSkill: event.skill));
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<SoftSkillState> emit) {
    if (state is SoftSkillLoaded) {
      final currentState = state as SoftSkillLoaded;
      emit(currentState.copyWith(selectedSkill: null));
    }
  }
}
