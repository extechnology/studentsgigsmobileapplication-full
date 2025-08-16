// education_bloc/education_bloc.dart
import 'dart:convert';
import 'package:anjalim/student_Section/models_std/employee_Profile/education_info.dart';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  EducationBloc() : super(EducationInitial()) {
    on<LoadEducationDetails>(_onLoadEducationDetails);
    on<AddEducationDetail>(_onAddEducationDetail);
    on<DeleteEducationDetail>(_onDeleteEducationDetail);
    on<LoadFieldsOfStudy>(_onLoadFieldsOfStudy);
    on<SearchUniversities>(_onSearchUniversities);
  }

  Future<void> _onLoadEducationDetails(
    LoadEducationDetails event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}api/employee/employee-education/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final educations =
            data.map((json) => EducationDetail.fromJson(json)).toList();
        emit(EducationLoaded(educations));
      } else {
        emit(EducationError('Failed to load education details'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> _onAddEducationDetail(
    AddEducationDetail event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}api/employee/employee-education/'),
        headers: await ApiConstants.headers,
        body: jsonEncode({
          "field_of_study": event.fieldOfStudy,
          "name_of_institution": event.institution,
          "expected_graduation_year": event.graduationYear,
          "academic_level": event.academicLevel,
          "achievement_name": event.achievement,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(EducationOperationSuccess('Education added successfully'));
        add(LoadEducationDetails());
      } else {
        emit(EducationError('Failed to add education'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> _onDeleteEducationDetail(
    DeleteEducationDetail event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());
    try {
      final response = await http.delete(
        Uri.parse(
            '${ApiConstants.baseUrl}api/employee/employee-education/${event.id}/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 204) {
        emit(EducationOperationSuccess('Education deleted successfully'));
        add(LoadEducationDetails());
      } else {
        emit(EducationError('Failed to delete education'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> _onLoadFieldsOfStudy(
    LoadFieldsOfStudy event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/employee/employee-field-of-study/'),
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final fields =
            data.map<String>((item) => item['value'].toString()).toList();
        emit(FieldsOfStudyLoaded(fields));
      } else {
        emit(EducationError('Failed to load fields of study'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }

  Future<void> _onSearchUniversities(
    SearchUniversities event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}api/employee/university/?name=${event.query}',
      );

      final response = await http.get(
        uri,
        headers: await ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final universities =
            data.map<String>((item) => item["name"].toString()).toList();
        emit(UniversitiesLoaded(universities));
      } else {
        emit(EducationError('Failed to load universities'));
      }
    } catch (e) {
      emit(EducationError(e.toString()));
    }
  }
}
