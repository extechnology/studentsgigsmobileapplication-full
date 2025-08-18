import 'dart:io';
import 'package:anjalim/student_Section/models_std/employee_Profile/additional_info.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/addisional_info_function.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

part 'additional_info_event.dart';
part 'additional_info_state.dart';

class AdditionalInfoBloc
    extends Bloc<AdditionalInfoEvent, AdditionalInfoState> {
  AdditionalInfoBloc() : super(const AdditionalInfoState()) {
    on<LoadAdditionalInfo>(_onLoadAdditionalInfo);
    on<AddHobby>(_onAddHobby);
    on<RemoveHobby>(_onRemoveHobby);
    on<UpdateReferences>(_onUpdateReferences);
    on<UpdateRelocationPreference>(_onUpdateRelocationPreference);
    on<UploadResume>(_onUploadResume);
    on<SaveAdditionalInfo>(_onSaveAdditionalInfo);
    on<ViewResume>(_onViewResume);
    on<RequestResumePermission>(_onRequestResumePermission);
    on<ResumePermissionRequired>(_onResumePermissionRequired);
  }

  Future<void> _onLoadAdditionalInfo(
    LoadAdditionalInfo event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    emit(state.copyWith(status: AdditionalInfoStatus.loading));
    try {
      final info = await fetchAdditionalInfo();
      emit(state.copyWith(
        status: AdditionalInfoStatus.success,
        additionalInfo: info,
        hobbies: info.hobbies ?? [],
        references: info.testimonials ?? '',
        relocate: info.willingToRelocate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdditionalInfoStatus.failure,
        errorMessage: 'Failed to load: ${e.toString()}',
      ));
    }
  }

  void _onAddHobby(AddHobby event, Emitter<AdditionalInfoState> emit) {
    if (event.hobby.trim().isNotEmpty) {
      final updatedHobbies = List<String>.from(state.hobbies)..add(event.hobby);
      emit(state.copyWith(hobbies: updatedHobbies));
    }
  }

  void _onRemoveHobby(RemoveHobby event, Emitter<AdditionalInfoState> emit) {
    final updatedHobbies = List<String>.from(state.hobbies)
      ..remove(event.hobby);
    emit(state.copyWith(hobbies: updatedHobbies));
  }

  void _onUpdateReferences(
      UpdateReferences event, Emitter<AdditionalInfoState> emit) {
    emit(state.copyWith(references: event.references));
  }

  void _onUpdateRelocationPreference(
      UpdateRelocationPreference event, Emitter<AdditionalInfoState> emit) {
    emit(state.copyWith(relocate: event.relocate));
  }

  Future<void> _onUploadResume(
    UploadResume event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    try {
      // Case 1: When triggered from UI (resume == null)
      if (event.resume == null && event.context != null) {
        // Check Android version
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final isAndroid13OrHigher = androidInfo.version.sdkInt >= 33;

        // Request appropriate permission
        PermissionStatus status;
        if (isAndroid13OrHigher) {
          status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            status = await Permission.manageExternalStorage.request();
          }
        } else {
          status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
        }

        if (status.isGranted) {
          // Try to pick file
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'pdf',
              'doc',
              'docx'
            ], // Added more document types
            allowMultiple: false,
            withData: true, // Important for some Android versions
          );

          if (result != null && result.files.isNotEmpty) {
            // Validate file size (e.g., 10MB limit)
            if (result.files.single.size > 10 * 1024 * 1024) {
              emit(state.copyWith(
                errorMessage: 'File size must be less than 10MB',
              ));
              return;
            }

            emit(state.copyWith(
              resume: result,
              isResumeUploaded: true,
              errorMessage: null, // Clear any previous errors
            ));
          }
        } else if (status.isPermanentlyDenied) {
          // Handle permanent denial
          add(ResumePermissionRequired(event.context!));
          emit(state.copyWith(
            errorMessage: 'Storage permission is permanently denied',
          ));
        } else {
          emit(state.copyWith(
            errorMessage: 'Storage permission is required',
          ));
        }
      }
      // Case 2: When file is already provided (resume != null)
      else if (event.resume != null) {
        emit(state.copyWith(
          resume: event.resume,
          isResumeUploaded: true,
          errorMessage: null, // Clear any previous errors
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to upload resume: ${e.toString()}',
      ));
      debugPrint('Resume upload error: $e');
    }
  }

  Future<void> _onSaveAdditionalInfo(
    SaveAdditionalInfo event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    emit(state.copyWith(status: AdditionalInfoStatus.loading));
    try {
      await postAdditionalInfo(
        resume: state.resume,
        id: state.additionalInfo?.id ?? 0,
        hobbies: state.hobbies,
        reference: state.references,
        relocate: state.relocate,
      );

      // Reload data after saving
      add(LoadAdditionalInfo());

      emit(state.copyWith(
        status: AdditionalInfoStatus.success,
        isResumeUploaded: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AdditionalInfoStatus.failure,
        errorMessage: 'Failed to save: ${e.toString()}',
      ));
    }
  }

  Future<void> _onViewResume(
    ViewResume event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    try {
      if (event.isLocalFile) {
        if (state.resume != null && state.resume!.files.single.path != null) {
          await OpenFile.open(state.resume!.files.single.path!);
        }
      } else {
        if (state.additionalInfo?.resume != null &&
            state.additionalInfo!.resume!.isNotEmpty) {
          final Uri url = Uri.parse(state.additionalInfo!.resume!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error opening file: ${e.toString()}'));
    }
  }

  Future<void> _onRequestResumePermission(
    RequestResumePermission event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final isAndroid13OrHigher = androidInfo.version.sdkInt >= 33;

    PermissionStatus status;
    if (isAndroid13OrHigher) {
      status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
    } else {
      status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      add(const UploadResume(null));
    } else if (status.isPermanentlyDenied) {
      add(ResumePermissionRequired(event.context));
    }
  }

  Future<void> _onResumePermissionRequired(
    ResumePermissionRequired event,
    Emitter<AdditionalInfoState> emit,
  ) async {
    // This would typically show a dialog in the UI layer
    // The actual dialog implementation should be in your widget
    emit(state.copyWith(
      errorMessage: 'Storage permission is required to upload resumes',
    ));
  }
}
