part of 'soft_skill_bloc.dart';

abstract class SoftSkillEvent extends Equatable {
  const SoftSkillEvent();

  @override
  List<Object> get props => [];
}

class LoadSoftSkills extends SoftSkillEvent {
  final BuildContext context;

  const LoadSoftSkills(this.context);

  @override
  List<Object> get props => [context];
}

class AddSoftSkill extends SoftSkillEvent {
  final String skill;
  final BuildContext context;

  const AddSoftSkill(this.skill, this.context);

  @override
  List<Object> get props => [skill, context];
}

class DeleteSoftSkill extends SoftSkillEvent {
  final int id;
  final BuildContext context;

  const DeleteSoftSkill(this.id, this.context);

  @override
  List<Object> get props => [id, context];
}

class SelectSoftSkill extends SoftSkillEvent {
  final String skill;

  const SelectSoftSkill(this.skill);

  @override
  List<Object> get props => [skill];
}

class ClearSelection extends SoftSkillEvent {}
