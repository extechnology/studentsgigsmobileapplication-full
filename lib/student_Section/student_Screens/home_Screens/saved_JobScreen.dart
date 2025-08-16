import 'package:anjalim/student_Section/custom_widgets/dateformating.dart';
import 'package:anjalim/student_Section/custom_widgets/jobcard.dart';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/student_blocs/saved_job/saved_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/saved_job/saved_event.dart';
import 'package:anjalim/student_Section/student_blocs/saved_job/saved_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedJobScreen extends StatelessWidget {
  const SavedJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedJobBloc(
        jobService: JobService(),
      )..add(LoadSavedJobs()),
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        appBar: AppBar(
          backgroundColor: const Color(0xffF9F2ED),
          title: const Text(
            "Saved Gigs",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<SavedJobBloc>().add(LoadSavedJobs());
              },
              icon: const Icon(
                Icons.refresh,
                color: Color(0xffEB8125),
              ),
              tooltip: 'Refresh saved jobs',
            ),
          ],
        ),
        body: const _SavedJobView(),
      ),
    );
  }
}

class _SavedJobView extends StatelessWidget {
  const _SavedJobView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SavedJobBloc, SavedJobState>(
            builder: (context, state) {
              if (state is SavedJobLoaded && state.savedJobs.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "${state.savedJobs.length} saved ${state.savedJobs.length == 1 ? 'job' : 'jobs'}",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: BlocConsumer<SavedJobBloc, SavedJobState>(
              listener: (context, state) {
                if (state is SavedJobError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is SavedJobInitial || state is SavedJobLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xffEB8125)),
                        SizedBox(height: 16),
                        Text(
                          "Loading saved jobs...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is SavedJobError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SavedJobBloc>().add(LoadSavedJobs());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffEB8125),
                          ),
                          child: const Text(
                            "Retry",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is SavedJobLoaded) {
                  if (state.savedJobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "No saved jobs yet",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Save jobs you're interested in to view them here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.savedJobs.length,
                    itemBuilder: (context, index) {
                      final job = state.savedJobs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "GigsDetailScreen",
                                arguments: {"jobData": job});
                          },
                          child: JobCard(
                            id: job['id'].toString(),
                            jobType: job['job_type'] ?? 'Unknown',
                            position: job['job_title'] ?? 'No Title',
                            timeAgo: formatPostedDate(job['posted_date']),
                            salary: job['pay_structure'] ?? 'Not specified',
                            salaryType: job['salary_type'] ?? '',
                            applied: job['applied'] ?? false,
                            logo: job['company']?['logo'] ?? '',
                            company: job['company']?['company_name'] ??
                                'Unknown Company',
                            location: job['job_location'] ?? 'Remote',
                            employerId: job['company']?['id']?.toString() ?? '',
                            saved: true,
                            isLoading: false,
                            onSave: () {
                              final jobBloc = context.read<SavedJobBloc>();
                              final currentJobs =
                                  (jobBloc.state as SavedJobLoaded).savedJobs;
                              final jobIndex = currentJobs
                                  .indexWhere((j) => j['id'] == job['id']);

                              // Store the job for undo
                              final jobToUndo = currentJobs[jobIndex];

                              // First remove the job
                              jobBloc.add(ToggleSaveJob(job));

                              // Show undo snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Job removed from saved jobs'),
                                  duration: const Duration(seconds: 4),
                                  // action: SnackBarAction(
                                  //   label: 'Undo',
                                  //   onPressed: () {
                                  //     // Re-add the job by toggling again
                                  //     jobBloc.add(ToggleSaveJob(jobToUndo));

                                  //     // Show confirmation
                                  //     ScaffoldMessenger.of(context)
                                  //         .showSnackBar(
                                  //       const SnackBar(
                                  //         content: Text(
                                  //             'Job restored to saved jobs'),
                                  //         duration: Duration(seconds: 1),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: Text(
                    "Unknown state",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
