import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  final String baseUrl = "https://server.studentsgigs.com/api/employee";

  final TextEditingController otp = TextEditingController();
  final TextEditingController email = TextEditingController();

  Future<void> requestOtp(String email) async {
    emit(DeleteAccountLoading());
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user-delete-request-otp/"),
        body: {"identifier": email.trim()},
      );

      if (response.statusCode == 200) {
        // print("a${email.trim()}");

        final data = jsonDecode(response.body);
        emit(DeleteAccountOtpSent(data["message"] ?? "OTP sent successfully"));
      } else {
        // print("b${email.trim()}");

        emit(DeleteAccountError("Failed to send OTP"));
      }
    } catch (e) {
      emit(DeleteAccountError(e.toString()));
    }
  }

  /// Step 2: Verify OTP
  Future<void> verifyOtp(String otp) async {
    emit(DeleteAccountLoading());
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-user-delete-otp/"),
        body: {
          "identifier": email.text.trim(),
          "otp": otp,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        emit(DeleteAccountSuccess(
            data["message"] ?? "Account deleted successfully"));
      } else {
        emit(DeleteAccountError("OTP verification failed"));
      }
    } catch (e) {
      emit(DeleteAccountError(e.toString()));
    }
  }
}
