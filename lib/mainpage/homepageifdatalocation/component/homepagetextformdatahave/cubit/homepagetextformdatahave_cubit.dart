import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../datapage/datapage.dart';
import '../../../../postyourjob/postyourjob/model/model.dart';
import '../../../../postyourjob/postyourjob/model2/model2.dart';
import '../model/model.dart';
import '../model2/modelforserch.dart';

part 'homepagetextformdatahave_state.dart';

class HomepagetextformdatahaveCubit extends Cubit<HomepagetextformdatahaveState> {
  HomepagetextformdatahaveCubit({String? initialCategory}) : super(HomepagetextformdatahaveInitial()){
    if (initialCategory != null && initialCategory.trim().isNotEmpty) {
      categoryController.text = initialCategory.trim();
      fetchEmployees(category: initialCategory.trim());
    }
    Future.delayed(Duration(seconds: 5), () {
      getthetextsuggestion();
    });
  }
  int counter = 1;
  final scrollControllerofsearch = ScrollController();

  bool isPaginationListenerAttached = false;

  final compasationFocusNode = FocusNode();
  final categoryController = TextEditingController();
  final categoryFocusNode = FocusNode();

  final compensationController = TextEditingController();
  final locationController = TextEditingController();
  final locationFocusNode = FocusNode();
  String? selectedLocation;
  List<Map<String, Object>> locationdata = [];
  List imagesData = [];
  List<String> filteredJobTitles = [];
  final List<Datum> allEmployees = []; // 🔥 This will store all fetched data

  String? selectedCategory;

  void updateJobTitlesForCategory(String category) {
    selectedCategory = category;

    filteredJobTitles = imagesData
        .where((e) => e["category"] == category)
        .map((e) => e["job_title"].toString())
        .toSet() // remove duplicates
        .toList();

    emit(HomepagetextformdatahaveInitial());
  }

  final List<String> payStructures = [
    "Hourly Rate",
    "All-Day Gigs",
    "Weekend Gigs",
    "Vacation Gigs",
    "Project Based",
  ];
  final String baseurl = ApiConstants.baseUrl;
  final headers =  ApiConstants.headers;
  Future<void> getthetextsuggestion() async {
    final url = "$baseurl/api/employer/category-and-title-view/";
    final response = await http.get(Uri.parse(url)

    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final data = homepagecategoryFromJson(response.body);
      print(data);
      final mapped = data.map((item) {
        return {
          "id": item.id,
          "job_title": item.jobTitle,
          "category": item.category,
          "label": item.label,
          "value": item.value,
          "talent_category": item.talentCategory,
        };
      }).toList();
      imagesData.addAll(mapped);


      print("hey where$imagesData");

      emit(HomepagetextformdatahaveInitial());
    } else {
      print("statusCode${response.statusCode}");
    }
  }

  Future<void> getLocation(String query) async {
    final url = "$baseurl/api/employer/locations-employer/?query=$query";
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final parsed = countrylocationFromJson(response.body);
        final mapped = parsed.features.map((item) {
          final name = item.properties.name;
          final state = item.properties.state ?? '';
          final country = item.properties.country ?? '';
          return {
            "label": "$name, $state, $country",
            "value": "$name, $state, $country",
            "id": item.properties.osmId,
          };
        }).toList();

        locationdata = mapped;

        // ⚡️ REMOVE THIS EMIT
        // emit(PostyourjobInitial());
      } else {
        print("Location fetch failed: ${response.statusCode}");
      }
    } on TimeoutException {
      print("Location request timed out after 15 seconds");
    } catch (e) {
      print("Location fetch error: $e");
    }
  }

  Future<List<String>> getLocationSuggestions(String query) async {
    await getLocation(query);
    return locationdata.map((e) => e['label'] as String).toList();
  }
  Timer? _debounce;
  bool shouldListenToLocationChanges = true;

  void onLocationChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!shouldListenToLocationChanges) return;

      if (selectedLocation != null && query == selectedLocation) {
        return;
      }

      if (query.length >= 3) {
        getLocation(query);
      } else {
        locationdata = [];
        emit(HomepagetextformdatahaveInitial()); // Clears results if needed
      }
    });
  }
  Future<void> fetchEmployees({
     String ? category,
     String ? location,
  }) async {
    print("hey its working ");
    emit(HomepagetextformdatahaveIoading());

    try {

      String url = '$baseurl/api/employer/search-employee/?page=${counter ?? 1}';

      // Append category if not empty
      if (category != null && category.trim().isNotEmpty) {
        url += '&category=${Uri.encodeComponent(category.trim())}';
      }

      // Append location if not empty
      if (location != null && location.trim().isNotEmpty) {
        url += '&location=${Uri.encodeComponent(location.trim())}';
      }

      print("Final URL: $url");
      // final uri = Uri.parse(
      //   '$baseurl/api/employer/search-employee/'
      //       '?category=$category&location=$location&page=${counter ?? 1}',
      // );
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token
      final token2 = await ApiConstants.getTokenOnly2(); // ✅ get actual token


      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${token ?? token2}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final seachdata = seachdataFromJson(response.body);
        print(response.statusCode);
        print(url);
        print(seachdata.data.length);
        print(seachdata.data);


        // ✅ Add new data to the allEmployees list
        allEmployees.addAll(seachdata.data);


        emit(HomepagetextformdatahaveIoaded(seachdata));
      } else {
        print(response.statusCode);

        emit(Homepagetextformdatahaveerror('Failed with code: ${response.statusCode}'));
      }
    } catch (e) {
      print(e);

      emit(Homepagetextformdatahaveerror('Error: ${e.toString()}'));
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
      final token = await ApiConstants.getTokenOnly(); // ✅ get actual token

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
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
  void clearPlanUsageCache() {
    cachedPlanUsage = null;
  }
  Future<void> postVisitedCount(String employeeId) async {
    final token = await ApiConstants.getTokenOnly(); // ✅ get actual token


    print("yes");
    print("Token: $token");
    print("Employee ID: $employeeId");

    final uri = Uri.parse("$baseurl/api/employer/employee-profile-access/");
    print("Posting to: $uri");

    try {
      final request = http.MultipartRequest("POST", uri);

      request.fields["employee_id"] = employeeId;
      request.headers["Authorization"] = "Bearer $token";

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

}
