// soft_skill_model.dart
class SoftSkill {
  final int id;
  final String skillName;

  SoftSkill({
    required this.id,
    required this.skillName,
  });

  factory SoftSkill.fromJson(Map<String, dynamic> json) {
    return SoftSkill(
      id: json['id'],
      skillName: json['soft_skill'] ?? "",
    );
  }
}
