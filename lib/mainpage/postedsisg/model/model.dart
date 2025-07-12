// To parse this JSON data, do
//
//     final getjobpostdata = getjobpostdataFromJson(jsonString);

import 'dart:convert';

Getjobpostdata getjobpostdataFromJson(String str) => Getjobpostdata.fromJson(json.decode(str));

String getjobpostdataToJson(Getjobpostdata data) => json.encode(data.toJson());

class Getjobpostdata {
  List<Job> jobs;

  Getjobpostdata({
    required this.jobs,
  });

  factory Getjobpostdata.fromJson(Map<String, dynamic> json) => Getjobpostdata(
    jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
  };
}

class Job {
  int id;
  Company company;
  bool applied;
  int totalApplied;
  bool savedJob;
  String? jobTitle;
  String? jobDescription;
  String ?category;
  int ?ageRequirementMin;
  int ?ageRequirementMax;
  String ?preferredAcademicCourses;
  String ?payStructure;
  String ?salaryType;
  String ?jobLocation;
  DateTime? postedDate;
  String ?jobType;

  Job({
    required this.id,
    required this.company,
    required this.applied,
    required this.totalApplied,
    required this.savedJob,
    this.jobTitle,
    this.jobDescription,
    this.category,
    this.ageRequirementMin,
    this.ageRequirementMax,
    this.preferredAcademicCourses,
    this.payStructure,
    this.salaryType,
    this.jobLocation,
    this.postedDate,
    this.jobType,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    company: Company.fromJson(json["company"]),
    applied: json["applied"],
    totalApplied: json["total_applied"],
    savedJob: json["saved_job"],
    jobTitle: json["job_title"],
    jobDescription: json["job_description"],
    category: json["category"],
    ageRequirementMin: json["age_requirement_min"],
    ageRequirementMax: json["age_requirement_max"],
    preferredAcademicCourses: json["preferred_academic_courses"],
    payStructure: json["pay_structure"],
    salaryType: json["salary_type"],
    jobLocation: json["job_location"],
    postedDate: DateTime.parse(json["posted_date"]),
    jobType: json["job_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company": company?.toJson(),
    "applied": applied,
    "total_applied": totalApplied,
    "saved_job": savedJob,
    "job_title": jobTitle,
    "job_description": jobDescription,
    "category": category,
    "age_requirement_min": ageRequirementMin,
    "age_requirement_max": ageRequirementMax,
    "preferred_academic_courses": preferredAcademicCourses,
    "pay_structure": payStructure,
    "salary_type": salaryType,
    "job_location": jobLocation,
    "posted_date": postedDate?.toIso8601String(),
    "job_type": jobType,
  };
}

class Company {
  int id;
  String ?username;
  String ?companyName;
  String ?companyInfo;
  String ?logo;
  String ?email;
  String ?phoneNumber;
  String ?streetAddress;
  String ?city;
  String ?state;
  String ?postalCode;
  Country ?country;
  String? plan;
  DateTime ?createdAt;
  int user;

  Company({
    required this.id,
    this.username,
    this.companyName,
    this.companyInfo,
    this.logo,
    this.email,
    this.phoneNumber,
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.plan,
    this.createdAt,
    required this.user,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    username: json["username"]?? "",
    companyName: json["company_name"]?? "",
    companyInfo: json["company_info"]?? "",
    logo: json["logo"]?? "",
    email: json["email"]?? "",
    phoneNumber: json["phone_number"]?? "",
    streetAddress: json["street_address"]?? "",
    city: json["city"]?? "",
    state: json["state"]?? "",
    postalCode: json["postal_code"],
    country: Country.fromJson(json["country"]),
    plan: json["plan"],
    createdAt: DateTime.parse(json["created_at"]),
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "company_name": companyName,
    "company_info": companyInfo,
    "logo": logo,
    "email": email,
    "phone_number": phoneNumber,
    "street_address": streetAddress,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country?.toJson(),
    "plan": plan,
    "created_at": createdAt?.toIso8601String(),
    "user": user,
  };
}

class Country {
  String ?value;
  String ?label;
  String ?flag;

  Country({
    this.value,
    this.label,
    this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    value: json["value"],
    label: json["label"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "flag": flag,
  };
}
