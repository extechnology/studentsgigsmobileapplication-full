part of 'additional_info_bloc.dart';

enum AdditionalInfoStatus { initial, loading, success, failure }

class AdditionalInfoState extends Equatable {
  final AdditionalInfoStatus status;
  final AdditionalInformations? additionalInfo;
  final List<String> hobbies;
  final String references;
  final String? relocate;
  final FilePickerResult? resume;
  final String? errorMessage;
  final bool isResumeUploaded;

  const AdditionalInfoState({
    this.status = AdditionalInfoStatus.initial,
    this.additionalInfo,
    this.hobbies = const [],
    this.references = '',
    this.relocate,
    this.resume,
    this.errorMessage,
    this.isResumeUploaded = false,
  });

  AdditionalInfoState copyWith({
    AdditionalInfoStatus? status,
    AdditionalInformations? additionalInfo,
    List<String>? hobbies,
    String? references,
    String? relocate,
    FilePickerResult? resume,
    String? errorMessage,
    bool? isResumeUploaded,
  }) {
    return AdditionalInfoState(
      status: status ?? this.status,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      hobbies: hobbies ?? this.hobbies,
      references: references ?? this.references,
      relocate: relocate ?? this.relocate,
      resume: resume ?? this.resume,
      errorMessage: errorMessage ?? this.errorMessage,
      isResumeUploaded: isResumeUploaded ?? this.isResumeUploaded,
    );
  }

  @override
  List<Object?> get props => [
        status,
        additionalInfo,
        hobbies,
        references,
        relocate,
        resume,
        errorMessage,
        isResumeUploaded,
      ];
}
