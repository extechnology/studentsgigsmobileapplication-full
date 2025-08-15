part of 'technical_skill_bloc.dart';

abstract class TechnicalSkillEvent extends Equatable {
  const TechnicalSkillEvent();

  @override
  List<Object> get props => [];
}

class LoadTechnicalSkills extends TechnicalSkillEvent {
  final BuildContext context;

  const LoadTechnicalSkills({required this.context});

  @override
  List<Object> get props => [context];
}

class AddTechnicalSkill extends TechnicalSkillEvent {
  final String skill;
  final String level;
  final BuildContext context;

  const AddTechnicalSkill({
    required this.skill,
    required this.level,
    required this.context,
  });

  @override
  List<Object> get props => [skill, level, context];
}

class DeleteTechnicalSkill extends TechnicalSkillEvent {
  final int id;
  final BuildContext context;

  const DeleteTechnicalSkill({
    required this.id,
    required this.context,
  });

  @override
  List<Object> get props => [id, context];
}

class ResetTechnicalSkillForm extends TechnicalSkillEvent {}
