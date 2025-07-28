// To parse this JSON data, do
//
//     final premiumPageModel = premiumPageModelFromJson(jsonString);

import 'dart:convert';

List<PremiumPageModel> premiumPageModelFromJson(String str) => List<PremiumPageModel>.from(json.decode(str).map((x) => PremiumPageModel.fromJson(x)));

String premiumPageModelToJson(List<PremiumPageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PremiumPageModel {
  int planId;
  String ?id;
  String ?name;
  String ?price;
  List<Feature> features;
  String ?color;
  bool recommended;
  String ?profileAccess;
  String ?validity;
  String? jobPosting;
  String ?resumeViewing;
  String ?jobAutoRefreshing;
  String? hotJobLabel;
  String ?accessToCertifiedStudents;
  String ?instantCandidateMatching;
  String ?directChatWithCandidate;
  String ?companyDashboardAnalytics;

  PremiumPageModel({
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

  factory PremiumPageModel.fromJson(Map<String, dynamic> json) => PremiumPageModel(
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
    jobAutoRefreshing: json["job_auto-refreshing"],
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
  String ?value;

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
