import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpAuthRepository {
  final String baseUrl = 'https://server.studentsgigs.com';

  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}api/employee/send-sms-otp/'),
        body: {
          'mobile': mobile,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to send OTP. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}api/employee/verify-sms-otp/'),
        body: {
          'mobile': mobile,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("response:$data");
        if (data['access'] != null) {
          await _secureStorage.write(
              key: 'access_token', value: data['access']);
        }
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Invalid OTP. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }
}
