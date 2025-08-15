import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  Future<List<Map<String, String>>> fetchPreferredCategories() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}api/employee/talent-categories-view/"),
      headers: await ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map<Map<String, String>>((item) => {
                'value': item['value'].toString(),
                'label': item['label'].toString()
              })
          .toList();
    } else {
      throw Exception("Failed to fetch categories");
    }
  }

  Future<List<Map<String, dynamic>>> fetchSelectedCategories() async {
    final response = await http.get(
      Uri.parse(
          "${ApiConstants.baseUrl}api/employee/employee-preferred-job-category/"),
      headers: await ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch selected categories");
    }
  }

  Future<void> submitSelectedCategory(String selectedCategory) async {
    final response = await http.post(
      Uri.parse(
          "${ApiConstants.baseUrl}api/employee/employee-preferred-job-category/"),
      headers: await ApiConstants.headers,
      body: jsonEncode({'preferred_job_category': selectedCategory}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorResponse = jsonDecode(response.body);
      String errorMessage = 'Failed to save category';

      if (errorResponse is List && errorResponse.isNotEmpty) {
        errorMessage = errorResponse[0];
      } else if (errorResponse is Map && errorResponse.containsKey('detail')) {
        errorMessage = errorResponse['detail'];
      } else if (errorResponse is Map && errorResponse.containsKey('message')) {
        errorMessage = errorResponse['message'];
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteCategory(int preferenceId) async {
    final response = await http.delete(
      Uri.parse(
          "${ApiConstants.baseUrl}api/employee/employee-preferred-job-category/?pk=$preferenceId"),
      headers: await ApiConstants.headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete category");
    }
  }
}
