import 'dart:io';
import 'package:anjalim/student_Section/models_std/employee_Profile/employeeProfileImages.dart';
import 'package:anjalim/student_Section/services/employee_detailsFeatching.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/jobTitleFeatch.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/prefered_locationfeatching.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/profile_Update.dart';
import 'package:anjalim/student_Section/services/student_Imageupload.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/updateprofile.dart';
import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final EmployeeServices _employeeService;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  ProfileEditBloc(this._employeeService) : super(ProfileEditInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<PickImage>(_onPickImage);
    on<RetryImagePicking>(_onRetryImagePicking);
    on<UpdateProfile>(_onUpdateProfile);
    on<SelectDate>(_onSelectDate);
    on<SearchLocation>(_onSearchLocation);
    on<UpdateFormField>(_onUpdateFormField);
  }

  final TextEditingController user_Name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone_Number = TextEditingController();
  final TextEditingController work_Hours = TextEditingController();
  final TextEditingController portfolio = TextEditingController();
  final TextEditingController loacation = TextEditingController();
  final TextEditingController job_Title = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController dateOfbirth = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  CountryCode selectedCountryCode = CountryCode.fromCountryCode('IN');
  String? selectedGender;
  String? selectedLoc;
  String? selectedJobTitle;
  List<dynamic> jobTitles = [];
  EmployeeProfile? _profileData;
  File? _selectedProfileImage;
  File? _selectedCoverImage;

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(ProfileEditLoading());
    try {
      final profile = await _employeeService.fetchEmployeeDetails();

      user_Name.text = profile.name;
      email.text = profile.email;
      _parsePhoneNumber(profile.phone);
      work_Hours.text = profile.availableWorkHours;
      portfolio.text = profile.portfolio;
      loacation.text = profile.preferredWorkLocation;
      selectedJobTitle = profile.jobTitle;
      about.text = profile.about ?? '';

      if (profile.gender != null) {
        String genderValue = profile.gender!.trim();
        if (genderValue == "Male" || genderValue == "Female") {
          selectedGender = genderValue;
        } else {
          if (genderValue.toLowerCase() == "male") {
            selectedGender = "Male";
          } else if (genderValue.toLowerCase() == "female") {
            selectedGender = "Female";
          } else {
            selectedGender = null;
          }
        }
      } else {
        selectedGender = null;
      }

      if (profile.dateOfBirth != null) {
        final dob = DateTime.parse(profile.dateOfBirth!);
        dateOfbirth.text = "${dob.day}-${dob.month}-${dob.year}";
        _calculateAge(dob);
      } else if (profile.age != null) {
        ageController.text = profile.age.toString();
      }

      jobTitles = await jobTitleView();
      _profileData = await fetchEmployeeProfile();

      emit(ProfileEditLoaded(
        profileData: _profileData,
        jobTitles: jobTitles,
      ));
    } catch (e) {
      emit(ProfileEditError(error: e.toString()));
    }
  }

  void _parsePhoneNumber(String fullPhoneNumber) {
    if (fullPhoneNumber.startsWith('+')) {
      final allCountryCodes = codes
          .map((c) => CountryCode.fromJson(c))
          .toList()
          .cast<CountryCode>();

      allCountryCodes
          .sort((a, b) => b.dialCode!.length.compareTo(a.dialCode!.length));

      for (final code in allCountryCodes) {
        if (fullPhoneNumber.startsWith(code.dialCode!)) {
          selectedCountryCode = code;
          phone_Number.text = fullPhoneNumber.substring(code.dialCode!.length);
          return;
        }
      }
    }
    phone_Number.text = fullPhoneNumber;
  }

  String _getFullPhoneNumber() {
    return selectedCountryCode.dialCode! + phone_Number.text;
  }

  void _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    ageController.text = age.toString();
  }

  Future<void> _onPickImage(
    PickImage event,
    Emitter<ProfileEditState> emit,
  ) async {
    try {
      emit(ProfileEditUploading(
        profileData: _profileData,
        jobTitles: jobTitles,
      ));

      final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (returnedImage != null) {
        final pickedImage = File(returnedImage.path);

        if (event.isProfileImage) {
          _selectedProfileImage = pickedImage;
          await ImageUploadFunction(_selectedProfileImage!, event.context);
        } else {
          _selectedCoverImage = pickedImage;
          await CoverPicUploadFunction(_selectedCoverImage!);
        }

        _profileData = await fetchEmployeeProfile();
        emit(ProfileEditLoaded(
          profileData: _profileData,
          jobTitles: jobTitles,
          showSuccess: true,
          successMessage: 'Image uploaded successfully!',
        ));
      } else {
        emit(ProfileEditLoaded(
          profileData: _profileData,
          jobTitles: jobTitles,
        ));
      }
    } catch (e) {
      emit(ProfileEditError(error: 'Failed to upload image: $e'));
    }
  }

