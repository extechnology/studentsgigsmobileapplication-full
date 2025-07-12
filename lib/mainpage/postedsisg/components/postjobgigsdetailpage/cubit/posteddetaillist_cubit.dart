import 'package:anjalim/mainpage/postedsisg/components/postjobgigsdetailpage/cubit/posteddetaillist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";
  final base = "https://server.studentsgigs.com";

  Future<void> fetchApplications({
    required String jobType,
    required int id,
  }) async {
    emit(DashboardLoading());

    final uri = Uri.parse("$base/api/employer/dashboard-applications/")
        .replace(queryParameters: {
      'job_type': jobType,
      'id': id.toString(),
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("statuscode ${response.statusCode}");
        final List<Postedpagelist> applications = postedpagelistFromJson(response.body); // ✅ ✅ ✅
        print("${applications.length}");
        print("data $applications");

        emit(DashboardLoaded(applications));
      } else {
        emit(DashboardError("Failed: ${response.statusCode}"));
      }
    } catch (e) {
      print("eroor of e ${e}");
      emit(DashboardError("Error: $e"));
    }
  }
}
