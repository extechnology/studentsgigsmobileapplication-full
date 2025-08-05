import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../datapage/datapage.dart';
import '../Model/model.dart';

part 'planusage_state.dart';

class PlanusageCubit extends Cubit<PlanusageState> {
  PlanusageCubit() : super(PlanusageInitial()){
    fetchPlanUsage();
  }

  final String baseurl = ApiConstantsemployer.baseUrl;

  Future<void> fetchPlanUsage() async {
    emit(PlanusageIoading());

    final url = Uri.parse("$baseurl/api/employer/plan-usage/");

    try {
      final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
      // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

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
