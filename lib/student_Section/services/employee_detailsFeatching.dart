import 'dart:convert';
import 'package:anjalim/student_Section/models_std/employeeprofile.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmployeeServices {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = "${ApiConstants.baseUrl}api/employee/employees/";

  Future<StudentEmployee> fetchEmployeeDetails() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> employees = jsonDecode(response.body);

        if (employees.isNotEmpty) {
          final employee = employees[0];
          final employeeId = employee["id"];
          await _storage.write(
              key: 'employee_id', value: employeeId.toString());

          // Capitalize the first letter of the name
          String name = employee['name'] ?? '';
          if (name.isNotEmpty) {
            name = name[0].toUpperCase() + name.substring(1).toLowerCase();
          }

          final Map<String, dynamic> employeeData = {
            'name': name,
            'email': employee['email'] ?? '',
            'phone': employee['phone'] ?? '',
            'preferred_work_location':
                employee['preferred_work_location'] ?? '',
            'available_work_hours':
                (employee['available_work_hours']?.toString() ?? '0'),
            'profile_photo': employee['profile_photo'],
            'cover_photo': employee['profile']?['cover_photo'],
            'portfolio': employee['portfolio'] ?? '',
            'job_title': employee['job_title'] ?? '',
            'about': employee['about'],
            'available_working_periods_start_date':
                employee['available_working_periods_start_date']?.toString(),
            'available_working_periods_end_date':
                employee['available_working_periods_end_date']?.toString(),
            'date_of_birth': employee['date_of_birth']?.toString(),
            'age': employee['age'],
            'gender': employee['gender']
          };

          return StudentEmployee.fromMap(employeeData);
        } else {
          throw Exception('No employee data found');
        }
      } else {
        throw Exception('Failed to load employee details');
      }
    } catch (e) {
      throw e;
    }
  }
}
