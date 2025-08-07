import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> resetPassword(String email, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}api/employee/reset-password/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      // Success - you can customize this
      Navigator.pop(context); // Close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!")),
      );
    } else {
      // Failure - handle specific errors if needed
    }
  } catch (e) {}
}
