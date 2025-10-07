import 'dart:convert';
import 'package:anjalim/student_Section/student_blocs/Delete_Account/delete_event.dart';
import 'package:anjalim/student_Section/student_blocs/Delete_Account/delete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc() : super(DeleteAccountInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResetDeleteAccountEvent>(_onReset);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoading());
    try {
      final response = await http.post(
        Uri.parse(
            'https://server.studentsgigs.com/api/employee/user-delete-request-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': event.email}),
      );

      // print("=== SEND OTP RESPONSE ===");
      // print("StatusCode: ${response.statusCode}");
      // print("Body: ${response.body}");
      // print("=========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("✅ EMIT: OtpSentSuccess (status ${response.statusCode})");
        // print("SUCSSESS _onSendOtp--------------${response.body}");
        emit(OtpSentSuccess('OTP has been sent to your email'));
      } else {
        // print("ERROR _onSendOtp--------------${response.body}");

        final errorData = jsonDecode(response.body);

        // extract the most meaningful message from backend
        final msg = errorData['message']?.toString() ??
            errorData['error']?.toString() ??
            (errorData['identifier'] is List
                ? (errorData['identifier'] as List).join(", ")
                : errorData['identifier']?.toString()) ??
            "Failed to send OTP";

        // print("❌ EMIT: DeleteAccountError → $msg");
        emit(DeleteAccountError(msg));
      }
    } catch (e) {
      // print("❌ EMIT: DeleteAccountError (exception) → ${e.toString()}");
      emit(DeleteAccountError('Network error: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoading());
    try {
      final response = await http.post(
        Uri.parse(
            'https://server.studentsgigs.com/api/employee/verify-user-delete-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': event.email,
          'otp': event.otp,
        }),
      );

      // print("=== VERIFY OTP RESPONSE ===");
      // print("StatusCode: ${response.statusCode}");
      // print("Body: ${response.body}");
      // print("===========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("✅ EMIT: OtpVerifiedSuccess (status ${response.statusCode})");
        emit(OtpVerifiedSuccess(
          'Your account will be deleted in 60 days. You can still use the app during this period. We\'re sorry to see you leave as a member!',
        ));
      } else {
        final errorData = jsonDecode(response.body);

        // try to extract a meaningful message
        final msg = errorData['message']?.toString() ??
            (errorData['identifier'] is List
                ? (errorData['identifier'] as List).join(", ")
                : errorData['identifier']?.toString()) ??
            "Unknown error";

        if (msg.contains('User delete request verified')) {
          // print(
          //     "✅ EMIT: OtpVerifiedSuccess (forced success on special message)");
          emit(OtpVerifiedSuccess(
            'Your account will be deleted in 60 days. You can still use the app during this period. We\'re sorry to see you leave as a member!',
          ));
        } else {
          // print("❌ EMIT: DeleteAccountError → $msg");
          emit(DeleteAccountError(msg));
        }
      }
    } catch (e) {
      // print("❌ EMIT: DeleteAccountError (exception) → ${e.toString()}");
      emit(DeleteAccountError('Network error: ${e.toString()}'));
    }
  }

  Future<void> _onResendOtp(
      ResendOtpEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoading());
    try {
      final response = await http.post(
        Uri.parse(
            'https://server.studentsgigs.com/api/employee/user-delete-request-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': event.email}),
      );

      if (response.statusCode == 200) {
        // print("SUCSSESS _onResendOtp--------------${response.body}");
        emit(OtpSentSuccess('OTP has been resent to your email'));
      } else {
        // print("ERROR _onResendOtp--------------${response.body}");

        final errorData = jsonDecode(response.body);
        emit(
            DeleteAccountError(errorData['message'] ?? 'Failed to resend OTP'));
      }
    } catch (e) {
      // print("ERROR IN DELETE ------------$e");
      emit(DeleteAccountError('Network error: ${e.toString()}'));
    }
  }

  void _onReset(
      ResetDeleteAccountEvent event, Emitter<DeleteAccountState> emit) {
    emit(DeleteAccountInitial());
  }
}
