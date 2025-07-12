import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;

import '../2model/modelpremium.dart';
import '../model/model.dart';

part 'prrmiumemployer_state.dart';

class PrrmiumemployerCubit extends Cubit<PrrmiumemployerState> {
  PrrmiumemployerCubit() : super(PrrmiumemployerInitial());
  String baseurl = "https://server.studentsgigs.com";
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";

  Future<void> fetchPlans() async {
    emit(PrrmiumemployerIoading());

    final url = Uri.parse('$baseurl/api/employer/employer-all-plans/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final plans = data.map((e) => PremiumPageModel.fromJson(e)).toList();
        emit(PrrmiumemployerIoaded(plans));
      } else {
        emit(PrrmiumemployerError("Failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(PrrmiumemployerError("Error: $e"));
    }
  }






}

