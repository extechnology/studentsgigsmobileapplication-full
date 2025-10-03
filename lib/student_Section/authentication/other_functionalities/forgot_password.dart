import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  final String baseUrl = 'https://server.studentsgigs.com';

  Future<Map<String, dynamic>> sendPasswordResetOtp(String identifier) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/employee/password-reset-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent to your email',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> verifyPasswordResetOtp(
      String identifier, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/employee/verify-password-reset-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'otp': otp,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP verified successfully',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Invalid OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String identifier, String password, String confirmPassword) async {
    // print("----$identifier----");
    // print("----$password----");
    // print("----$confirmPassword----");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/employee/password-change-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password reset successfully',
        };
      } else {
        // print("Error to reset----${response.body}");
        return {
          'success': false,
          'error':
              data['error'] ?? data['message'] ?? 'Failed to reset password',
        };
      }
    } catch (e) {
      // print("Error to reset----$e");
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }
}

Future<void> passwordResetWithLogin(
    String password, String confirmPassword, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}api/employee/password-reset/"),
      headers: await ApiConstants.headers,
      body: jsonEncode(
          {"password": password, "confirm_password": confirmPassword}),
    );

    if (response.statusCode == 200) {
      // print("Password reset success: ${response.statusCode}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // print("Error in Reset: ${response.body}");
      // print("Password reset failed: ${response.statusCode}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset failed: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // print("Exception in password reset: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password reset failed: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
