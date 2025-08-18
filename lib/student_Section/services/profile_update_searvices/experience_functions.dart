import 'package:anjalim/student_Section/models_std/employee_Profile/experiencemodel.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ExperienceService {
  Future<List<Experiences>> fetchExperience() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}api/employee/employee-experience/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          return [];
        }

        return data.map<Experiences>((exp) {
          try {
            final experience = Experiences.fromJson(exp);
            return experience;
          } catch (e) {
            throw Exception('Failed to parse experience: $e');
          }
        }).toList();
      } else {
        throw Exception(
            'Failed to load experiences - Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }

  Future<void> postExperience(String companyName, String jobTitle,
      String startDate, String endDate, bool expWork) async {
    try {
      final url =
          Uri.parse('${ApiConstants.baseUrl}api/employee/employee-experience/');

      final headers = await ApiConstants.headers;

      // Convert dates to proper backend format (YYYY-MM-DD)
      String formattedStartDate = _convertToBackendDateFormat(startDate);
      String? formattedEndDate;

      if (!expWork && endDate.isNotEmpty) {
        formattedEndDate = _convertToBackendDateFormat(endDate);
      } else {}

      // Handle end date properly - if currently working, don't send end_date field
      final body = <String, dynamic>{
        'exp_company_name': companyName,
        "exp_job_title": jobTitle,
        "exp_start_date": formattedStartDate,
        "exp_working": expWork,
      };

      // Only add end_date if not currently working and endDate is not empty
      if (!expWork && formattedEndDate != null) {
        body["exp_end_date"] = formattedEndDate;
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        // Parse error response if available
        String errorMessage = 'Failed to add experience';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('detail')) {
            errorMessage = errorData['detail'];
          } else if (errorData is Map && errorData.containsKey('error')) {
            errorMessage = errorData['error'];
          } else {
            errorMessage = 'Server error: ${response.statusCode}';
          }
        } catch (e) {
          errorMessage =
              'Server error: ${response.statusCode} - ${response.body}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow; // Re-throw the original exception
      } else {
        throw Exception('Network error: $e');
      }
    }
  }

  Future<bool> deleteExperience(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '${ApiConstants.baseUrl}api/employee/employee-experience/?pk=$id'),
        headers: await ApiConstants.headers,
      );

      // 204 means successful deletion with no content returned
      // 200 might also be valid depending on your API
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Helper method to convert date string to YYYY-MM-DD format
  String _convertToBackendDateFormat(String dateString) {
    if (dateString.isEmpty) return dateString;

    try {
      // List of possible date formats your app might use
      final possibleFormats = [
        'yyyy-MM-dd', // Already correct format
        'dd/MM/yyyy', // Common format
        'MM/dd/yyyy', // US format
        'dd-MM-yyyy', // Dash format
        'yyyy/MM/dd', // Another format
        'dd MMM yyyy', // Text month format
        'MMM dd, yyyy', // US text format
      ];

      DateTime? parsedDate;

      // Try to parse with different formats
      for (String format in possibleFormats) {
        try {
          parsedDate = DateFormat(format).parseStrict(dateString);
          break;
        } catch (e) {
          continue;
        }
      }

      // If no format worked, try loose parsing
      if (parsedDate == null) {
        parsedDate = DateTime.parse(dateString);
      }

      // Convert to backend format (YYYY-MM-DD)
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // Return original string if conversion fails
      return dateString;
    }
  }
}

Future<List<Map<String, String>>> fetchJobTitle() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}api/employee/job-title/'),
      headers: await ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Map<String, String>> jobTitles = [];
      for (var item in data) {
        jobTitles.add({
          'label': item['label'].toString(),
          'value': item['value'].toString(),
        });
      }

      return jobTitles;
    } else {
      throw Exception(
          'Failed to load JobTitle - Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Failed to load JobTitle: $e');
  }
}
