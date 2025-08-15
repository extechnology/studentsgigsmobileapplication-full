import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> jobTitleView() async {
  final uri = Uri.parse("${ApiConstants.baseUrl}api/employee/job-titles-view/");
  try {
    final response = await http.get(uri, headers: await ApiConstants.headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return []; // Return empty list if not 200 status
  } catch (e) {
    //print("Error Occurred --${e.toString()}");
    return []; // Return empty list on error
  }
}
