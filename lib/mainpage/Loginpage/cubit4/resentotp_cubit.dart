import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;

part 'resentotp_state.dart';

class ResentotpCubit extends Cubit<ResentotpState> {
  ResentotpCubit() : super(ResentotpInitial());
  Future<void> resendOtp(String email) async {
    emit(ResentotpIoading());

    try {
      var uri = Uri.parse('https://server.studentsgigs.com/api/employer/resend-otp/');

      var request = http.MultipartRequest('POST', uri);
      request.fields['email'] = email;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // You may decode if needed:
        // var data = jsonDecode(response.body);
        emit(ResentotpIoaded());
      } else {
        emit(Resentotperror('Failed: ${response.statusCode}\n${response.body}'));
      }
    } catch (e) {
      emit(Resentotperror(e.toString()));
    }
  }
}
