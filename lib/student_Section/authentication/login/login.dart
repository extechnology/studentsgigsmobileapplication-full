// login_repository.dart
import 'dart:convert';
import 'package:anjalim/mainpage/datapage/datapage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _userType = 'student'; // Fixed user type for students

  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    // Student login endpoint
    final Uri url = Uri.parse("${ApiConstants.baseUrl}api/employee/api/token/");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String accessToken = data['access'];
        final String refreshToken = data['refresh'];

        // Decode JWT (split and decode payload)
        final parts = accessToken.split('.');
        if (parts.length != 3) {
          throw Exception('Invalid token');
        }

        final payload = jsonDecode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
        final int userId = payload['user_id'];

        // Store tokens and user data securely
        await _secureStorage.write(key: "access_token", value: accessToken);
        await _secureStorage.write(key: "refresh_token", value: refreshToken);
        await _secureStorage.write(key: "user_type", value: _userType);
        await _secureStorage.write(key: "user_id", value: userId.toString());

        // Fetch employee details
        //await fetchEmployeeDetails();

        return {
          'success': true,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'userId': userId,
          'username': username,
        };
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['detail'] ?? 'Login failed. Please try again.';

        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': "Network error: Could not connect to server.",
      };
    }
  }
}
