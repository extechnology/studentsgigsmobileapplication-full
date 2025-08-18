// lib/services/job_service.dart
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<Map<String, dynamic>>> fetchPopularJobs() async {
    final uri = Uri.parse('${_baseUrl}api/employee/popular-jobs/');

    try {
      final response = await http.get(
        uri,
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print("Popular Jobss----$data");
        if (data is List) {
          return data.map((job) => job as Map<String, dynamic>).toList();
        } else if (data is Map<String, dynamic>) {
          return [data];
        }
        return [];
      } else {
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load jobs: $e');
    }
  }

  Future<void> toggleSaveJob({
    required String jobId,
    required String jobType,
    required bool isCurrentlySaved,
  }) async {
    try {
      if (isCurrentlySaved) {
        // Remove saved job
        final deleteUri = Uri.parse('${_baseUrl}api/employee/saved-jobs/')
            .replace(queryParameters: {
          'job_id': jobId,
          'job_type': jobType,
        });
        final response = await http.delete(
          deleteUri,
          headers: await ApiConstants.headers,
        );

        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Failed to unsave job: ${response.statusCode}');
        }
      } else {
        // Save job
        final saveUri = Uri.parse('${_baseUrl}api/employee/saved-jobs/');
        final response = await http.post(
          saveUri,
          headers: await ApiConstants.headers,
          body: jsonEncode({
            'job_id': jobId,
            'job_type': jobType,
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to save job: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error toggling save status: $e');
    }
  }
// Add this method to your JobService class

  Future<List<Map<String, dynamic>>> fetchSavedJobs() async {
    final uri = Uri.parse('${_baseUrl}api/employee/saved-jobs/');

    try {
      final response = await http.get(
        uri,
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Saved Jobs----$data");

        if (data is List) {
          return data.map((job) => job as Map<String, dynamic>).toList();
        } else if (data is Map<String, dynamic>) {
          // Handle case where API returns a single job object
          return [data];
        }
        return [];
      } else {
        throw Exception('Failed to load saved jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load saved jobs: $e');
    }
  }
}
