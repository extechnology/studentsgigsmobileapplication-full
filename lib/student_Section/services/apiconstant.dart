import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConstants {
  static String baseUrl = 'https://server.studentsgigs.com/';

  static Future<Map<String, String>> get headers async {
    const storage = FlutterSecureStorage();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'access_token')}',
    };
  }
}
//https://server.studentsgigs.com/
