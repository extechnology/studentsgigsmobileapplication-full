part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class JobTitlesLoading extends SearchState {}

class JobTitlesLoaded extends SearchState {
  final List<String> jobTitles;

  const JobTitlesLoaded(this.jobTitles);

  @override
  List<Object> get props => [jobTitles];
}

class SearchLoading extends SearchState {}

class SearchLoadingWithJobTitles extends SearchState {
  final List<String> jobTitles;

  const SearchLoadingWithJobTitles(this.jobTitles);

  @override
  List<Object> get props => [jobTitles];
}

class SearchSuccessWithJobTitles extends SearchState {
  final List<dynamic> searchResults;
  final List<String> jobTitles;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const SearchSuccessWithJobTitles({
    required this.searchResults,
    required this.jobTitles,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  SearchSuccessWithJobTitles copyWith({
    List<dynamic>? searchResults,
    List<String>? jobTitles,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchSuccessWithJobTitles(
      searchResults: searchResults ?? this.searchResults,
      jobTitles: jobTitles ?? this.jobTitles,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
        searchResults,
        jobTitles,
        currentPage,
        hasMore,
        isLoadingMore,
      ];
}

class SearchSuccess extends SearchState {
  final List<dynamic> searchResults;
  final String? selectJobTitle;
  final String? selectedLocation;
  final String? selectedSalaryType;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const SearchSuccess({
    required this.searchResults,
    this.selectJobTitle,
    this.selectedLocation,
    this.selectedSalaryType,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  SearchSuccess copyWith({
    List<dynamic>? searchResults,
    String? selectJobTitle,
    String? selectedLocation,
    String? selectedSalaryType,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchSuccess(
      searchResults: searchResults ?? this.searchResults,
      selectJobTitle: selectJobTitle ?? this.selectJobTitle,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedSalaryType: selectedSalaryType ?? this.selectedSalaryType,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        searchResults,
        selectJobTitle,
        selectedLocation,
        selectedSalaryType,
        currentPage,
        hasMore,
        isLoadingMore,
      ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
