import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../datapage/datapage.dart';
import '../model/model.dart';

part 'getpostjob_state.dart';

class GetpostjobCubit extends Cubit<GetpostjobState> {
  GetpostjobCubit() : super(GetpostjobInitial()){
    _monitorConnection(); // 👈 Start listening here

    fetchJobPosts();

  }
  final String baseurl = ApiConstantsemployer.baseUrl;
  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(Getpostjoberror("No internet connection"));
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(Getpostjoberror("No internet connection"));
      }
    });
  }
  Future<void> fetchJobPosts() async {
    if (!isConnected) {
      emit(Getpostjoberror("No internet connection"));
      return;
    }
    emit(GetpostjobIoading());

    final url = Uri.parse(
      '$baseurl/api/employer/employer-jobs/',
    );

    try {
      final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
      // final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token

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
      // print(" $e");
      // emit(Getpostjoberror('Error: $e'));
    }
  }

}
