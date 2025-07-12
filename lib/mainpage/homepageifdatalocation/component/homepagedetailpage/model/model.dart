// To parse this JSON data, do
//
//     final empleedetailpage = empleedetailpageFromJson(jsonString);

import 'dart:convert';

Empleedetailpage empleedetailpageFromJson(String str) => Empleedetailpage.fromJson(json.decode(str));

String empleedetailpageToJson(Empleedetailpage data) => json.encode(data.toJson());

class Empleedetailpage {
  int id;
  Profile profile;
  List<Language> languages;
  List<TechnicalSkill> technicalSkills;
  List<SoftSkill> softSkills;
  List<Education> educations;
  List<dynamic> certifications;
  List<WorkPreference> workPreferences;
  List<PreferredJobCategory> preferredJobCategories;
  List<Experience> experiences;
  AdditionalInformation additionalInformation;
  bool premiumBadge;
  String? username;
  String ?name;
  dynamic profilePhoto;
  String ?email;
  String ?phone;
  String ?preferredWorkLocation;
  int availableWorkHours;
  String ?portfolio;
  String? about;
  String ?jobTitle;
  String ?gender;
  DateTime? dateOfBirth;
  int age;
  String ?plan;
  int profileView;
  DateTime ? createdDate;
  int user;

  Empleedetailpage({
    required this.id,
    required this.profile,
    required this.languages,
    required this.technicalSkills,
    required this.softSkills,
    required this.educations,
    required this.certifications,
    required this.workPreferences,
    required this.preferredJobCategories,
    required this.experiences,
    required this.additionalInformation,
    required this.premiumBadge,
    this.username,
    this.name,
    this.profilePhoto,
    this.email,
    this.phone,
    this.preferredWorkLocation,
    required this.availableWorkHours,
    this.portfolio,
    this.about,
    this.jobTitle,
    this.gender,
    required this.dateOfBirth,
    required this.age,
    this.plan,
    required this.profileView,
    required this.createdDate,
    required this.user,
  });

