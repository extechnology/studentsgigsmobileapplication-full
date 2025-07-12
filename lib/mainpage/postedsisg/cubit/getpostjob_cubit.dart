import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';

part 'getpostjob_state.dart';

class GetpostjobCubit extends Cubit<GetpostjobState> {
  GetpostjobCubit() : super(GetpostjobInitial()){
    fetchJobPosts();
  }
  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";
    final base = "https://server.studentsgigs.com";
  Future<void> fetchJobPosts() async {
    emit(GetpostjobIoading());

    final url = Uri.parse(
      '$base/api/employer/employer-jobs/',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
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
