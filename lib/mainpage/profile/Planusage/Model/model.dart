// To parse this JSON data, do
//
//     final planusage = planusageFromJson(jsonString);

import 'dart:convert';

Planusage planusageFromJson(String str) => Planusage.fromJson(json.decode(str));

String planusageToJson(Planusage data) => json.encode(data.toJson());

class Planusage {
  String ?username;
  String ?name;
  String? email;
  String? plan;
  DateTime planCreatedDate;
  DateTime planExpiryDate;
  bool planExpired;
  List<PlanFeature> planFeatures;

  Planusage({
     this.username,
     this.name,
     this.email,
     this.plan,
    required this.planCreatedDate,
    required this.planExpiryDate,
    required this.planExpired,
    required this.planFeatures,
  });

  factory Planusage.fromJson(Map<String, dynamic> json) => Planusage(
    username: json["username"]??"",
    name: json["name"]??"",
    email: json["email"]??"",
    plan: json["plan"]??"",
    planCreatedDate: DateTime.parse(json["planCreatedDate"]),
    planExpiryDate: DateTime.parse(json["planExpiryDate"]),
    planExpired: json["planExpired"],
    planFeatures: List<PlanFeature>.from(json["planFeatures"].map((x) => PlanFeature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "email": email,
    "plan": plan,
    "planCreatedDate": planCreatedDate.toIso8601String(),
    "planExpiryDate": planExpiryDate.toIso8601String(),
    "planExpired": planExpired,
    "planFeatures": List<dynamic>.from(planFeatures.map((x) => x.toJson())),
  };
}

class PlanFeature {
  String ?limit;
  String? name;
  int used;

  PlanFeature({
     this.limit,
     this.name,
    required this.used,
  });

  factory PlanFeature.fromJson(Map<String, dynamic> json) => PlanFeature(
    limit: json["limit"]??"",
    name: json["name"]??"",
    used: json["used"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "name": name,
    "used": used,
  };
}
