// To parse this JSON data:
// final postedpagelist = postedpagelistFromJson(jsonString);

import 'dart:convert';

List<Postedpagelist> postedpagelistFromJson(String str) =>
    List<Postedpagelist>.from(json.decode(str).map((x) => Postedpagelist.fromJson(x)));

String postedpagelistToJson(List<Postedpagelist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// wdjdvcqh
class Postedpagelist {
  int ? id;
  Employee employee;
  DateTime dateApplied;
  String ? resume;
  int ?onlineJob;
  dynamic offlineJob;

  Postedpagelist({
     this.id,
    required this.employee,
    required this.dateApplied,
     this.resume,
     this.onlineJob,
    this.offlineJob,
  });

  factory Postedpagelist.fromJson(Map<String, dynamic> json) => Postedpagelist(
    id: json["id"]?? 0,
    employee: Employee.fromJson(json["employee"]),
    dateApplied: DateTime.parse(json["date_applied"]),
    resume: json["resume"]?? "",
    onlineJob: json["online_job"]?? 0,
    offlineJob: json["offline_job"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee": employee.toJson(),
    "date_applied": dateApplied.toIso8601String(),
    "resume": resume,
    "online_job": onlineJob,
    "offline_job": offlineJob,
  };
}

class Employee {
  int ? id;
  List<PreferredJobCategory> preferredJobCategories;
  List<WorkPreference> workPreferences;
  Profile profile;
  bool premiumBadge;
  String ? name;
  dynamic profilePhoto;
  String? email;
  dynamic phone;
  dynamic preferredWorkLocation;
  dynamic availableWorkHours;
  dynamic portfolio;
  dynamic about;
  String ?jobTitle;
  dynamic gender;
  dynamic dateOfBirth;
  int ? age;
  String ? plan;
  int? profileView;
  DateTime createdDate;
  int ? user;

  Employee({
     this.id,
    required this.preferredJobCategories,
    required this.workPreferences,
    required this.profile,
    required this.premiumBadge,
     this.name,
    this.profilePhoto,
     this.email,
    this.phone,
    this.preferredWorkLocation,
    this.availableWorkHours,
    this.portfolio,
    this.about,
     this.jobTitle,
    this.gender,
    this.dateOfBirth,
     this.age,
     this.plan,
     this.profileView,
    required this.createdDate,
     this.user,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    preferredJobCategories: (json["preferred_job_categories"] is List)
        ? (json["preferred_job_categories"] as List)
        .map((e) => e is Map<String, dynamic> ? PreferredJobCategory.fromJson(e) : null)
        .whereType<PreferredJobCategory>()
        .toList()
        : [],

    workPreferences: (json["work_preferences"] is List)
        ? (json["work_preferences"] as List)
        .map((e) => e is Map<String, dynamic> ? WorkPreference.fromJson(e) : null)
        .whereType<WorkPreference>()
        .toList()
        : [],


    profile: Profile.fromJson(json["profile"]),
    premiumBadge: json["premium_badge"],
    name: json["name"]??"",
    profilePhoto: json["profile_photo"],
    email: json["email"]??"",
    phone: json["phone"],
    preferredWorkLocation: json["preferred_work_location"],
    availableWorkHours: json["available_work_hours"],
    portfolio: json["portfolio"],
    about: json["about"],
    jobTitle: json["job_title"]??"",
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    age: json["age"]?? 0,
    plan: json["plan"]??"",
    profileView: json["profile_view"]??0,
    createdDate: DateTime.parse(json["created_date"]),
    user: json["user"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preferred_job_categories":
    List<dynamic>.from(preferredJobCategories.map((x) => x.toJson())),
    "work_preferences": List<dynamic>.from(workPreferences.map((x) => x.toJson())),
    "profile": profile.toJson(),
    "premium_badge": premiumBadge,
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
    "date_of_birth": dateOfBirth,
    "age": age,
    "plan": plan,
    "profile_view": profileView,
    "created_date": createdDate.toIso8601String(),
    "user": user,
  };
}

class PreferredJobCategory {
  int ? id;
  String preferredJobCategory;
  int ? employee;

  PreferredJobCategory({
     this.id,
    required this.preferredJobCategory,
     this.employee,
  });

  factory PreferredJobCategory.fromJson(Map<String, dynamic> json) =>
      PreferredJobCategory(
        id: json["id"]??0,
        preferredJobCategory: json["preferred_job_category"],
        employee: json["employee"]??0,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preferred_job_category": preferredJobCategory,
    "employee": employee,
  };
}

class WorkPreference {
  int id;
  String interestedJobType;
  String expectedSalaryRange;
  String availability;
  String transportationAvailability;
  int ? employee;

  WorkPreference({
    required this.id,
    required this.interestedJobType,
    required this.expectedSalaryRange,
    required this.availability,
    required this.transportationAvailability,
     this.employee,
  });

  factory WorkPreference.fromJson(Map<String, dynamic> json) => WorkPreference(
    id: json["id"],
    interestedJobType: json["interested_job_type"],
    expectedSalaryRange: json["expected_salary_range"],
    availability: json["availability"],
    transportationAvailability: json["transportation_availability"],
    employee: json["employee"]?? 0,
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

class Profile {
  int id;
  dynamic coverPhoto;
  dynamic profilePic;
  int ? employee;

  Profile({
    required this.id,
    this.coverPhoto,
    this.profilePic,
     this.employee,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    coverPhoto: json["cover_photo"],
    profilePic: json["profile_pic"],
    employee: json["employee"]??0 ,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cover_photo": coverPhoto,
    "profile_pic": profilePic,
    "employee": employee,
  };
}
