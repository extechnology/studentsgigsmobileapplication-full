import 'dart:convert';
import 'package:anjalim/student_Section/models_std/employee_Profile/additional_info.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<AdditionalInformations> fetchAdditionalInfo() async {
  final _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'access_token');

  try {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}api/employee/employee-additional-information/'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Handle empty array response
      if (responseData is List) {
        if (responseData.isEmpty) {
          return AdditionalInformations.empty();
        }
        // If API returns array, take first item
        return AdditionalInformations.fromJson(responseData[0]);
      }
      // Handle object response
      return AdditionalInformations.fromJson(responseData);
    }

    // Return empty object for any non-200 status
    return AdditionalInformations.empty();
  } catch (e) {
    return AdditionalInformations.empty();
  }
}

// For saving
Future<void> postAdditionalInfo({
  required int id,
  FilePickerResult? resume,
  List<String>? hobbies,
  String? relocate,
  String? reference,
}) async {
  try {
    final token = await FlutterSecureStorage().read(key: 'access_token');
    if (token == null) throw Exception('No authentication token found');

    final url = Uri.parse(
        '${ApiConstants.baseUrl}api/employee/employee-additional-information/$id/');
    var request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = 'Bearer $token';

    // Add PDF resume if provided
    if (resume?.files.isNotEmpty == true && resume!.files.first.path != null) {
      final file = resume.files.first;
      request.files.add(await http.MultipartFile.fromPath(
        'resume',
        file.path!,
        filename: file.name,
      ));
    }

    // Add fields
    final fields = <String, String>{};
    if (hobbies != null) fields['hobbies_or_interests'] = hobbies.join(',');
    if (relocate != null) fields['willing_to_relocate'] = relocate;
    if (reference != null) fields['reference_or_testimonials'] = reference;

    request.fields.addAll(fields);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to update: $responseBody');
    }
  } catch (e) {
    rethrow;
  }
}

// For deleting a single hobby
Future<void> deleteHobby(int id, String hobbyToRemove) async {
  try {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'access_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // First get current hobbies
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}api/employee/employee-additional-information/$id/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> hobbies =
          (data['hobbies_or_interests']?.toString().split(',') ?? [])
              .map((e) => e.trim())
              .where((hobby) => hobby != hobbyToRemove)
              .toList();

      // Update with remaining hobbies
      await http.put(
        Uri.parse(
            '${ApiConstants.baseUrl}api/employee/employee-additional-information/$id/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          ...data,
          'hobbies_or_interests': hobbies.join(','),
        }),
      );
    } else {
      throw Exception('Failed to fetch current hobbies');
    }
  } catch (e) {
    rethrow;
  }
}
