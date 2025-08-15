import 'dart:async';
import 'dart:convert';
import 'package:anjalim/student_Section/models_std/employeeprofile.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> updateEmployee(
  BuildContext context,
  String about,
  String username,
  String email,
  String phoneNumber,
  String location,
  String portfolio,
  String jobTitle,
  int age,
  String workHours,
  String gender,
  String dob,
) async {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'access_token');
  final id = await _storage.read(key: 'employee_id');

  if (token == null || id == null) {
    throw Exception('Authentication token or user ID not found');
  }

  try {
    final updatedEmployee = StudentEmployee(
      about: about,
      name: username,
      email: email,
      phone: phoneNumber,
      preferredWorkLocation: location,
      availableWorkHours: workHours,
      portfolio: portfolio,
      jobTitle: jobTitle,
      age: age,
      gender: gender,
      dateOfBirth: dob,
    );

    final response = await http
        .put(
          Uri.parse("${ApiConstants.baseUrl}api/employee/employees/?pk=$id"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(updatedEmployee.toJson()),
        )
        .timeout(Duration(seconds: 30));

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Failed to update profile');
    }

    // Return the updated employee data if needed
    return jsonDecode(response.body);
  } on http.ClientException {
    throw Exception('Network error: Please check your internet connection');
  } on TimeoutException {
    throw Exception('Request timed out. Please try again');
  } catch (e) {
    throw Exception('Failed to update profile: ${e.toString()}');
  }
}
