// To parse this JSON data, do
//
//     final seachdata = seachdataFromJson(jsonString);

import 'dart:convert';

Seachdata seachdataFromJson(String str) => Seachdata.fromJson(json.decode(str));

String seachdataToJson(Seachdata data) => json.encode(data.toJson());
//gvhvc
class Seachdata {
  int pageNumber;
  int totalPages;
  List<Datum> data;

  Seachdata({
    required this.pageNumber,
    required this.totalPages,
    required this.data,
  });

  factory Seachdata.fromJson(Map<String, dynamic> json) => Seachdata(
    pageNumber: json["page_number"],
    totalPages: json["total_pages"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page_number": pageNumber,
    "total_pages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  List<dynamic> preferredJobCategories;
  List<WorkPreference> workPreferences;
  Profile profile;
  bool premiumBadge;
  String name;
  dynamic profilePhoto;
  String email;
  String phone;
  String preferredWorkLocation;
  int availableWorkHours;
  DateTime availableWorkingPeriodsStartDate;
  DateTime availableWorkingPeriodsEndDate;
  dynamic portfolio;
  String about;
  String jobTitle;
  String gender;
  DateTime dateOfBirth;
  int age;
  String plan;
  int profileView;
  DateTime createdDate;
  int user;

  Datum({
    required this.id,
    required this.preferredJobCategories,
    required this.workPreferences,
    required this.profile,
    required this.premiumBadge,
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.phone,
    required this.preferredWorkLocation,
    required this.availableWorkHours,
    required this.availableWorkingPeriodsStartDate,
    required this.availableWorkingPeriodsEndDate,
    required this.portfolio,
    required this.about,
    required this.jobTitle,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.plan,
    required this.profileView,
    required this.createdDate,
    required this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    preferredJobCategories: List<dynamic>.from(json["preferred_job_categories"].map((x) => x)),
    workPreferences: List<WorkPreference>.from(json["work_preferences"].map((x) => WorkPreference.fromJson(x))),
    profile: Profile.fromJson(json["profile"]),
    premiumBadge: json["premium_badge"],
    name: json["name"],
    profilePhoto: json["profile_photo"],
    email: json["email"],
    phone: json["phone"],
    preferredWorkLocation: json["preferred_work_location"],
    availableWorkHours: json["available_work_hours"],
    availableWorkingPeriodsStartDate: DateTime.parse(json["available_working_periods_start_date"]),
    availableWorkingPeriodsEndDate: DateTime.parse(json["available_working_periods_end_date"]),
    portfolio: json["portfolio"],
    about: json["about"],
    jobTitle: json["job_title"],
    gender: json["gender"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    age: json["age"],
    plan: json["plan"],
    profileView: json["profile_view"],
    createdDate: DateTime.parse(json["created_date"]),
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preferred_job_categories": List<dynamic>.from(preferredJobCategories.map((x) => x)),
    "work_preferences": List<dynamic>.from(workPreferences.map((x) => x.toJson())),
    "profile": profile.toJson(),
    "premium_badge": premiumBadge,
    "name": name,
    "profile_photo": profilePhoto,
    "email": email,
    "phone": phone,
    "preferred_work_location": preferredWorkLocation,
    "available_work_hours": availableWorkHours,
    "available_working_periods_start_date": "${availableWorkingPeriodsStartDate.year.toString().padLeft(4, '0')}-${availableWorkingPeriodsStartDate.month.toString().padLeft(2, '0')}-${availableWorkingPeriodsStartDate.day.toString().padLeft(2, '0')}",
    "available_working_periods_end_date": "${availableWorkingPeriodsEndDate.year.toString().padLeft(4, '0')}-${availableWorkingPeriodsEndDate.month.toString().padLeft(2, '0')}-${availableWorkingPeriodsEndDate.day.toString().padLeft(2, '0')}",
    "portfolio": portfolio,
    "about": about,
    "job_title": jobTitle,
    "gender": gender,
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "age": age,
    "plan": plan,
    "profile_view": profileView,
    "created_date": createdDate.toIso8601String(),
    "user": user,
  };
}

class Profile {
  int id;
  dynamic coverPhoto;
  dynamic profilePic;
  int employee;

  Profile({
    required this.id,
    required this.coverPhoto,
    required this.profilePic,
    required this.employee,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    coverPhoto: json["cover_photo"],
    profilePic: json["profile_pic"],
    employee: json["employee"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cover_photo": coverPhoto,
    "profile_pic": profilePic,
    "employee": employee,
  };
}

class WorkPreference {
  int id;
  String interestedJobType;
  String expectedSalaryRange;
  String availability;
  String transportationAvailability;
  int employee;

  WorkPreference({
    required this.id,
    required this.interestedJobType,
    required this.expectedSalaryRange,
    required this.availability,
    required this.transportationAvailability,
    required this.employee,
  });

  factory WorkPreference.fromJson(Map<String, dynamic> json) => WorkPreference(
    id: json["id"],
    interestedJobType: json["interested_job_type"],
    expectedSalaryRange: json["expected_salary_range"],
    availability: json["availability"],
    transportationAvailability: json["transportation_availability"],
    employee: json["employee"],
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
