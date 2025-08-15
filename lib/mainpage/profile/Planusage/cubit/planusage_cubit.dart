import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

import '../../../datapage/datapage.dart';
import '../Model/model.dart';

part 'planusage_state.dart';

class PlanusageCubit extends Cubit<PlanusageState> {
  PlanusageCubit() : super(PlanusageInitial()){
    _monitorConnection();

    fetchPlanUsage();
  }

  final String baseurl = ApiConstantsemployer.baseUrl;
  // final storage = FlutterSecureStorage();
  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(PlanusageInitial());
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(PlanusageInitial());
      }
    });
  }
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
      // _monitorConnection();

      emit(Planusageerror('Server error '));
    }
  }

}
