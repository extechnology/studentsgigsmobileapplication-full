// To parse this JSON data, do
//
//     final homepagecategory = homepagecategoryFromJson(jsonString);

import 'dart:convert';

List<Homepagecategory> homepagecategoryFromJson(String str) => List<Homepagecategory>.from(json.decode(str).map((x) => Homepagecategory.fromJson(x)));

String homepagecategoryToJson(List<Homepagecategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Homepagecategory {
  String? label;
  String ?value;
  String ?category;
  int? id;
  String? jobTitle;
  int? talentCategory;

  Homepagecategory({
     this.label,
     this.value,
     this.category,
    this.id,
    this.jobTitle,
    this.talentCategory,
  });

  factory Homepagecategory.fromJson(Map<String, dynamic> json) => Homepagecategory(
    label: json["label"]?? "",
    value: json["value"]?? "",
    category: json["category"]?? "",
    id: json["id"],
    jobTitle: json["job_title"]?? "",
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
