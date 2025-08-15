import 'dart:async';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/services/singlesearch.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService _searchService;

  SearchBloc(this._searchService) : super(SearchInitial()) {
    on<FetchJobTitlesEvent>(_onFetchJobTitles);
    on<FetchInitialJobsEvent>(_onFetchInitialJobs);
    on<SearchJobsEvent>(_onSearchJobs);
    on<FetchMoreJobsEvent>(_onFetchMoreJobs);
    on<ToggleSaveJobEvent>(_onToggleSaveJob);
    on<SelectJobTitleEvent>(_onSelectJobTitle);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onFetchJobTitles(
    FetchJobTitlesEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(JobTitlesLoading());
    try {
      final jobTitles = await _searchService.fetchJobTitleView();
      emit(JobTitlesLoaded(jobTitles));

      // After loading job titles, automatically load all jobs
      add(FetchInitialJobsEvent());
    } catch (e) {
      emit(SearchError('Failed to load job titles: ${e.toString()}'));
    }
  }

  Future<void> _onFetchInitialJobs(
    FetchInitialJobsEvent event,
    Emitter<SearchState> emit,
  ) async {
    // Don't emit loading if we already have job titles loaded
    if (state is! JobTitlesLoaded) {
      emit(SearchLoading());
    } else {
      // Emit a loading state that preserves job titles
      emit(SearchLoadingWithJobTitles((state as JobTitlesLoaded).jobTitles));
    }

    try {
      final response = await _searchService.fetchSearchValue(
        null, // No job title filter - get all jobs
        null, // No location filter
        null, // No salary type filter
        1, // First page
      );

      if (response != null) {
        final jobTitles = state is JobTitlesLoaded
            ? (state as JobTitlesLoaded).jobTitles
            : state is SearchLoadingWithJobTitles
                ? (state as SearchLoadingWithJobTitles).jobTitles
                : <String>[];

        emit(SearchSuccessWithJobTitles(
          searchResults: response['data'] ?? [],
          jobTitles: jobTitles,
          currentPage: 1,
          hasMore: 1 < (response['total_pages'] ?? 1),
        ));
      }
    } catch (e) {
      emit(SearchError('Error loading jobs: ${e.toString()}'));
    }
  }

  Future<void> _onSearchJobs(
    SearchJobsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.resetPagination) {
      emit(SearchLoading());
    }

    try {
      final page = event.resetPagination
          ? 1
          : (state is SearchSuccess
              ? (state as SearchSuccess).currentPage + 1
              : 1);

      final response = await _searchService.fetchSearchValue(
        event.selectJobTitle,
        event.selectedLocation,
        event.selectedSalaryType,
        page,
      );

      if (response != null) {
        final newResults = response['data'] ?? [];
        final totalPages = response['total_pages'] ?? 1;

        if (event.resetPagination || state is! SearchSuccess) {
          emit(SearchSuccess(
            searchResults: newResults,
            selectJobTitle: event.selectJobTitle,
            selectedLocation: event.selectedLocation,
            selectedSalaryType: event.selectedSalaryType,
            currentPage: page,
            hasMore: page < totalPages,
          ));
        } else {
          final currentState = state as SearchSuccess;
          emit(currentState.copyWith(
            searchResults: [...currentState.searchResults, ...newResults],
            currentPage: page,
            hasMore: page < totalPages,
            isLoadingMore: false,
          ));
        }
      }
    } catch (e) {
      emit(SearchError('Error searching jobs: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoreJobs(
    FetchMoreJobsEvent event,
    Emitter<SearchState> emit,
  ) async {
    SearchState currentState = state;

    // Handle both SearchSuccess and SearchSuccessWithJobTitles
    List<dynamic> currentResults = [];
    int currentPage = 1;
    bool hasMore = true;
    List<String> jobTitles = [];
    String? selectJobTitle;
    String? selectedLocation;
    String? selectedSalaryType;

    if (currentState is SearchSuccess) {
      currentResults = currentState.searchResults;
      currentPage = currentState.currentPage;
      hasMore = currentState.hasMore;
      selectJobTitle = currentState.selectJobTitle;
      selectedLocation = currentState.selectedLocation;
      selectedSalaryType = currentState.selectedSalaryType;
    } else if (currentState is SearchSuccessWithJobTitles) {
      currentResults = currentState.searchResults;
      currentPage = currentState.currentPage;
      hasMore = currentState.hasMore;
      jobTitles = currentState.jobTitles;
    }

    if (!hasMore) return;

    // Update loading state
    if (currentState is SearchSuccessWithJobTitles) {
      emit((currentState as SearchSuccessWithJobTitles)
          .copyWith(isLoadingMore: true));
    } else if (currentState is SearchSuccess) {
      emit((currentState as SearchSuccess).copyWith(isLoadingMore: true));
    }

    try {
      final response = await _searchService.fetchSearchValue(
        selectJobTitle,
        selectedLocation,
        selectedSalaryType,
        currentPage + 1,
      );

      if (response != null) {
        final newResults = response['data'] ?? [];
        final totalPages = response['total_pages'] ?? 1;

        if (currentState is SearchSuccessWithJobTitles) {
          emit((currentState as SearchSuccessWithJobTitles).copyWith(
            searchResults: [...currentResults, ...newResults],
            currentPage: currentPage + 1,
            hasMore: (currentPage + 1) < totalPages,
            isLoadingMore: false,
          ));
        } else if (currentState is SearchSuccess) {
          emit((currentState as SearchSuccess).copyWith(
            searchResults: [...currentResults, ...newResults],
            currentPage: currentPage + 1,
            hasMore: (currentPage + 1) < totalPages,
            isLoadingMore: false,
          ));
        }
      }
    } catch (e) {
      if (currentState is SearchSuccessWithJobTitles) {
        emit((currentState as SearchSuccessWithJobTitles)
            .copyWith(isLoadingMore: false));
      } else if (currentState is SearchSuccess) {
        emit((currentState as SearchSuccess).copyWith(isLoadingMore: false));
      }
      emit(SearchError('Error loading more jobs: ${e.toString()}'));
    }
  }

  Future<void> _onToggleSaveJob(
    ToggleSaveJobEvent event,
    Emitter<SearchState> emit,
  ) async {
    SearchState currentState = state;

    try {
      final jobId = event.job['id'].toString();
      final jobType = event.job['job_type'] ?? 'Unknown';
      final isCurrentlySaved = event.job['saved_job'] ?? false;

      await JobService().toggleSaveJob(
        jobId: jobId,
        jobType: jobType,
        isCurrentlySaved: isCurrentlySaved,
      );

      // Handle both state types
      if (currentState is SearchSuccess) {
        final updatedResults = currentState.searchResults.map((job) {
          if (job['id'] == event.job['id']) {
            return {...job, 'saved_job': !isCurrentlySaved};
          }
          return job;
        }).toList();

        emit(currentState.copyWith(searchResults: updatedResults));
      } else if (currentState is SearchSuccessWithJobTitles) {
        final updatedResults = currentState.searchResults.map((job) {
          if (job['id'] == event.job['id']) {
            return {...job, 'saved_job': !isCurrentlySaved};
          }
          return job;
        }).toList();

        emit(currentState.copyWith(searchResults: updatedResults));
      }
    } catch (e) {
      emit(SearchError('Failed to update save status'));
    }
  }

  void _onSelectJobTitle(
    SelectJobTitleEvent event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchSuccess) {
      emit((state as SearchSuccess).copyWith(selectJobTitle: event.jobTitle));
    }
  }

  void _onClearFilters(
    ClearFiltersEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
