import 'dart:convert';
import 'dart:io';
import 'package:anjalim/student_Section/models_std/employee_Profile/employeeProfileImages.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<EmployeeProfile> fetchEmployeeProfile() async {
  final _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'access_token');

  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}api/employee/employee-profile-photos/'),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      return EmployeeProfile.fromJson(data[0]); // Return first profile
    }
  }
  throw Exception('Failed to load profile or no profile exists');
}

Future<void> ImageUploadFunction(File image, BuildContext context) async {
  final profile = await fetchEmployeeProfile(); // Get full profile data
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'access_token');

  final url = Uri.parse(
      '${ApiConstants.baseUrl}api/employee/employee-profile-photos/?pk=${profile.id}');

  // Create multipart request
  var request = http.MultipartRequest('PUT', url);

  // Add headers
  request.headers.addAll({
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  });

  // Add image file
  var stream = http.ByteStream(image.openRead());
  var length = await image.length();
  var multipartFile = http.MultipartFile(
    'profile_pic', // This should match the field name expected by your API
    stream,
    length,
    filename: basename(image.path),
  );
  request.files.add(multipartFile);

  // Send the request
  var response = await request.send();

  // Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  if (response.statusCode == 200 || response.statusCode == 201) {
    //print(responseString);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image $responseString')));
  }
}

Future<void> CoverPicUploadFunction(File image) async {
  final profile = await fetchEmployeeProfile(); // Get full profile data
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'access_token');

  final url = Uri.parse(
      '${ApiConstants.baseUrl}api/employee/employee-profile-photos/?pk=${profile.id}');

  // Create multipart request
  var request = http.MultipartRequest('PUT', url);

  // Add headers
  request.headers.addAll({
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  });

  // Add image file
  var stream = http.ByteStream(image.openRead());
  var length = await image.length();
  var multipartFile = http.MultipartFile(
    'cover_photo', // This should match the field name expected by your API
    stream,
    length,
    filename: basename(image.path),
  );
  request.files.add(multipartFile);

  // Send the request
  var response = await request.send();

  // Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  if (response.statusCode == 200 || response.statusCode == 201) {
  } else {}
}
