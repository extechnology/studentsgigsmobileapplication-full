import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static String _baseUrl = '${ApiConstants.baseUrl}api/employee/';

  Future<List<dynamic>> fetchnotification() async {
    const String endpoint = 'notification/';
    final String apiUrl = '$_baseUrl$endpoint';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        print("Notification---${response.body}");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notification data: ${e.toString()}');
    }
  }
}
