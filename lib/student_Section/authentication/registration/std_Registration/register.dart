import 'dart:convert';
import 'package:anjalim/mainpage/datapage/datapage.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

class RegisterRepository {
  static const String _userType = 'student'; // Fixed user type for students

  Future<Map<String, dynamic>> sendOTP({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}api/employee/user/register/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
          "password_confirm": confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return {"success": true};
      } else {
        final data = jsonDecode(response.body);
        String message = "Something went wrong";

        // Handle different error types and show exact backend messages
        if (data is Map<String, dynamic>) {
          if (data.containsKey("email")) {
            // Handle email validation errors
            if (data["email"] is List && data["email"].isNotEmpty) {
              message = data["email"][0]; // Show exact backend message
            } else {
              message = "Email is already registered or invalid.";
            }
          } else if (data.containsKey("password")) {
            // Handle password validation errors
            if (data["password"] is List && data["password"].isNotEmpty) {
              message = data["password"][0]; // Show exact backend message
            } else {
              message = "Password is too weak or invalid.";
            }
          } else if (data.containsKey("username")) {
            // Handle username validation errors
            if (data["username"] is List && data["username"].isNotEmpty) {
              message = data["username"][0]; // Show exact backend message
            } else {
              message = "Username already exists or is invalid.";
            }
          } else if (data.containsKey("password_confirm")) {
            // Handle password confirmation errors
            if (data["password_confirm"] is List &&
                data["password_confirm"].isNotEmpty) {
              message =
                  data["password_confirm"][0]; // Show exact backend message
            } else {
              message = "Password confirmation error.";
            }
          } else if (data.containsKey("message")) {
            // Handle general message from backend
            message = data["message"];
          } else {
            // Generic fallback - get first error message
            var firstKey = data.keys.first;
            if (data[firstKey] is List && data[firstKey].isNotEmpty) {
              message = data[firstKey][0];
            } else {
              message = data[firstKey].toString();
            }
          }
        }

        return {"success": false, "message": message};
      }
    } catch (e) {
      return {"success": false, "message": "Failed to connect to the server."};
    }
  }

  Future<bool> verifyOTP({
    required String email,
    required String otp,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("${ApiConstants.baseUrl}api/employee/verify-otp/"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": email,
              "otp": otp,
              "username": username,
              "password": password,
            }),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 201) {
        // Parse the response body to check for actual success/error
        final data = jsonDecode(response.body);

        // Check for error fields first
        if (data.containsKey('non_field_errors') ||
            data.containsKey('error') ||
            data.containsKey('errors')) {
          return false;
        }

        // Check for success indicators
        if (data.containsKey('success')) {
          return data['success'] == true;
        }

        // Check for success message
        if (data.containsKey('message')) {
          String message = data['message'].toString().toLowerCase();
          bool isSuccess = message.contains('verified') ||
              message.contains('created') ||
              message.contains('success');
          return isSuccess;
        }

        // If no clear indicators, assume success since status is 200
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> resendOTP({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}api/employee/resend-otp/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "OTP resent successfully",
        };
      } else {
        return {
          "success": false,
          "message": "Failed to resend OTP",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Failed to connect to the server.",
      };
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Student registration endpoint (removed userType condition)
      final Uri registerUrl =
          Uri.parse("${ApiConstants.baseUrl}api/employee/user/register/");

      final response = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
          "password_confirm": confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": "Registration successful",
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Network error: Could not connect to server.",
      };
    }
  }
}
