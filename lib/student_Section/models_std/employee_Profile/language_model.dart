class LanguageSkill {
  final int id;
  final String language;
  final String level;

  LanguageSkill({
    required this.id,
    required this.language,
    required this.level,
  });

  factory LanguageSkill.fromJson(Map<String, dynamic> json) {
    return LanguageSkill(
      id: json['id'],
      language: json['language'],
      level: json['language_level'],
    );
  }
}
