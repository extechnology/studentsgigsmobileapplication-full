import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchUserPremiumPlans() async {
  String _baseUrl = '${ApiConstants.baseUrl}api/employee/';
  const String endpoint = 'all-plans/';
  final String apiUrl = '$_baseUrl$endpoint';

  try {
    // Get token
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: await ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final Response = json.decode(response.body);
      // print('Decoded Response Type: ${Response.runtimeType}');
      // print('Decoded Response: $Response');

      List<Map<String, dynamic>> plansList = [];

      // Handle different response structures
      if (Response is List) {
        plansList = List<Map<String, dynamic>>.from(Response);
      } else if (Response is Map<String, dynamic>) {
        // Try different possible keys for the plans data
        final possibleKeys = ['data', 'results', 'plans', 'items', 'plan_list'];

        for (String key in possibleKeys) {
          if (Response.containsKey(key)) {
            final data = Response[key];

            if (data is List) {
              plansList = List<Map<String, dynamic>>.from(data);
              break;
            } else if (data is Map<String, dynamic>) {
              plansList = [data];
              break;
            }
          }
        }

        // If no standard keys found, treat the whole response as a single plan
        if (plansList.isEmpty) {
          plansList = [Response];
        }
      }

      // Validate each plan has minimum required fields
      for (int i = 0; i < plansList.length; i++) {
        final plan = plansList[i];

        // Ensure basic fields exist
        if (!plan.containsKey('name') && !plan.containsKey('plan_name')) {
          plan['name'] = 'Plan ${i + 1}';
        }
        if (!plan.containsKey('price') && !plan.containsKey('amount')) {
          plan['price'] = '0';
        }
      }

      return plansList;
    } else {
      // Try to parse error message
      try {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'] ??
            errorResponse['error'] ??
            errorResponse['detail'] ??
            'Unknown error';
        throw Exception('API Error (${response.statusCode}): $errorMessage');
      } catch (e) {
        throw Exception('HTTP Error ${response.statusCode}: ${response.body}');
      }
    }
  } catch (e) {
    if (e is http.ClientException) {
      throw Exception('Network error: Check your internet connection');
    } else if (e is FormatException) {
      throw Exception('Invalid response format from server');
    } else {
      throw Exception('Error fetching plans: ${e.toString()}');
    }
  }
}
