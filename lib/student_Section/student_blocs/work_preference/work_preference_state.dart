import 'package:equatable/equatable.dart';

class WorkPreferenceState extends Equatable {
  final bool isLoading;
  final String? selectedJobType;
  final String? selectedAvailability;
  final String? selectedTransportationType;
  final String? salaryRange;
  final int? id;
  final String? errorMessage;
  final bool success;

  const WorkPreferenceState({
    this.isLoading = false,
    this.selectedJobType,
    this.selectedAvailability,
    this.selectedTransportationType,
    this.salaryRange,
    this.id,
    this.errorMessage,
    this.success = false,
  });

  WorkPreferenceState copyWith({
    bool? isLoading,
    String? selectedJobType,
    String? selectedAvailability,
    String? selectedTransportationType,
    String? salaryRange,
    int? id,
    String? errorMessage,
    bool? success,
  }) {
    return WorkPreferenceState(
      isLoading: isLoading ?? this.isLoading,
      selectedJobType: selectedJobType ?? this.selectedJobType,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
      selectedTransportationType:
          selectedTransportationType ?? this.selectedTransportationType,
      salaryRange: salaryRange ?? this.salaryRange,
      id: id ?? this.id,
      errorMessage: errorMessage,
      success: success ?? false,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedJobType,
        selectedAvailability,
        selectedTransportationType,
        salaryRange,
        id,
        errorMessage,
        success
      ];
}
