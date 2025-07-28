import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../datapage/datapage.dart';
import '../model/model.dart';

part 'getpostjob_state.dart';

class GetpostjobCubit extends Cubit<GetpostjobState> {
  GetpostjobCubit() : super(GetpostjobInitial()){
    fetchJobPosts();
  }
  final String baseurl = ApiConstants.baseUrl;

  Future<void> fetchJobPosts() async {
    emit(GetpostjobIoading());

    final url = Uri.parse(
      '$baseurl/api/employer/employer-jobs/',
    );

    try {
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${token ?? token2}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jobData = getjobpostdataFromJson(response.body);
        emit(GetpostjobIoaded(jobData.jobs));
      } else {
        emit(Getpostjoberror('Failed to fetch data: ${response.statusCode}'));
      }
    } catch (e) {
      print(" $e");
      emit(Getpostjoberror('Error: $e'));
    }
  }

}