  factory Empleedetailpage.fromJson(Map<String, dynamic> json) => Empleedetailpage(
    id: json["id"] ?? "",
    profile: Profile.fromJson(json["profile"] ?? ""),
    languages: List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
    technicalSkills: List<TechnicalSkill>.from(json["technical_skills"].map((x) => TechnicalSkill.fromJson(x))),
    softSkills: List<SoftSkill>.from(json["soft_skills"].map((x) => SoftSkill.fromJson(x))),
    educations: List<Education>.from(json["educations"].map((x) => Education.fromJson(x))),
    certifications: List<dynamic>.from(json["certifications"].map((x) => x)),
    workPreferences: List<WorkPreference>.from(json["work_preferences"].map((x) => WorkPreference.fromJson(x))),
    preferredJobCategories: List<PreferredJobCategory>.from(json["preferred_job_categories"].map((x) => PreferredJobCategory.fromJson(x))),
    experiences: List<Experience>.from(json["experiences"].map((x) => Experience.fromJson(x))),
    additionalInformation: AdditionalInformation.fromJson(json["additional_information"]),
    premiumBadge: json["premium_badge"] ?? "",
    username: json["username"] ?? "",
    name: json["name"] ?? "",
    profilePhoto: json["profile_photo"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    preferredWorkLocation: json["preferred_work_location"] ?? "",
    availableWorkHours: json["available_work_hours"] ?? "",
    portfolio: json["portfolio"] ?? "",
    about: json["about"] ?? "",
    jobTitle: json["job_title"] ?? "",
    gender: json["gender"],
    dateOfBirth: DateTime.tryParse(json["date_of_birth"] ?? ""),
    age: json["age"] ?? "",
    plan: json["plan"] ?? "",
    profileView: json["profile_view"] ?? "",
    createdDate: DateTime.tryParse(json["created_date"] ?? ""),
    user: json["user"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile": profile.toJson(),
    "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
    "technical_skills": List<dynamic>.from(technicalSkills.map((x) => x.toJson())),
    "soft_skills": List<dynamic>.from(softSkills.map((x) => x.toJson())),
    "educations": List<dynamic>.from(educations.map((x) => x.toJson())),
    "certifications": List<dynamic>.from(certifications.map((x) => x)),
    "work_preferences": List<dynamic>.from(workPreferences.map((x) => x.toJson())),
    "preferred_job_categories": List<dynamic>.from(preferredJobCategories.map((x) => x.toJson())),
    "experiences": List<dynamic>.from(experiences.map((x) => x.toJson())),
    "additional_information": additionalInformation.toJson(),
    "premium_badge": premiumBadge,
    "username": username,
    "name": name,
    "profile_photo": profilePhoto,
    "email": email,
    "phone": phone,
    "preferred_work_location": preferredWorkLocation,
    "available_work_hours": availableWorkHours,
    "portfolio": portfolio,
    "about": about,
    "job_title": jobTitle,
    "gender": gender,
    "date_of_birth": "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
    "age": age,
    "plan": plan,
    "profile_view": profileView,
    "created_date": createdDate?.toIso8601String(),
    "user": user,
  };
}

class AdditionalInformation {
  String ? employeeResume;
  dynamic hobbiesOrInterests;
  dynamic referenceOrTestimonials;

  AdditionalInformation({
    this.employeeResume,
    this.hobbiesOrInterests,
    this.referenceOrTestimonials,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) => AdditionalInformation(
    employeeResume: json["employee_resume"] ?? "",
    hobbiesOrInterests: json["hobbies_or_interests"] ?? "",
    referenceOrTestimonials: json["reference_or_testimonials"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "employee_resume": employeeResume,
    "hobbies_or_interests": hobbiesOrInterests,
    "reference_or_testimonials": referenceOrTestimonials,
  };
}

class Education {
  int id;
  String? fieldOfStudy;
  String? nameOfInstitution;
  String? expectedGraduationYear;
  String ?academicLevel;
  String ?achievementName;
  int employee;

  Education({
    required this.id,
    this.fieldOfStudy,
    this.nameOfInstitution,
    this.expectedGraduationYear,
    this.academicLevel,
    this.achievementName,
    required this.employee,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"] ?? "",
    fieldOfStudy: json["field_of_study"] ?? "",
    nameOfInstitution: json["name_of_institution"] ?? "",
    expectedGraduationYear: json["expected_graduation_year"] ?? "",
    academicLevel: json["academic_level"] ?? "",
    achievementName: json["achievement_name"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field_of_study": fieldOfStudy,
    "name_of_institution": nameOfInstitution,
    "expected_graduation_year": expectedGraduationYear,
    "academic_level": academicLevel,
    "achievement_name": achievementName,
    "employee": employee,
  };
}

class Experience {
  int id;
  String? expCompanyName;
  String ?expJobTitle;
  DateTime expStartDate;
  DateTime expEndDate;
  bool expWorking;
  int employee;

  Experience({
    required this.id,
    this.expCompanyName,
    this.expJobTitle,
    required this.expStartDate,
    required this.expEndDate,
    required this.expWorking,
    required this.employee,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json["id"] ?? "",
    expCompanyName: json["exp_company_name"] ?? "",
    expJobTitle: json["exp_job_title"] ?? "",
    expStartDate: DateTime.tryParse(json["exp_start_date"] ?? "") ?? DateTime(2000),
    expEndDate: DateTime.tryParse(json["exp_end_date"] ?? "") ?? DateTime(2000),
    expWorking: json["exp_working"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "exp_company_name": expCompanyName,
    "exp_job_title": expJobTitle,
    "exp_start_date": "${expStartDate.year.toString().padLeft(4, '0')}-${expStartDate.month.toString().padLeft(2, '0')}-${expStartDate.day.toString().padLeft(2, '0')}",
    "exp_end_date": "${expEndDate.year.toString().padLeft(4, '0')}-${expEndDate.month.toString().padLeft(2, '0')}-${expEndDate.day.toString().padLeft(2, '0')}",
    "exp_working": expWorking,
    "employee": employee,
  };
}

class Language {
  int id;
  String? language;
  String ?languageLevel;
  int employee;

  Language({
    required this.id,
    this.language,
    this.languageLevel,
    required this.employee,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"] ?? "",
    language: json["language"] ?? "",
    languageLevel: json["language_level"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language": language,
    "language_level": languageLevel,
    "employee": employee,
  };
}

class PreferredJobCategory {
  int id;
  String ?preferredJobCategory;
  int employee;

  PreferredJobCategory({
    required this.id,
    this.preferredJobCategory,
    required this.employee,
  });

  factory PreferredJobCategory.fromJson(Map<String, dynamic> json) => PreferredJobCategory(
    id: json["id"] ?? "",
    preferredJobCategory: json["preferred_job_category"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preferred_job_category": preferredJobCategory,
    "employee": employee,
  };
}

class Profile {
  int id;
  String ?employeeName;
  String ?jobTitle;
  String? username;
  String ?coverPhoto;
  String ?profilePic;
  int employee;

  Profile({
    required this.id,
    this.employeeName,
    this.jobTitle,
    this.username,
    this.coverPhoto,
    this.profilePic,
    required this.employee,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"] ?? "",
    employeeName: json["employee_name"] ?? "",
    jobTitle: json["job_title"] ?? "",
    username: json["username"] ?? "",
    coverPhoto: json["cover_photo"] ?? "",
    profilePic: json["profile_pic"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_name": employeeName,
    "job_title": jobTitle,
    "username": username,
    "cover_photo": coverPhoto,
    "profile_pic": profilePic,
    "employee": employee,
  };
}

class SoftSkill {
  int id;
  String? softSkill;
  int employee;

  SoftSkill({
    required this.id,
    this.softSkill,
    required this.employee,
  });

  factory SoftSkill.fromJson(Map<String, dynamic> json) => SoftSkill(
    id: json["id"] ?? "",
    softSkill: json["soft_skill"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "soft_skill": softSkill,
    "employee": employee,
  };
}

class TechnicalSkill {
  int id;
  String ?technicalSkill;
  String? technicalLevel;
  int employee;

  TechnicalSkill({
    required this.id,
    this.technicalSkill,
    this.technicalLevel,
    required this.employee,
  });

  factory TechnicalSkill.fromJson(Map<String, dynamic> json) => TechnicalSkill(
    id: json["id"] ?? "",
    technicalSkill: json["technical_skill"] ?? "",
    technicalLevel: json["technical_level"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "technical_skill": technicalSkill,
    "technical_level": technicalLevel,
    "employee": employee,
  };
}

class WorkPreference {
  int id;
  String ?interestedJobType;
  String? expectedSalaryRange;
  String ?availability;
  String? transportationAvailability;
  int employee;

  WorkPreference({
    required this.id,
    this.interestedJobType,
    this.expectedSalaryRange,
    this.availability,
    this.transportationAvailability,
    required this.employee,
  });

  factory WorkPreference.fromJson(Map<String, dynamic> json) => WorkPreference(
    id: json["id"] ?? "",
    interestedJobType: json["interested_job_type"] ?? "",
    expectedSalaryRange: json["expected_salary_range"] ?? "",
    availability: json["availability"] ?? "",
    transportationAvailability: json["transportation_availability"] ?? "",
    employee: json["employee"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "interested_job_type": interestedJobType,
    "expected_salary_range": expectedSalaryRange,
    "availability": availability,
    "transportation_availability": transportationAvailability,
    "employee": employee,
  };
}
