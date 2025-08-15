import 'package:anjalim/student_Section/models_std/employee_Profile/language_model.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguageRepository {
  final _storage = FlutterSecureStorage();

  Future<List<LanguageSkill>> fetchLanguageSkills() async {
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}api/employee/employee-languages/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((json) => LanguageSkill.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load language skills');
    }
  }

  Future<void> deleteLanguage(int id) async {
    final token = await _storage.read(key: 'access_token');
    final url =
        '${ApiConstants.baseUrl}api/employee/employee-languages/?pk=$id';

    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete language');
    }
  }

  Future<void> addLanguage(String language, String level) async {
    final token = await _storage.read(key: 'access_token');
    final url =
        Uri.parse('${ApiConstants.baseUrl}api/employee/employee-languages/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'language': language,
        'language_level': level,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorResponse = jsonDecode(response.body);
      String errorMessage = 'Failed to add language';

      if (errorResponse is List && errorResponse.isNotEmpty) {
        errorMessage = errorResponse[0];
      } else if (errorResponse is Map && errorResponse.containsKey('detail')) {
        errorMessage = errorResponse['detail'];
      } else if (errorResponse is Map) {
        errorMessage = errorResponse.entries
            .map((e) =>
                '${e.key}: ${e.value is List ? e.value.join(', ') : e.value}')
            .join('\n');
      }
      throw Exception(errorMessage);
    }
  }
}
