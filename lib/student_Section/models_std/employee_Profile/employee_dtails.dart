
import 'package:anjalim/mainpage/homepageifdatalocation/component/homepagedetailpage/model/model.dart';

class EmployeeProfileWrapper {
  final int id;
  final String? name;

  final List<String>? softSkills;
  final List<String>? educations;
  final List<String>? certifications;
  final List<Map<String, dynamic>>? workPreferences;
  final List<String>? preferredJobCategories;
  final List<String>? experiences;
  final AdditionalInformation? additionalInformation;
  final String? portfolio;

  EmployeeProfileWrapper({
    required this.id,
    this.name,
    this.softSkills,
    this.educations,
    this.certifications,
    this.workPreferences,
    this.preferredJobCategories,
    this.experiences,
    this.additionalInformation,
    this.portfolio,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "name": name,
      'soft_skills': softSkills,
      'educations': educations,
      'certifications': certifications,
      'work_preferences': workPreferences,
      'preferred_job_categories': preferredJobCategories,
      'experiences': experiences,
      'additional_information': additionalInformation?.toJson(),
      'portfolio': portfolio,
    };
  }

  factory EmployeeProfileWrapper.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileWrapper(
      id: json["pk"],
      name: json["name"],
      softSkills: List<String>.from(json['soft_skills'] ?? []),
      educations: List<String>.from(json['educations'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      workPreferences:
          List<Map<String, dynamic>>.from(json['work_preferences'] ?? []),
      preferredJobCategories:
          List<String>.from(json['preferred_job_categories'] ?? []),
      experiences: List<String>.from(json['experiences'] ?? []),
      additionalInformation:
          AdditionalInformation.fromJson(json['additional_information']),
      portfolio: json['portfolio'] ?? '',
    );
  }
}
