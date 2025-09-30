import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

part 'resetpassword_state.dart';

class ResetpasswordCubit extends Cubit<ResetpasswordState> {
  ResetpasswordCubit() : super(ResetpasswordInitial());
  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(ResetpasswordInitial());
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(ResetpasswordInitial());
      }
    });
  }
  Future<void> resetPassword({required BuildContext context,required String email}) async {
    emit(ResetpasswordIoading());

    try {
      final uri = Uri.parse('https://server.studentsgigs.com/api/employer/password-reset-otp/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['identifier'] = email;

      request.headers['Accept'] = 'application/json';

      final response = await request.send();

      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ResetpasswordIoaded( "Reset email sent successfully."));
      } else {
        emit(Resetpassworderror( "Failed: ${responseBody.body}"));
      }
    } catch (e) {
      _monitorConnection();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:isConnected ? Text("Something went wrong: "): Text("Oops! We couldn’t load right now. \n Please check your network availability."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      emit(Resetpassworderror("Server issue"));
    }
  }
  Future<bool> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    emit(ResetpasswordIoading());

    try {
      final uri = Uri.parse(
          'https://server.studentsgigs.com/api/employer/verify-password-reset-otp/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['identifier'] = email
        ..fields['otp'] = otp;

      request.headers['Accept'] = 'application/json';

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {

        // emit(ResetpasswordIoaded("OTP is valid ✅"));


        return true;

      } else {
        emit(Resetpassworderror("Failed: ${responseBody.body}"));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid OTP ❌: ${responseBody.body}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return false;

      }
    } catch (e) {
      _monitorConnection();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: isConnected
              ? Text("Something went wrong: $e")
              : const Text("No Internet. Please check your connection."),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      emit(Resetpassworderror("Server issue"));
      return false; // ✅ ensure a bool is always returned

    }
  }
  Future<void> confirmPasswordChange({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetpasswordIoading());

    try {
      final uri = Uri.parse(
          'https://server.studentsgigs.com/api/employer/password-change-otp/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['identifier'] = email
        ..fields['password'] = password
        ..fields['confirm_password'] = confirmPassword;

      request.headers['Accept'] = 'application/json';

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        emit(ResetpasswordIoaded("Password reset successful "));


      } else {
        emit(Resetpassworderror("Failed: ${responseBody.body}"));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password reset failed : ${responseBody.body}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      _monitorConnection();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: isConnected
              ? Text("Something went wrong: $e")
              : const Text("No Internet. Please check your connection."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      emit(Resetpassworderror("Server issue"));
    }
  }


}
