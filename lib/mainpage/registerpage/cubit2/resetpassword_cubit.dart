import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'resetpassword_state.dart';

class ResetpasswordCubit extends Cubit<ResetpasswordState> {
  ResetpasswordCubit() : super(ResetpasswordInitial());
  Future<void> resetPassword({required String email}) async {
    emit(ResetpasswordIoading());

    try {
      final uri = Uri.parse('https://server.studentsgigs.com/api/employer/reset-password/');
      var request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email;

      request.headers['Accept'] = 'application/json';

      final response = await request.send();

      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ResetpasswordIoaded( "Reset email sent successfully."));
      } else {
        emit(Resetpassworderror( "Failed: ${responseBody.body}"));
      }
    } catch (e) {
      emit(Resetpassworderror( e.toString()));
    }
  }
}
