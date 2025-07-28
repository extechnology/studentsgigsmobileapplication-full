// To parse this JSON data, do
//     final countrylocation = countrylocationFromJson(jsonString);

import 'dart:convert';

Countrylocation countrylocationFromJson(String str) => Countrylocation.fromJson(json.decode(str));

String countrylocationToJson(Countrylocation data) => json.encode(data.toJson());

class Countrylocation {
  String ? type;
  List<Feature> features;

  Countrylocation({
     this.type,
    required this.features,
  });

  factory Countrylocation.fromJson(Map<String, dynamic> json) => Countrylocation(
    type: json["type"],
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class Feature {
  FeatureType type;
  Properties properties;
  Geometry geometry;

  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: featureTypeValues.map[json["type"]] ?? FeatureType.FEATURE,
    properties: Properties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
  );

  Map<String, dynamic> toJson() => {
    "type": featureTypeValues.reverse[type],
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
  };
}

class Geometry {
  GeometryType type;
  List<double> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: geometryTypeValues.map[json["type"]] ?? GeometryType.POINT,
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": geometryTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum GeometryType { POINT }
final geometryTypeValues = EnumValues({ "Point": GeometryType.POINT });

enum FeatureType { FEATURE }
final featureTypeValues = EnumValues({ "Feature": FeatureType.FEATURE });

class Properties {
  String ? osmType;
  int osmId;
  String ?osmKey;
  String ?osmValue;
  String? type;
  String? countrycode;
  String ?name;
  String? country;
  String ?state;
  String? county;
  List<double>? extent;
  String? city;
  String? postcode;
  String? district;
  String? locality;
  String? street;

  Properties({
     this.osmType,
    required this.osmId,
     this.osmKey,
     this.osmValue,
     this.type,
     this.countrycode,
     this.name,
     this.country,
     this.state,
    this.county,
    this.extent,
    this.city,
    this.postcode,
    this.district,
    this.locality,
    this.street,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    osmType: json["osm_type"] ?? '',
    osmId: json["osm_id"] ?? 0,
    osmKey: json["osm_key"] ?? '',
    osmValue: json["osm_value"] ?? '',
    type: json["type"] ?? '',
    countrycode: json["countrycode"] ?? '',
    name: json["name"] ?? '',
    country: json["country"] ?? '',
    state: json["state"] ?? '',
    county: json["county"],
    extent: json["extent"] == null ? [] : List<double>.from(json["extent"].map((x) => x?.toDouble())),
    city: json["city"],
    postcode: json["postcode"],
    district: json["district"],
    locality: json["locality"],
    street: json["street"],
  );

  Map<String, dynamic> toJson() => {
    "osm_type": osmType,
    "osm_id": osmId,
    "osm_key": osmKey,
    "osm_value": osmValue,
    "type": type,
    "countrycode": countrycode,
    "name": name,
    "country": country,
    "state": state,
    "county": county,
    "extent": extent == null ? [] : List<dynamic>.from(extent!.map((x) => x)),
    "city": city,
    "postcode": postcode,
    "district": district,
    "locality": locality,
    "street": street,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
