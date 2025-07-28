import 'dart:convert';

// Parse from JSON string
Getcompanyinfo getcompanyinfoFromJson(String str) =>
    Getcompanyinfo.fromJson(json.decode(str));

// Convert back to JSON string
String getcompanyinfoToJson(Getcompanyinfo data) =>
    json.encode(data.toJson());

class Getcompanyinfo {
  final bool isExist;
  final Employer employer;

  Getcompanyinfo({
    required this.isExist,
    required this.employer,
  });

  factory Getcompanyinfo.fromJson(Map<String, dynamic> json) => Getcompanyinfo(
    isExist: json["is_exist"] ?? false,
    employer: json["employer"] != null
        ? Employer.fromJson(json["employer"])
        : Employer.empty(),
  );

  Map<String, dynamic> toJson() => {
    "is_exist": isExist,
    "employer": employer.toJson(),
  };
}

class Employer {
  final String ? id;
  final String ?username;
  final String ?companyName;
  final String ?companyInfo;
  final String ?logo;
  final String ?email;
  final String? phoneNumber;
  final String ?streetAddress;
  final String ?city;
  final String ?state;
  final String ?postalCode;
  final Country ?country;
  final String ?plan;
  final String ?createdAt;
  User? user; // ✅ correct

  Employer({
     this.id,
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
     this.user,
  });

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    id: json["id"]?.toString() ?? "0",
    username: json["username"]?.toString() ?? "Unknown User",
    companyName: json["company_name"]?.toString() ,
    companyInfo: json["company_info"]?.toString() ?? "No info provided",
    logo: json["logo"]?.toString() ,
    email: json["email"]?.toString() ?? "no@email.com",
    phoneNumber: json["phone_number"]?.toString() ?? "0000000000",
    streetAddress: json["street_address"]?.toString() ?? "Unknown street",
    city: json["city"]?.toString() ?? "Unknown city",
    state: json["state"]?.toString() ?? "Unknown state",
    postalCode: json["postal_code"]?.toString() ?? "000000",
    country: json["country"] != null
        ? Country.fromJson(json["country"])
        : Country(value: "IN", label: "India", flag: "🇮🇳"),
    plan: json["plan"]?.toString() ?? "Free",
    createdAt: json["created_at"]?.toString() ?? DateTime.now().toIso8601String(),
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
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
    "created_at": createdAt,
    "user": user,
  };

  factory Employer.empty() => Employer(
    id: "0",
    username: "Unknown User",
    companyName: "Unnamed Company",
    companyInfo: "No info provided",
    logo: "",
    email: "no@email.com",
    phoneNumber: "0000000000",
    streetAddress: "Unknown street",
    city: "Unknown city",
    state: "Unknown state",
    postalCode: "000000",
    country: Country(value: "IN", label: "India", flag: "🇮🇳"),
    plan: "Free",
    createdAt: DateTime.now().toIso8601String(),
    user: User(email: "no@email.com", username: "Unknown User"),
  );
}

class Country {
  final String value;
  final String label;
  final String flag;

  Country({
    required this.value,
    required this.label,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    value: json["value"]?.toString() ?? "IN",
    label: json["label"]?.toString() ?? "India",
    flag: json["flag"]?.toString() ?? "🇮🇳",
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "flag": flag,
  };
}
class User {
  String? email;
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
