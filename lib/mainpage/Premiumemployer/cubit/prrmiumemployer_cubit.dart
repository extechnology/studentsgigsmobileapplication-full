import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;

import '../../datapage/datapage.dart';
import '../2model/modelpremium.dart';
import '../model/model.dart';

part 'prrmiumemployer_state.dart';

class PrrmiumemployerCubit extends Cubit<PrrmiumemployerState> {
  PrrmiumemployerCubit() : super(PrrmiumemployerInitial());
  final String baseurl = ApiConstantsemployer.baseUrl;

  Future<void> fetchPlans() async {
    emit(PrrmiumemployerIoading());

    final url = Uri.parse('$baseurl/api/employer/employer-all-plans/');

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
        final List<dynamic> data = json.decode(response.body);
        final plans = data.map((e) => PremiumPageModel.fromJson(e)).toList();
        emit(PrrmiumemployerIoaded(plans));
      } else {
        emit(PrrmiumemployerError("Failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(PrrmiumemployerError(""));
    }
  }






}

