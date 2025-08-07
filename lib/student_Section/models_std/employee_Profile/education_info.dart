class EducationDetail {
  final int id;
  final String fieldOfStudy;
  final String institution;
  final String graduationYear;
  final String academicLevel;
  final String achievement;
  final int employeeId;

  EducationDetail({
    required this.id,
    required this.fieldOfStudy,
    required this.institution,
    required this.graduationYear,
    required this.academicLevel,
    required this.achievement,
    required this.employeeId,
  });

  factory EducationDetail.fromJson(Map<String, dynamic> json) {
    return EducationDetail(
      id: json['id'],
      fieldOfStudy: json['field_of_study'] ?? '',
      institution: json['name_of_institution'] ?? '',
      graduationYear: json['expected_graduation_year'] ?? '',
      academicLevel: json['academic_level'] ?? '',
      achievement: json['achievement_name'] ?? '',
      employeeId: json['employee'],
    );
  }
}
