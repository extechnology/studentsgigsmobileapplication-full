import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;

Future<Iterable<String>> preferedLocation(String input) async {
  final uri =
      Uri.parse('${ApiConstants.baseUrl}api/employee/locations/?search=$input')
          .replace(queryParameters: {"query": input});

  try {
    final response = await http.get(uri, headers: await ApiConstants.headers);
    //print("failed loc---${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('features')) {
        // Extract location names from the features
        final locations = (data['features'] as List)
            .map<String>((feature) => feature['properties']['name'] as String)
            .toList();
        return locations;
      }
    }
    return []; // Return empty list if no results or error
  } catch (e) {
    return []; // Return empty list on error
  }
}
