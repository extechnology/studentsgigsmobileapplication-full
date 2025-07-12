// To parse this JSON data, do
//
//     final getcompanyinfo = getcompanyinfoFromJson(jsonString);

import 'dart:convert';

Getcompanyinfo getcompanyinfoFromJson(String str) => Getcompanyinfo.fromJson(json.decode(str));

String getcompanyinfoToJson(Getcompanyinfo data) => json.encode(data.toJson());

class Getcompanyinfo {
  bool isExist;
  Employer employer;

  Getcompanyinfo({
    required this.isExist,
    required this.employer,
  });

  factory Getcompanyinfo.fromJson(Map<String, dynamic> json) => Getcompanyinfo(
    isExist: json["is_exist"],
    employer: Employer.fromJson(json["employer"]),
  );

  Map<String, dynamic> toJson() => {
    "is_exist": isExist,
    "employer": employer.toJson(),
  };
}

class Employer {
  int id;
  String? username;
  String ?companyName;
  String? companyInfo;
  String ?logo;
  String ?email;
  String ?phoneNumber;
  String? streetAddress;
  String ?city;
  String? state;
  String ?postalCode;
  Country? country;
  String ?plan;
  DateTime ?createdAt;
  int user;

  Employer({
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

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    id: json["id"],
    username: json["username"] ?? "",
    companyName: json["company_name"]?? "",
    companyInfo: json["company_info"]?? "",
    logo: json["logo"]?? "",
    email: json["email"]?? "",
    phoneNumber: json["phone_number"]?? "",
    streetAddress: json["street_address"]?? "",
    city: json["city"]?? "",
    state: json["state"]?? "",
    postalCode: json["postal_code"]?? "",
    country: Country.fromJson(json["country"]),
    plan: json["plan"],
    createdAt: DateTime.parse(json["created_at"]?? ""),
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
  final String value;
  late final String label;
  final String flag;

  Country({
    required this.value,
    required this.label,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    value: json["value"] ?? "",
    label: json["label"] ?? "",
    flag: json["flag"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "flag": flag,
  };
}
