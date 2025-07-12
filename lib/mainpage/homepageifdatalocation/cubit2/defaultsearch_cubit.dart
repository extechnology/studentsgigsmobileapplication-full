import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model2/locationsearch.dart'; // <-- import your model correctly

part 'defaultsearch_state.dart';

class DefaultsearchCubit extends Cubit<DefaultsearchState> {
  DefaultsearchCubit() : super(DefaultsearchInitial()){
    getserch();
  }
  final String baseurl = "https://server.studentsgigs.com";

  final TextEditingController locationsearchController = TextEditingController();
 final String bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMjMyNzgwLCJpYXQiOjE3NTE2Mjc5ODAsImp0aSI6IjQzOTRkYjgyMmRlOTQ0YjJhM2ZjNzMzMjFiMDM4ZTc0IiwidXNlcl9pZCI6OTN9.XjfCED0nFwJPmaxOQUToaE49IPDTrhrLfezxdi-wWBU";
  bool isPaginationListenerAttached = false;
  final scrollController = ScrollController();
  int counter = 1;
  List imagesData = [];




  Future<void>getserch() async {

    final url = "$baseurl/api/employer/search-employee/?page=$counter";
    final response = await http.get(Uri.parse(url),headers: {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',

    });
   if(response.statusCode >= 200 && response.statusCode <= 299){
     final data = locationsearchFromJson(response.body);
     print(data);
     imagesData.addAll(data.data.map((Datum) {
       return {
         "user":Datum.user,
         "profile": Datum.profile.profilePic,
         "name": Datum.name,
         "job_title": Datum.jobTitle,
         "preferred_work_location": Datum.preferredWorkLocation,

       };
     }).toList());

     print("hey where$imagesData");

     emit(DefaultsearchInitial());

   }else {
     emit(DefaultsearchError(message:"Server error: ${response.statusCode}"));
   }


  }
  Map<String, dynamic>? cachedPlanUsage; // 👈 Add this at the top of your Cubit class


  Future<Map<String, dynamic>?> fetchPlanUsage() async {
    // ✅ If cached, return directly (fast)
    if (cachedPlanUsage != null) {
      print("📦 Using cached plan data");
      return cachedPlanUsage;
    }

    // 🛰️ Otherwise, make API call
    final url = "$baseurl/api/employer/employer-plan/";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final data = jsonDecode(response.body);
        cachedPlanUsage = data; // 🔁 Save to cache
        return data;
      } else {
        print("❌ Failed to fetch plan: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❗ Exception during plan fetch: $e");
      return null;
    }
  }
  Future<void> postVisitedCount(String employeeId) async {

    print("yes");
    print("Token: $bearerToken");
    print("Employee ID: $employeeId");

    final uri = Uri.parse("$baseurl/api/employer/employee-profile-access/");
    print("Posting to: $uri");

    try {
      final request = http.MultipartRequest("POST", uri);


      request.fields["employee_id"] = employeeId;
      request.headers["Authorization"] = "Bearer $bearerToken";

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print("✅ Visited count updated: $responseBody");
      } else {
        print("❌ Failed to update visited count: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ Exception during visited count post: $e");
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

