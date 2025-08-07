class TechnicalSkill {
  final int id;
  final String skills;
  final String level;

  TechnicalSkill({
    required this.id,
    required this.skills,
    required this.level,
  });

  factory TechnicalSkill.fromJson(Map<String, dynamic> json) {
    return TechnicalSkill(
      id: json['id'] ?? '',
      skills: json['technical_skill'] ?? '',
      level: json['technical_level'] ?? '',
    );
  }
}
