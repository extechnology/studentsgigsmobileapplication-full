import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String username,
    required String password,
}) async {
    // print("its not verfyotp");
    emit(OtpIoading());

    try {
      // print("its not verfyotp2");

      var uri = Uri.parse('https://server.studentsgigs.com/api/employer/verify-otp/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email
        ..fields['otp'] = otp
        ..fields['username'] = username
        ..fields['password'] = password;

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // print(response.statusCode);

        // print("OTP verification success: ${response.statusCode}");
        emit(OtpIoaded(responseBody));

      } else {

        // print("OTP verification failed: ${response.statusCode}");
        // print("Response body: $responseBody");
        emit(Otperror('Failed: $responseBody'));
      }
    } catch (e) {
      // print("Exception during OTP verification: $e");
      emit(Otperror('Exception: $e'));
    }
  }

}
