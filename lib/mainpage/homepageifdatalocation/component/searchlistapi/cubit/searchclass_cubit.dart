import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../../../datapage/datapage.dart';
import '../model/model.dart';

part 'searchclass_state.dart';

class SearchclassCubit extends Cubit<SearchclassState> {
  SearchclassCubit() : super(SearchclassInitial());

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];
  final String baseurl = ApiConstantsemployer.baseUrl;

  late StreamSubscription<InternetStatus> _connectionSubscription;
  bool isConnected = true;
  void _monitorConnection() async {
    // Immediate check on start
    isConnected = await InternetConnection().hasInternetAccess;
    if (!isConnected) {
      emit(SearchclassInitial());
    }

    // Listen for future changes
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      isConnected = (status == InternetStatus.connected);
      if (!isConnected) {
        emit(SearchclassInitial());
      }
    });
  }
  Future<void> getFunction() async {
    emit(SearchclassLoading());
    _monitorConnection();


    final url = "$baseurl/api/employer/category-and-title-view/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Related> data = relatedFromJson(response.body);

      allData = data.map((relatedItem) {
        return {
          "label": relatedItem.label,
          "value": relatedItem.value,
          "category": relatedItem.category,
          "id": relatedItem.id,
          "jobTitle": relatedItem.jobTitle,
          "talentCategory": relatedItem.talentCategory,
        };
      }).toList();

      filteredData = List.from(allData);
      emit(SearchclassLoaded(filteredData));
    } else {
      emit(SearchclassError("Failed to load data"));
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredData = List.from(allData);
    } else {
      filteredData = allData.where((item) {
        final label = (item['label'] ?? '').toString().toLowerCase();
        return label.contains(query.toLowerCase());
      }).toList();
    }
    emit(SearchclassLoaded(filteredData));
  }

  void onItemSelected(Map<String, dynamic> selectedItem) {
    searchController.text = selectedItem['label'] ?? '';
    search(searchController.text); // Refresh list if you want
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
