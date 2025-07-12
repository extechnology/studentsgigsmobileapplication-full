import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../2model/modelpremium.dart';

part 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(PremiumInitial());
  String baseurl = "https://server.studentsgigs.com";
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";


  Future<void> fetchPremiumPlan() async {
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
      emit(PremiumError('Error: $e'));
    }
  }
}
