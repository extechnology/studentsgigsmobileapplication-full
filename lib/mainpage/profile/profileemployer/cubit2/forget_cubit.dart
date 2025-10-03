import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../datapage/datapage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'forget_state.dart';

class ForgetCubit extends Cubit<ForgetState> {
  ForgetCubit() : super(ForgetInitial());

  final String baseurl = ApiConstantsemployer.baseUrl;

  Future<void> resetPassword(
      {required String confirm_password, required String password}) async {
    emit(ForgetIoading());

    try {
      final token = await ApiConstantsemployer.getTokenOnly();

      final uri = Uri.parse('$baseurl/api/employer/password-reset/');

      final request = http.MultipartRequest('POST', uri)
        ..fields['confirm_password'] = confirm_password
        ..fields['password'] = password
        ..headers['Authorization'] =
            'Bearer ${token ?? ""}'; // add token manually

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ForgetIoaded("Password reset link sent."));
        // print("tokensucces");
        // print(token);
      } else {
        // print("tokensucces1");
        // print(token);

        emit(ForgetError("Failed: ${response.body}"));
      }
    } catch (e) {
      // print("tokensucces2");

      emit(ForgetError("Server error"));
    }
  }
}
