import 'package:anjalim/student_Section/models_std/employee_Profile/education_info.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/education_Details_Ui/educationalInformationAdd.dart';
import 'package:anjalim/student_Section/student_blocs/education_section_std/education_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EducationBloc()..add(LoadEducationDetails()),
      child: const EducationPageContent(),
    );
  }
}

class EducationPageContent extends StatelessWidget {
  const EducationPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          if (state is EducationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EducationError) {
            return Center(child: Text(state.message));
          } else if (state is EducationLoaded) {
            if (state.educations.isEmpty) {
              return _buildEmptyState(context);
            }
            return EducationListScreen(educations: state.educations);
          } else if (state is EducationOperationSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<EducationBloc>().add(LoadEducationDetails());
            });
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No Education Details Found'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff004673),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _navigateToAddPage(context),
            child: const Text(
              'Add Education',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddPage(BuildContext context) async {
    // Get the bloc instance before navigation
    final educationBloc = BlocProvider.of<EducationBloc>(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<EducationBloc>.value(
          value: educationBloc,
          child: const EducationAddPage(),
        ),
      ),
    );

    if (result == true && context.mounted) {
      educationBloc.add(LoadEducationDetails());
    }
  }
}

class EducationListScreen extends StatelessWidget {
  final List<EducationDetail> educations;

  const EducationListScreen({Key? key, required this.educations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F2ED),
        title: const Text(
          'Education Details',
          style: TextStyle(fontFamily: "Poppins", fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddPage(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: educations.length,
          itemBuilder: (context, index) {
            final education = educations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EducationCard(education: education),
            );
          },
        ),
      ),
    );
  }

  void _navigateToAddPage(BuildContext context) async {
    // Get the bloc instance before navigation
    final educationBloc = BlocProvider.of<EducationBloc>(context);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<EducationBloc>.value(
          value: educationBloc,
          child: const EducationAddPage(),
        ),
      ),
    );

    if (result == true && context.mounted) {
      educationBloc.add(LoadEducationDetails());
    }
  }
}

class EducationCard extends StatelessWidget {
  final EducationDetail education;

  const EducationCard({Key? key, required this.education}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    education.institution,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever_outlined,
                      color: Color(0xffFF0000)),
                  onPressed: () {
                    context
                        .read<EducationBloc>()
                        .add(DeleteEducationDetail(education.id));
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.menu_book_outlined, education.fieldOfStudy,
                Colors.blue.shade400),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.calendar_today, education.graduationYear,
                Colors.orange.shade400),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.star_outlined, education.academicLevel,
                Colors.amber.shade600),
            if (education.achievement.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow(Icons.workspace_premium_outlined,
                  education.achievement, Colors.yellow.shade700),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
