// To parse this JSON data, do
//
//     final compantonboarding = compantonboardingFromJson(jsonString);

import 'dart:convert';

Compantonboarding compantonboardingFromJson(String str) => Compantonboarding.fromJson(json.decode(str));

String compantonboardingToJson(Compantonboarding data) => json.encode(data.toJson());
//ahfvjdvf
class Compantonboarding {
  bool ?isExist;
  Employer ?employer;

  Compantonboarding({
    this.isExist,
    this.employer,
  });

  factory Compantonboarding.fromJson(Map<String, dynamic> json) => Compantonboarding(
    isExist: json["is_exist"],
    employer: json["employer"] != null ? Employer.fromJson(json["employer"]) : null,
  );


  Map<String, dynamic> toJson() => {
    "is_exist": isExist,
    "employer": employer?.toJson(),
  };
}

class Employer {
  int id;
  String ?username;
  User ?user;
  dynamic companyName;
  dynamic companyInfo;
  dynamic logo;
  dynamic email;
  dynamic phoneNumber;
  dynamic streetAddress;
  dynamic city;
  dynamic state;
  dynamic postalCode;
  dynamic country;
  String plan;
  DateTime createdAt;

  Employer({
     required this.id,
    this.username,
    this.user,
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
    required this.plan,
    required this.createdAt,
  });

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    id: json["id"],
    username: json["username"],
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    companyName: json["company_name"],
    companyInfo: json["company_info"],
    logo: json["logo"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    streetAddress: json["street_address"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    country: json["country"] != null ? Country.fromJson(json["country"]) : null,
    plan: json["plan"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "user": user?.toJson(),
    "company_name": companyName,
    "company_info": companyInfo,
    "logo": logo,
    "email": email,
    "phone_number": phoneNumber,
    "street_address": streetAddress,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country.toJson(),
    "plan": plan,
    "created_at": createdAt.toIso8601String(),
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

class User {
  String ?email;
  String? username;

  User({
    this.email,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": username,
  };
}
