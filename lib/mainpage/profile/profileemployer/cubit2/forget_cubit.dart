import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../datapage/datapage.dart';

part 'forget_state.dart';

class ForgetCubit extends Cubit<ForgetState> {
  ForgetCubit() : super(ForgetInitial());

  final String baseurl = ApiConstantsemployer.baseUrl;

  Future<void> resetPassword({required String email}) async {
    emit(ForgetIoading());

    try {
      final uri = Uri.parse('$baseurl/api/employer/reset-password/');

      final request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ForgetIoaded("Password reset link sent."));
      } else {
        emit(ForgetError("Failed: ${response.body}"));
      }
    } catch (e) {
      emit(ForgetError("Server error"));
    }
  }
}
