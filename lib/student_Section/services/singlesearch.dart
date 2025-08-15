import 'dart:async';
import 'dart:io';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  final baseurl = "${ApiConstants.baseUrl}";

  Future<List<String>> fetchJobTitleView() async {
    final response = await http.get(
      Uri.parse('${baseurl}api/employee/category-and-title-view/'),
      headers: await ApiConstants.headers,
    );
    //print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .where((item) => item['value'] != null) // Filter out null values
          .map<String>((item) => item['value'].toString())
          .toList();
    } else {
      throw Exception('Failed to load Job Title');
    }
  }

  Future<List<String>> fetchCity(String location) async {
    try {
      final response = await http
          .get(
              Uri.parse('${baseurl}api/employee/locations/')
                  .replace(queryParameters: {"query": location}),
              headers: await ApiConstants.headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('features')) {
          // Extract and format location information
          return (data['features'] as List).map<String>((feature) {
            final props = feature['properties'] as Map<String, dynamic>;
            final type = props['type'] ?? '';
            final name = props['name'] ?? '';
            final state = props['state'] ?? '';
            final country = props['country'] ?? '';
            final postcode = props['postcode'] ?? '';

            // Format based on location type
            switch (type) {
              case 'city':
                return '$name, $state, $country,$postcode';
              case 'country':
                return '$name';
              case 'state':
                return '$name , $country';
              default:
                return name.isNotEmpty ? name : 'Unnamed Location';
            }
          }).toList();
        }
      }

      return [];
    } on SocketException {
      return [];
    } on TimeoutException {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> fetchSearchValue(
    String? gigs,
    String? city,
    String? salary_type,
    int? page,
  ) async {
    try {
      // Construct the URL with query parameter
      final uri = Uri.parse(
        '${baseurl}api/employee/job-search/',
      ).replace(queryParameters: {
        'category': gigs,
        "location": city,
        "salary_type": salary_type,
        'page': page.toString(),
      });

      final response = await http.get(uri, headers: await ApiConstants.headers);

      //

      if (response.statusCode == 200) {
        print('Response search result: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
