// To parse this JSON data, do
//
//     final statuspremium = statuspremiumFromJson(jsonString);

import 'dart:convert';

Statuspremium statuspremiumFromJson(String str) => Statuspremium.fromJson(json.decode(str));

String statuspremiumToJson(Statuspremium data) => json.encode(data.toJson());

class Statuspremium {
  Plan plan;
  String ?currentPlan;
  Usage usage;
  bool isOffer;

  Statuspremium({
    required this.plan,
     this.currentPlan,
    required this.usage,
    required this.isOffer,
  });

  factory Statuspremium.fromJson(Map<String, dynamic> json) => Statuspremium(
    plan: Plan.fromJson(json["plan"]),
    currentPlan: json["current_plan"],
    usage: Usage.fromJson(json["usage"]),
    isOffer: json["is_offer"],
  );

  Map<String, dynamic> toJson() => {
    "plan": plan.toJson(),
    "current_plan": currentPlan,
    "usage": usage.toJson(),
    "is_offer": isOffer,
  };
}

class Plan {
  int planId;
  String ?id;
  String ?name;
  String ?price;
  List<Feature> features;
  String ?color;
  bool recommended;
  String ?profileAccess;
  String ?validity;
  String ?jobPosting;
  String ?resumeViewing;
  String ?jobAutoRefreshing;
  String ?hotJobLabel;
  String ?accessToCertifiedStudents;
  String ?instantCandidateMatching;
  String ?directChatWithCandidate;
  String ?companyDashboardAnalytics;

  Plan({
    required this.planId,
     this.id,
     this.name,
     this.price,
    required this.features,
     this.color,
    required this.recommended,
     this.profileAccess,
     this.validity,
     this.jobPosting,
     this.resumeViewing,
     this.jobAutoRefreshing,
     this.hotJobLabel,
     this.accessToCertifiedStudents,
     this.instantCandidateMatching,
     this.directChatWithCandidate,
     this.companyDashboardAnalytics,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    planId: json["plan_id"],
    id: json["id"]??"",
    name: json["name"]??"",
    price: json["price"]??"",
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    color: json["color"]??"",
    recommended: json["recommended"],
    profileAccess: json["profile_access"]??"",
    validity: json["validity"]??"",
    jobPosting: json["job_posting"]??"",
    resumeViewing: json["resume_viewing"]??"",
    jobAutoRefreshing: json["job_auto-refreshing"]??"",
    hotJobLabel: json["hot_job_label"]??"",
    accessToCertifiedStudents: json["access_to_certified_students"]??"",
    instantCandidateMatching: json["instant_candidate_matching"]??"",
    directChatWithCandidate: json["direct_chat_with_candidate"]??"",
    companyDashboardAnalytics: json["company_dashboard_analytics"]??"",
  );

  Map<String, dynamic> toJson() => {
    "plan_id": planId,
    "id": id,
    "name": name,
    "price": price,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "color": color,
    "recommended": recommended,
    "profile_access": profileAccess,
    "validity": validity,
    "job_posting": jobPosting,
    "resume_viewing": resumeViewing,
    "job_auto-refreshing": jobAutoRefreshing,
    "hot_job_label": hotJobLabel,
    "access_to_certified_students": accessToCertifiedStudents,
    "instant_candidate_matching": instantCandidateMatching,
    "direct_chat_with_candidate": directChatWithCandidate,
    "company_dashboard_analytics": companyDashboardAnalytics,
  };
}

class Feature {
  String ?name;
  String? value;

  Feature({
     this.name,
     this.value,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    name: json["name"]??"",
    value: json["value"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}

class Usage {
  DateTime createdDate;
  DateTime expiryDate;
  bool canPostJob;
  bool profileAccess;
  bool isExpired;

  Usage({
    required this.createdDate,
    required this.expiryDate,
    required this.canPostJob,
    required this.profileAccess,
    required this.isExpired,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
    createdDate: DateTime.parse(json["created_date"]),
    expiryDate: DateTime.parse(json["expiry_date"]),
    canPostJob: json["can_post_job"],
    profileAccess: json["profile_access"],
    isExpired: json["is_expired"],
  );

  Map<String, dynamic> toJson() => {
    "created_date": createdDate.toIso8601String(),
    "expiry_date": expiryDate.toIso8601String(),
    "can_post_job": canPostJob,
    "profile_access": profileAccess,
    "is_expired": isExpired,
  };
}
