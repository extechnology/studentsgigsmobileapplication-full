class SoftSkills {
  final int id;
  final String skillName;

  SoftSkills({
    required this.id,
    required this.skillName,
  });

  factory SoftSkills.fromJson(Map<String, dynamic> json) {
    return SoftSkills(
      id: json['id'],
      skillName: json['soft_skill'] ?? "",
    );
  }
}
