import 'package:anjalim/student_Section/models_std/employee_Profile/skill/skillsoft.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SoftSkillsService {
  Future<List<SoftSkills>> fetchSoftSkills(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}api/employee/employee-soft-skills/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No soft skills found')),
          );
          return [];
        }
        return data.map((skill) => SoftSkills.fromJson(skill)).toList();
      } else {
        final errorMessage = _parseErrorResponse(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load soft skills: ${e.toString()}')),
      );
      throw Exception('Failed to load soft skills: ${e.toString()}');
    }
  }

  Future<void> postSoftSkills(String softskill, BuildContext context) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}api/employee/employee-soft-skills/');

      final response = await http.post(
        url,
        headers: await ApiConstants.headers,
        body: jsonEncode({'soft_skill': softskill}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Soft skill added successfully!')),
        );
      } else {
        final errorMessage = _parseErrorResponse(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding soft skill: ${e.toString()}')),
      );
    }
  }

  Future<void> deleteSoftSkill(int id, BuildContext context) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}api/employee/employee-soft-skills/?pk=$id');

      final response =
          await http.delete(url, headers: await ApiConstants.headers);

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Soft skill deleted successfully!')),
        );
      } else {
        final errorMessage = _parseErrorResponse(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting soft skill: ${e.toString()}')),
      );
    }
  }

  String _parseErrorResponse(String responseBody) {
    try {
      final dynamic parsed = jsonDecode(responseBody);

      if (parsed is List && parsed.isNotEmpty) {
        return parsed[0].toString(); // Return first error if it's a list
      } else if (parsed is Map) {
        return parsed['detail'] ??
            parsed['message'] ??
            parsed['error'] ??
            'An error occurred';
      }
      return responseBody; // Return raw response if format is unexpected
    } catch (e) {
      return responseBody; // Return raw response if parsing fails
    }
  }
}
