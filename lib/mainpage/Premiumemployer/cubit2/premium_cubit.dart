import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../datapage/datapage.dart';
import '../2model/modelpremium.dart';

part 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(PremiumInitial()){
    _monitorConnection();

  }
  final String baseurl = ApiConstantsemployer.baseUrl;

  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(PremiumInitial());
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(PremiumInitial());
      }
    });
  }
  Future<void> fetchPremiumPlan() async {
    final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
    // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

    emit(PremiumLoading());

    final url = Uri.parse("$baseurl/api/employer/employer-plan/");
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final premium = Statuspremium.fromJson(data);
        emit(PremiumLoaded(premium));
      } else {
        emit(PremiumError('Failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(PremiumError('server error'));
    }
  }
}
