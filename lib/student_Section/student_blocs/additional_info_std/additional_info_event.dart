part of 'additional_info_bloc.dart';

abstract class AdditionalInfoEvent extends Equatable {
  const AdditionalInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadAdditionalInfo extends AdditionalInfoEvent {}

class AddHobby extends AdditionalInfoEvent {
  final String hobby;

  const AddHobby(this.hobby);

  @override
  List<Object> get props => [hobby];
}

class RemoveHobby extends AdditionalInfoEvent {
  final String hobby;

  const RemoveHobby(this.hobby);

  @override
  List<Object> get props => [hobby];
}

class UpdateReferences extends AdditionalInfoEvent {
  final String references;

  const UpdateReferences(this.references);

  @override
  List<Object> get props => [references];
}

class UpdateRelocationPreference extends AdditionalInfoEvent {
  final String? relocate;

  const UpdateRelocationPreference(this.relocate);

  @override
  List<Object> get props => [relocate ?? ''];
}

class UploadResume extends AdditionalInfoEvent {
  final FilePickerResult? resume;
  final BuildContext? context; // Added context for permission handling

  const UploadResume(this.resume, {this.context});

  @override
  List<Object> get props => [resume ?? '', context ?? ''];
}

class SaveAdditionalInfo extends AdditionalInfoEvent {}

class ViewResume extends AdditionalInfoEvent {
  final bool isLocalFile;

  const ViewResume(this.isLocalFile);

  @override
  List<Object> get props => [isLocalFile];
}

class RequestResumePermission extends AdditionalInfoEvent {
  final BuildContext context;

  const RequestResumePermission(this.context);

  @override
  List<Object> get props => [context];
}

class ResumePermissionRequired extends AdditionalInfoEvent {
  final BuildContext context;

  const ResumePermissionRequired(this.context);

  @override
  List<Object> get props => [context];
}
