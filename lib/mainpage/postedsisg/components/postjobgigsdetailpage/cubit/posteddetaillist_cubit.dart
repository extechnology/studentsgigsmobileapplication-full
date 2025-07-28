import 'package:anjalim/mainpage/postedsisg/components/postjobgigsdetailpage/cubit/posteddetaillist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../datapage/datapage.dart';
import '../model/model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final String baseurl = ApiConstants.baseUrl;

  Future<void> fetchApplications({
    required String jobType,
    required int id,
  }) async {
    emit(DashboardLoading());

    final uri = Uri.parse("$baseurl/api/employer/dashboard-applications/")
        .replace(queryParameters: {
      'job_type': jobType,
      'id': id.toString(),
    });

    try {
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${token ?? token2}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("statuscode ${response.statusCode}");
        final List<Postedpagelist> applications = postedpagelistFromJson(response.body); // ✅ ✅ ✅
        print("${applications.length}");
        print("data ${applications}");

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
