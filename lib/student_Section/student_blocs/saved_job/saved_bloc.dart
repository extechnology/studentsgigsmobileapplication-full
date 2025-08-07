import 'dart:async';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/student_blocs/saved_job/saved_event.dart';
import 'package:anjalim/student_Section/student_blocs/saved_job/saved_state.dart';
import 'package:bloc/bloc.dart';

class SavedJobBloc extends Bloc<SavedJobEvent, SavedJobState> {
  final JobService _jobService;

  SavedJobBloc({required JobService jobService})
      : _jobService = jobService,
        super(SavedJobInitial()) {
    on<LoadSavedJobs>(_onLoadSavedJobs);
    on<ToggleSaveJob>(_onToggleSaveJob);
  }

  Future<void> _onLoadSavedJobs(
    LoadSavedJobs event,
    Emitter<SavedJobState> emit,
  ) async {
    emit(SavedJobLoading());
    try {
      final savedJobs = await _jobService.fetchSavedJobs();
      emit(SavedJobLoaded(savedJobs: savedJobs));
    } catch (e) {
      emit(SavedJobError(message: 'Failed to load saved jobs'));
    }
  }

  Future<void> _onToggleSaveJob(
    ToggleSaveJob event,
    Emitter<SavedJobState> emit,
  ) async {
    if (state is SavedJobLoaded) {
      final currentState = state as SavedJobLoaded;
      final job = event.job;
      final jobId = job['id'].toString();
      final jobType = job['job_type'] ?? 'Unknown';
      final isCurrentlySaved = job['saved_job'] ?? true;

      // Store the original state for potential undo
      final originalJobs = currentState.savedJobs;

      // Optimistic update - remove the job
      final updatedJobs =
          List<Map<String, dynamic>>.from(currentState.savedJobs)
            ..removeWhere((savedJob) => savedJob['id'] == job['id']);
      emit(SavedJobLoaded(savedJobs: updatedJobs));

      try {
        await _jobService.toggleSaveJob(
          jobId: jobId,
          jobType: jobType,
          isCurrentlySaved: isCurrentlySaved,
        );

        // After successful API call, we could reload or keep the optimistic update
        // For better consistency, let's reload the saved jobs
        add(LoadSavedJobs());
      } catch (e) {
        // Revert to original state on error
        emit(SavedJobLoaded(savedJobs: originalJobs));
        rethrow;
      }
    }
  }
}
