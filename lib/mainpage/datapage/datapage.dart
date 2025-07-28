import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConstants {
  static String baseUrl = 'https://server.studentsgigs.com';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static Future<String?> getTokenOnly() async {
    return await _storage.read(key: 'access_token');

  }
  static Future<String?> getTokenOnly2() async {
    return await _storage.read(key: 'token_local');

  }

  static Future<Map<String, String>> get headers async {
    final tokens = await _storage.read(key: 'token_local');

    final token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? tokens ?? ""}', // fallback empty if null
    };
  }
}
