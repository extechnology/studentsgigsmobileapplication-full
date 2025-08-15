part of 'technical_skill_bloc.dart';

abstract class TechnicalSkillState extends Equatable {
  final List<TechnicalSkills>? skills;

  const TechnicalSkillState({this.skills});

  @override
  List<Object?> get props => [skills];
}

class TechnicalSkillInitial extends TechnicalSkillState {
  const TechnicalSkillInitial() : super(skills: null);
}

class TechnicalSkillLoading extends TechnicalSkillState {
  const TechnicalSkillLoading({List<TechnicalSkills>? skills})
      : super(skills: skills);
}

class TechnicalSkillLoaded extends TechnicalSkillState {
  final List<TechnicalSkills> loadedSkills;

  const TechnicalSkillLoaded({required this.loadedSkills})
      : super(skills: loadedSkills);
}

class TechnicalSkillProcessing extends TechnicalSkillState {
  final List<TechnicalSkills> processingSkills;

  const TechnicalSkillProcessing({required this.processingSkills})
      : super(skills: processingSkills);
}

class TechnicalSkillError extends TechnicalSkillState {
  final String message;
  final List<TechnicalSkills>? currentSkills;

  const TechnicalSkillError({
    required this.message,
    this.currentSkills,
  }) : super(skills: currentSkills);
}

class TechnicalSkillSuccess extends TechnicalSkillState {
  final String message;
  final List<TechnicalSkills> currentSkills;

  const TechnicalSkillSuccess({
    required this.message,
    required this.currentSkills,
  }) : super(skills: currentSkills);
}