//

  /// Handle the actual image upload after permission is granted
  Future<void> _handleImageUpload(
    PickImage event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(ProfileEditUploading(
      profileData: _profileData,
      jobTitles: jobTitles,
    ));

    try {
      final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (returnedImage != null) {
        final pickedImage = File(returnedImage.path);

        if (event.isProfileImage) {
          _selectedProfileImage = pickedImage;
          await ImageUploadFunction(_selectedProfileImage!, event.context);
        } else {
          _selectedCoverImage = pickedImage;
          await CoverPicUploadFunction(_selectedCoverImage!);
        }

        // Reload profile data after upload
        _profileData = await fetchEmployeeProfile();
        emit(ProfileEditLoaded(
          profileData: _profileData,
          jobTitles: jobTitles,
          showSuccess: true,
          successMessage: 'Image uploaded successfully!',
        ));
      } else {
        emit(ProfileEditLoaded(
          profileData: _profileData,
          jobTitles: jobTitles,
        ));
      }
    } catch (e) {
      emit(ProfileEditError(
        error: 'Failed to upload image: ${e.toString()}',
      ));
    }
  }

  /// Handle retry image picking event
  Future<void> _onRetryImagePicking(
    RetryImagePicking event,
    Emitter<ProfileEditState> emit,
  ) async {
    await _onPickImage(event.originalEvent, emit);
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileEditState> emit,
  ) async {
    // First emit loading state
    emit(ProfileEditLoading());

    try {
      // Parse and prepare all the data
      final dob = dateOfbirth.text.isNotEmpty
          ? DateFormatter.displayToApi(dateOfbirth.text)
          : '';

      final age = ageController.text.isNotEmpty
          ? int.tryParse(ageController.text) ?? 0
          : 0;

      final gender = selectedGender ?? "";
      final jobTitle = selectedJobTitle ?? "";
      final fullPhoneNumber = _getFullPhoneNumber();

      // Call the update function
      await updateEmployee(
        event.context,
        about.text,
        user_Name.text,
        email.text,
        fullPhoneNumber,
        loacation.text,
        portfolio.text,
        jobTitle,
        age,
        work_Hours.text,
        gender,
        dob,
      );

      // After successful update, emit loaded state with success message
      emit(ProfileEditLoaded(
        profileData: _profileData,
        jobTitles: jobTitles,
        showSuccess: true,
        successMessage: 'Profile updated successfully!',
      ));
    } catch (e) {
      // If there's an error, emit error state
      emit(ProfileEditError(
        error: 'Failed to update profile: ${e.toString()}',
      ));

      // Also show error in UI
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<ProfileEditState> emit,
  ) async {
    DateTime? initialDate;

    if (dateOfbirth.text.isNotEmpty &&
        DateFormatter.isValidDisplayDate(dateOfbirth.text)) {
      final parts = dateOfbirth.text.split('-');
      initialDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    final DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfbirth.text = '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
      _calculateAge(picked);
      emit(ProfileEditLoaded(
        profileData: _profileData,
        jobTitles: jobTitles,
      ));
    }
  }

  Future<void> _onSearchLocation(
    SearchLocation event,
    Emitter<ProfileEditState> emit,
  ) async {
    if (event.query.length >= 2) {
      final locations = await preferedLocation(event.query);
      emit(ProfileEditLocationSuggestions(
        locations: locations.toList(),
        profileData: _profileData,
        jobTitles: jobTitles,
      ));
    }
  }

  void _onUpdateFormField(
    UpdateFormField event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(ProfileEditLoaded(
      profileData: _profileData,
      jobTitles: jobTitles,
    ));
  }

  /// Clean up controllers
  @override
  Future<void> close() {
    user_Name.dispose();
    email.dispose();
    phone_Number.dispose();
    work_Hours.dispose();
    portfolio.dispose();
    loacation.dispose();
    job_Title.dispose();
    about.dispose();
    dateOfbirth.dispose();
    ageController.dispose();
    return super.close();
  }
}
