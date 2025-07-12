// To parse this JSON data, do
//
//     final getthetextsuggestion = getthetextsuggestionFromJson(jsonString);

import 'dart:convert';

List<Getthetextsuggestion> getthetextsuggestionFromJson(String str) => List<Getthetextsuggestion>.from(json.decode(str).map((x) => Getthetextsuggestion.fromJson(x)));

String getthetextsuggestionToJson(List<Getthetextsuggestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getthetextsuggestion {
  int id;
  String category;
  String jobTitle;
  int talentCategory;
  String value;
  String label;

  Getthetextsuggestion({
    required this.id,
    required this.category,
    required this.jobTitle,
    required this.talentCategory,
    required this.value,
    required this.label,
  });

  factory Getthetextsuggestion.fromJson(Map<String, dynamic> json) => Getthetextsuggestion(
    id: json["id"],
    category: json["category"],
    jobTitle: json["job_title"],
    talentCategory: json["talent_category"],
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "job_title": jobTitle,
    "talent_category": talentCategory,
    "value": value,
    "label": label,
  };
}
