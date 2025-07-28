import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../datapage/datapage.dart';

part 'delete_state.dart';

class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit() : super(DeleteInitial());
  final String baseurl = ApiConstants.baseUrl;

  Future<void> deleteJob({required String type, required int pk, required String token}) async {
    emit(DeleteLoading());

    final uri = Uri.parse('$baseurl/api/employer/employer-jobs/')
        .replace(queryParameters: {
      'type': type,
      'pk': pk.toString(),
    });

    try {
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer ${token ?? token2}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        emit(DeleteobSucces());
      } else {
        emit(DeletejobError("Failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(DeletejobError(e.toString()));
    }
  }
}
