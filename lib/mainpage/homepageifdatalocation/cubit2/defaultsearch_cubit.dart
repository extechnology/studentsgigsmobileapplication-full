import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../datapage/datapage.dart';
import '../model2/locationsearch.dart'; // <-- import your model correctly

part 'defaultsearch_state.dart';

class DefaultsearchCubit extends Cubit<DefaultsearchState> {
  DefaultsearchCubit() : super(DefaultsearchInitial()){
    _monitorConnection();

    getserch();
    fetchPlanUsage(); // preload plan info

  }
  final String baseurl = ApiConstantsemployer.baseUrl;
  final headers =  ApiConstantsemployer.headers;

  final TextEditingController locationsearchController = TextEditingController();
  bool isPaginationListenerAttached = false;
  final scrollController = ScrollController();
  int counter = 1;
  List imagesData = [];

  bool isLoadingMore = false;
  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(DefaultsearchInitial());
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(DefaultsearchInitial());
      }
    });
  }



  Future<void>getserch({bool isRefresh = false}) async {
    if (isRefresh) {
      counter = 1;
      imagesData.clear();
      emit(DefaultsearchLoading());
    }else {
      isLoadingMore = true;
      emit(DefaultsearchInitial()); // This tells UI to rebuild and show bottom loader
    }
    final url = "$baseurl/api/employer/search-employee/?page=$counter";
    final response = await http.get(Uri.parse(url),
        headers: await headers
    );
   if(response.statusCode >= 200 && response.statusCode <= 299){
     final data = locationsearchFromJson(response.body);
     // print(data);
     imagesData.addAll(data.data.map((Datum) {
       return {
         "user":Datum.user,
         "profile": Datum.profile.profilePic,
         "name": Datum.name,
         "job_title": Datum.jobTitle,
         "preferred_work_location": Datum.preferredWorkLocation,

       };
     }).toList());
     // print(headers);

     // print("hey where$imagesData");
     isLoadingMore = false;


     emit(DefaultsearchInitial());

   }else {
     isLoadingMore = false;

     emit(DefaultsearchError(message:"Server error: ${response.statusCode}"));
   }


  }
  Map<String, dynamic>? cachedPlanUsage; // 👈 Add this at the top of your Cubit class


  Future<Map<String, dynamic>?> fetchPlanUsage() async {
    // ✅ If cached, return directly (fast)
    if (cachedPlanUsage != null) {
      // print("📦 Using cached plan data");
      return cachedPlanUsage;
    }

    // 🛰️ Otherwise, make API call
    final url = "$baseurl/api/employer/employer-plan/";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers:  await headers
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final data = jsonDecode(response.body);
        cachedPlanUsage = data; // 🔁 Save to cache
        return data;
      } else {
        // print("❌ Failed to fetch plan: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // print("❗ Exception during plan fetch: $e");
      return null;
    }
  }
  Future<void> postVisitedCount(String employeeId) async {

    // print("yes");
    // print("Employee ID: $employeeId");

    final uri = Uri.parse("$baseurl/api/employer/employee-profile-access/");
    // print("Posting to: $uri");

    try {
      final request = http.MultipartRequest("POST", uri);

      final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token

      request.fields["employee_id"] = employeeId;
      request.headers["Authorization"] = "Bearer $token";

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        // print("✅ Visited count updated: $responseBody");
      } else {
        // print("❌ Failed to update visited count: ${response.statusCode}");
      }
    } catch (e) {
      // print("❗ Exception during visited count post: $e");
    }
  }



  @override
  Future<void> close() {
    locationsearchController.dispose();
    return super.close();
  }
  void clearPlanUsageCache() {
    cachedPlanUsage = null;
  }
}

