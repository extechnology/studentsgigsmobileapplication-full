import 'package:anjalim/student_Section/models_std/employee_Profile/additional_info.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/addisional_info_function.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
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

  void _onUploadResume(UploadResume event, Emitter<AdditionalInfoState> emit) {
    emit(state.copyWith(
      resume: event.resume,
      isResumeUploaded: event.resume != null,
    ));
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
}
