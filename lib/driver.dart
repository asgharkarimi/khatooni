import 'dart:convert';
import 'package:http/http.dart' as http;

class Driver {
  final int id;
  final String name;
  final String familyName;

  Driver({required this.id, required this.name, required this.familyName});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      familyName: json['family_name'],
    );
  }

  static List<Driver> fromJsonList(String jsonString) {
    final decoded = json.decode(jsonString);
    return (decoded['data'] as List).map((driver) => Driver.fromJson(driver)).toList();
  }
}
