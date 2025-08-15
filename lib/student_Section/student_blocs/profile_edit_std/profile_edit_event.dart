part of 'profile_edit_bloc.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileData extends ProfileEditEvent {}

class PickImage extends ProfileEditEvent {
  final bool isProfileImage;
  final BuildContext context;

  const PickImage({required this.isProfileImage, required this.context});

  @override
  List<Object> get props => [isProfileImage];
}

class UpdateProfile extends ProfileEditEvent {
  final BuildContext context;

  const UpdateProfile({required this.context});

  @override
  List<Object> get props => [];
}

class SelectDate extends ProfileEditEvent {
  final BuildContext context;

  const SelectDate({required this.context});

  @override
  List<Object> get props => [];
}

class SearchLocation extends ProfileEditEvent {
  final String query;

  const SearchLocation({required this.query});

  @override
  List<Object> get props => [query];
}

class UpdateFormField extends ProfileEditEvent {
  final String fieldName;
  final dynamic value;

  const UpdateFormField({required this.fieldName, required this.value});

  @override
  List<Object> get props => [fieldName, value];
}
