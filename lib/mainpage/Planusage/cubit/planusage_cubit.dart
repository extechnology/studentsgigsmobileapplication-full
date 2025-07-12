import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../Model/model.dart';

part 'planusage_state.dart';

class PlanusageCubit extends Cubit<PlanusageState> {
  PlanusageCubit() : super(PlanusageInitial()){
    fetchPlanUsage();
  }
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";

  String baseurl = "https://server.studentsgigs.com";

  Future<void> fetchPlanUsage() async {
    emit(PlanusageIoading());

    final url = Uri.parse("$baseurl/api/employer/plan-usage/");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final planData = Planusage.fromJson(data);
        emit(PlanusageIoaded(planData));
      } else {
        emit(Planusageerror('Server Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(Planusageerror('Exception: $e'));
    }
  }

}
