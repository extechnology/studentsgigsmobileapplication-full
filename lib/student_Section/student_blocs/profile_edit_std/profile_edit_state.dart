part of 'profile_edit_bloc.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileEditLoading extends ProfileEditState {}

class ProfileEditUploading extends ProfileEditState {
  final EmployeeProfile? profileData;
  final List<dynamic> jobTitles;

  const ProfileEditUploading({
    this.profileData,
    required this.jobTitles,
  });

  @override
  List<Object> get props => [jobTitles];
}

class ProfileEditLoaded extends ProfileEditState {
  final EmployeeProfile? profileData;
  final List<dynamic> jobTitles;
  final bool showSuccess;
  final String? successMessage;

  const ProfileEditLoaded({
    this.profileData,
    required this.jobTitles,
    this.showSuccess = false,
    this.successMessage,
  });

  @override
  List<Object> get props => [jobTitles, showSuccess];
}

class ProfileEditPermissionRequired extends ProfileEditState {
  final EmployeeProfile? profileData;
  final List<dynamic> jobTitles;
  final bool isProfileImage;
  final BuildContext context;
  final PickImage originalPickEvent;

  const ProfileEditPermissionRequired({
    this.profileData,
    required this.jobTitles,
    required this.isProfileImage,
    required this.context,
    required this.originalPickEvent, // Add this line
  });

  @override
  List<Object> get props => [jobTitles, isProfileImage];
}

class ProfileEditLocationSuggestions extends ProfileEditState {
  final List<String> locations;
  final EmployeeProfile? profileData;
  final List<dynamic> jobTitles;

  const ProfileEditLocationSuggestions({
    required this.locations,
    this.profileData,
    required this.jobTitles,
  });

  @override
  List<Object> get props => [locations, jobTitles];
}

class ProfileEditError extends ProfileEditState {
  final String error;

  const ProfileEditError({required this.error});

  @override
  List<Object> get props => [error];
}
