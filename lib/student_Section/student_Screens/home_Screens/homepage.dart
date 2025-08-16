import 'package:anjalim/student_Section/custom_widgets/dateformating.dart';
import 'package:anjalim/student_Section/custom_widgets/jobcard.dart';
import 'package:anjalim/student_Section/services/employee_detailsFeatching.dart';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/student_Screens/home_Screens/notificationshow.dart';
import 'package:anjalim/student_Section/student_blocs/employee/employee_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/employee/employee_event.dart';
import 'package:anjalim/student_Section/student_blocs/employee/employee_state.dart';
import 'package:anjalim/student_Section/student_blocs/popular_jobs/popular_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/popular_jobs/popular_event.dart';
import 'package:anjalim/student_Section/student_blocs/popular_jobs/popular_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeService = EmployeeServices();
    final jobService = JobService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeBloc(employeeService: employeeService)
            ..add(LoadEmployee()),
        ),
        BlocProvider(
          create: (context) =>
              JobsBloc(jobService: jobService)..add(LoadPopularJobs()),
        ),
      ],
      child: const _EmployeeHomeContent(),
    );
  }
}

class _EmployeeHomeContent extends StatefulWidget {
  const _EmployeeHomeContent();

  @override
  State<_EmployeeHomeContent> createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<_EmployeeHomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<JobsBloc>().add(RefreshJobs());
          return;
        },
        color: const Color(0xff004673),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),

            SliverToBoxAdapter(child: _buildSectionTitle()),

            // Jobs list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(child: _buildJobsList()),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        //debugPrint('Current Employee State: $state');
        String displayName = 'User';

        if (state is EmployeeLoaded) {
          //debugPrint('Employee name: ${state.employee.name}');
          displayName = state.employee.name;
        } else if (state is EmployeeError) {
          //debugPrint('Employee error: ${state.message}');
          displayName = 'User';
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, $displayName",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1E1D1D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff1E1D1D).withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFF9500).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xffFF9500),
                      size: 25,
                    ),
                    onPressed: () => showNotificationDialog(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.trending_up,
                    color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Popular Gigs",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xff004673),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return BlocBuilder<JobsBloc, JobsState>(
      builder: (context, state) {
        if (state is JobsLoading) {
          return _buildLoadingState();
        } else if (state is JobsError) {
          return _buildErrorState(state.message);
        } else if (state is JobsLoaded) {
          return _buildJobsListView(state.jobs);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xffEB8125),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Loading popular jobs...",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child:
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text(
              textAlign: TextAlign.center,
              "Oops! We couldn't load the jobs right now.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Please check your network availability.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<JobsBloc>().add(RefreshJobs()),
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEB8125),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.work_off, size: 50, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            Text(
              "No popular jobs available",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Check back later for new opportunities",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<JobsBloc>().add(RefreshJobs()),
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEB8125),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsListView(List<Map<String, dynamic>> jobs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        final company = job['company'] as Map<String, dynamic>?;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "GigsDetailScreen",
                  arguments: {"jobData": job});
            },
            child: JobCard(
              id: job['id']?.toString() ?? '',
              jobType: job['job_type'] ?? 'Unknown',
              position: job['job_title'] ?? 'No Title',
              timeAgo: formatPostedDate(job['posted_date']),
              salary: job['pay_structure'] ?? 'Not specified',
              salaryType: job['salary_type'] ?? '',
              applied: job['applied'] ?? false,
              logo: company?['logo'] ?? '',
              company: company?['company_name'] ?? 'Unknown Company',
              location: job['job_location'] ?? 'Remote',
              employerId: company?['id']?.toString() ?? '',
              saved: job['saved_job'] ?? false,
              isLoading: false,
              onSave: () => _handleSaveJob(job),
            ),
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _handleSaveJob(Map<String, dynamic> job) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Show saving indicator
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
              job['saved_job'] ? 'Removing from saved...' : 'Saving job...'),
          duration: const Duration(milliseconds: 500),
        ),
      );

      // Dispatch the save action
      context.read<JobsBloc>().add(
            ToggleSaveJob(
              jobId: job['id'].toString(),
              jobType: job['job_type'] ?? 'Unknown',
              isCurrentlySaved: job['saved_job'] ?? false,
            ),
          );
      context.read<JobsBloc>().add(RefreshJobs());

      // Show success message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text(job['saved_job'] ? 'Job removed' : 'Job saved successfully'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
