part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchJobTitlesEvent extends SearchEvent {}

class FetchInitialJobsEvent extends SearchEvent {}

class SearchJobsEvent extends SearchEvent {
  final String? selectJobTitle;
  final String? selectedLocation;
  final String? selectedSalaryType;
  final bool resetPagination;

  const SearchJobsEvent({
    this.selectJobTitle,
    this.selectedLocation,
    this.selectedSalaryType,
    this.resetPagination = true,
  });

  @override
  List<Object?> get props => [
        selectJobTitle,
        selectedLocation,
        selectedSalaryType,
        resetPagination,
      ];
}

class FetchMoreJobsEvent extends SearchEvent {}

class ToggleSaveJobEvent extends SearchEvent {
  final Map<String, dynamic> job;

  const ToggleSaveJobEvent(this.job);

  @override
  List<Object> get props => [job];
}

class SelectJobTitleEvent extends SearchEvent {
  final String? jobTitle;

  const SelectJobTitleEvent(this.jobTitle);

  @override
  List<Object?> get props => [jobTitle];
}

class ClearFiltersEvent extends SearchEvent {}
