import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/student_blocs/popular_jobs/popular_event.dart';
import 'package:anjalim/student_Section/student_blocs/popular_jobs/popular_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final JobService _jobService;

  JobsBloc({required JobService jobService})
      : _jobService = jobService,
        super(JobsInitial()) {
    on<LoadPopularJobs>(_onLoadPopularJobs);
    on<ToggleSaveJob>(_onToggleSaveJob);
    on<RefreshJobs>(_onRefreshJobs);
  }

  Future<void> _onLoadPopularJobs(
    LoadPopularJobs event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      final jobs = await _jobService.fetchPopularJobs();
      emit(JobsLoaded(jobs: jobs));
    } catch (e) {
      emit(JobsError(message: e.toString()));
    }
  }

  Future<void> _onToggleSaveJob(
    ToggleSaveJob event,
    Emitter<JobsState> emit,
  ) async {
    if (state is JobsLoaded) {
      final currentState = state as JobsLoaded;
      try {
        await _jobService.toggleSaveJob(
            jobId: event.jobId,
            jobType: event.jobType,
            isCurrentlySaved: event.isCurrentlySaved);

        // Update the local state
        final updatedJobs = List<Map<String, dynamic>>.from(currentState.jobs);
        final jobIndex =
            updatedJobs.indexWhere((j) => j['id'].toString() == event.jobId);
        if (jobIndex != -1) {
          updatedJobs[jobIndex]['saved_job'] = !event.isCurrentlySaved;
        }

        emit(JobsLoaded(jobs: updatedJobs));
      } catch (e) {
        emit(JobsError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }

  Future<void> _onRefreshJobs(
    RefreshJobs event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());
    try {
      final jobs = await _jobService.fetchPopularJobs();
      emit(JobsLoaded(jobs: jobs));
    } catch (e) {
      emit(JobsError(message: e.toString()));
    }
  }
}
