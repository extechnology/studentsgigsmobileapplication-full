// To parse this JSON data, do
//
//     final popularjob = popularjobFromJson(jsonString);

import 'dart:convert';

List<Popularjob> popularjobFromJson(String str) => List<Popularjob>.from(json.decode(str).map((x) => Popularjob.fromJson(x)));

String popularjobToJson(List<Popularjob> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Popularjob {
  String label;
  String value;
  String category;
  int? id;
  String? jobTitle;
  int? talentCategory;

  Popularjob({
    required this.label,
    required this.value,
    required this.category,
    this.id,
    this.jobTitle,
    this.talentCategory,
  });

  factory Popularjob.fromJson(Map<String, dynamic> json) => Popularjob(
    label: json["label"],
    value: json["value"],
    category: json["category"],
    id: json["id"],
    jobTitle: json["job_title"],
    talentCategory: json["talent_category"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "category": category,
    "id": id,
    "job_title": jobTitle,
    "talent_category": talentCategory,
  };
}
