import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'work_preference_event.dart';
import 'work_preference_state.dart';

class WorkPreferenceBloc
    extends Bloc<WorkPreferenceEvent, WorkPreferenceState> {
  final FlutterSecureStorage storage;

  WorkPreferenceBloc(this.storage) : super(const WorkPreferenceState()) {
    on<FetchWorkPreference>(_onFetchWorkPreference);
    on<UpdateWorkPreference>(_onUpdateWorkPreference);
  }

  Future<void> _onFetchWorkPreference(
      FetchWorkPreference event, Emitter<WorkPreferenceState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse(
            "${ApiConstants.baseUrl}api/employee/employee-work-preferences/"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          final pref = data[0];
          emit(state.copyWith(
            isLoading: false,
            id: pref["id"],
            selectedJobType: pref['interested_job_type']?.toString(),
            salaryRange: pref['expected_salary_range']?.toString(),
            selectedAvailability: pref['availability']?.toString(),
            selectedTransportationType:
                pref['transportation_availability']?.toString(),
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            errorMessage:
                "No work preferences found. Please set your preferences.",
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Failed to load preferences. Please try again later.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage:
            "Error loading preferences. Please check your connection.",
      ));
    }
  }

  Future<void> _onUpdateWorkPreference(
      UpdateWorkPreference event, Emitter<WorkPreferenceState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (event.jobType.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Please select a job type",
      ));
      return;
    }

    try {
      final token = await storage.read(key: 'access_token');

      final requestBody = {
        'interested_job_type': event.jobType,
        'expected_salary_range': event.salaryRange ?? '',
        'availability': event.availability,
        'transportation_availability': event.transportation,
      };

      final response = await http.put(
        Uri.parse(
            "${ApiConstants.baseUrl}api/employee/employee-work-preferences/?pk=${state.id}"),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          success: true,
        ));
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Failed to update preferences';

        if (errorData is Map && errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        } else if (errorData is Map) {
          errorMessage = errorData.entries
              .map((e) => '${e.key}: ${e.value.join(', ')}')
              .join('\n');
        }

        emit(state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Network error. Please check your connection.",
      ));
    }
  }
}
