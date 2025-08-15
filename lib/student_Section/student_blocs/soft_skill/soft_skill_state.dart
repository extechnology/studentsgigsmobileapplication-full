part of 'soft_skill_bloc.dart';

abstract class SoftSkillState extends Equatable {
  const SoftSkillState();

  @override
  List<Object> get props => [];
}

class SoftSkillInitial extends SoftSkillState {}

class SoftSkillLoading extends SoftSkillState {}

class SoftSkillLoaded extends SoftSkillState {
  final List<SoftSkills> softSkills;
  final String? selectedSkill;

  const SoftSkillLoaded({
    required this.softSkills,
    this.selectedSkill,
  });

  SoftSkillLoaded copyWith({
    List<SoftSkills>? softSkills,
    String? selectedSkill,
  }) {
    return SoftSkillLoaded(
      softSkills: softSkills ?? this.softSkills,
      selectedSkill: selectedSkill ?? this.selectedSkill,
    );
  }

  @override
  List<Object> get props => [softSkills, selectedSkill ?? ''];
}

class SoftSkillError extends SoftSkillState {
  final String message;

  const SoftSkillError({required this.message});

  @override
  List<Object> get props => [message];
}
