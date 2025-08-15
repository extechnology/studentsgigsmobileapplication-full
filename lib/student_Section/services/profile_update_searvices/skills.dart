import 'package:anjalim/student_Section/models_std/employee_Profile/skill/technicalSkills.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SkillsService {
  final baseurl = "${ApiConstants.baseUrl}";

  Future<List<TechnicalSkills>> fetchSkills(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${baseurl}api/employee/employee-technical-skills/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((skill) => TechnicalSkills.fromJson(skill)).toList();
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = _parseErrorMessage(errorResponse);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching skills: ${e.toString()}')),
      );
      throw Exception('Error fetching skills: ${e.toString()}');
    }
  }

  Future<void> postSkills(
      String skill, String skillLevel, BuildContext context) async {
    try {
      final url =
          Uri.parse('${baseurl}api/employee/employee-technical-skills/');

      final response = await http.post(
        url,
        headers: await ApiConstants.headers,
        body: jsonEncode({
          'technical_skill': skill,
          'technical_level': skillLevel,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Skill added successfully!')),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = _parseErrorMessage(errorResponse);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding skill: ${e.toString()}')),
      );
    }
  }

  Future<void> deleteSkill(int id, BuildContext context) async {
    try {
      final url = '${baseurl}api/employee/employee-technical-skills/?pk=$id';

      final response = await http.delete(Uri.parse(url),
          headers: await ApiConstants.headers);

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Skill deleted successfully!')),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = _parseErrorMessage(errorResponse);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting skill: ${e.toString()}')),
      );
    }
  }

  String _parseErrorMessage(dynamic errorResponse) {
    if (errorResponse is List && errorResponse.isNotEmpty) {
      return errorResponse[0]; // Gets the first error message
    } else if (errorResponse is Map && errorResponse.containsKey('detail')) {
      return errorResponse['detail'];
    } else if (errorResponse is Map && errorResponse.containsKey('message')) {
      return errorResponse['message'];
    } else if (errorResponse is String) {
      return errorResponse;
    }
    return 'An unknown error occurred';
  }
}
