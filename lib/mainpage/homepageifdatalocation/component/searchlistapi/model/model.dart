// To parse this JSON data, do
//
//     final related = relatedFromJson(jsonString);

import 'dart:convert';

List<Related> relatedFromJson(String str) => List<Related>.from(json.decode(str).map((x) => Related.fromJson(x)));

String relatedToJson(List<Related> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Related {
  String ?label;
  String ?value;
  String ?category;
  int? id;
  String? jobTitle;
  int? talentCategory;

  Related({
     this.label,
     this.value,
     this.category,
    this.id,
    this.jobTitle,
    this.talentCategory,
  });

  factory Related.fromJson(Map<String, dynamic> json) => Related(
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
