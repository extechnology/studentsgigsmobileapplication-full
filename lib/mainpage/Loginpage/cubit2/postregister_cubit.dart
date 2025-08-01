import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'postregister_state.dart';

class PostregisterCubit extends Cubit<PostregisterState> {
  PostregisterCubit() : super(PostregisterInitial());


  Future<void> registerUser({
    required String email,
    required String username,
    required String password,
    required String conformpassword,


}) async {
    emit(PostregisterIoading());
    print("its working ");

    try {
      var uri = Uri.parse('https://server.studentsgigs.com/api/employer/register/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email
        ..fields['username'] = username
        ..fields['password'] = password
        ..fields['password_confirm'] = conformpassword;

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.statusCode);
        emit(Postregisterloaded(responseBody));
      }  else {
        print("fnbsmdmsdmsc");

        emit(Postregistererror('Failed: $responseBody'));
      }
    } catch (e) {
      print("$e");

      emit(Postregistererror('Exception: $e'));
    }
  }

  // Future<void> verifyOtp() async {
  //   print("its not verfyotp");
  //   emit(PostregisterIoading());
  //
  //   try {
  //     print("its not verfyotp2");
  //
  //     var uri = Uri.parse('https://cb06462c34b4.ngrok-free.app/api/employer/verify-otp/');
  //     var request = http.MultipartRequest('POST', uri)
  //       ..fields['email'] = emailController.text.trim()
  //       ..fields['otp'] = controllers.map((c) => c.text).join().trim()
  //       ..fields['username'] = usernameController.text.trim()
  //       ..fields['password'] = passwordController.text.trim();
  //
  //     var response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       print(response.statusCode);
  //
  //       print("OTP verification success: ${response.statusCode}");
  //       emit(Postregisterloaded(responseBody));
  //     } else {
  //
  //       print("OTP verification failed: ${response.statusCode}");
  //       print("Response body: $responseBody");
  //       emit(Postregistererror('Failed: $responseBody'));
  //     }
  //   } catch (e) {
  //     print("Exception during OTP verification: $e");
  //     emit(Postregistererror('Exception: $e'));
  //   }
  // }


}


