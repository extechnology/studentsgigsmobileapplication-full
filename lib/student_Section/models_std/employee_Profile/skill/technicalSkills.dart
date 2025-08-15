class TechnicalSkills {
  final int id;
  final String skills;
  final String level;

  TechnicalSkills({
    required this.id,
    required this.skills,
    required this.level,
  });

  factory TechnicalSkills.fromJson(Map<String, dynamic> json) {
    return TechnicalSkills(
      id: json['id'] ?? '',
      skills: json['technical_skill'] ?? '',
      level: json['technical_level'] ?? '',
    );
  }
}
