import 'package:anjalim/student_Section/models_std/employee_Profile/experiencemodel.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/experience_functions.dart';
import 'package:anjalim/student_Section/student_Screens/profile_Screens/Experience.dart/experience.dart';
import 'package:anjalim/student_Section/student_blocs/std_wrk_experience/experience_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShowExperience extends StatefulWidget {
  const ShowExperience({super.key});

  @override
  State<ShowExperience> createState() => _ShowExperienceState();
}

class _ShowExperienceState extends State<ShowExperience> {
  @override
  void initState() {
    super.initState();
    context.read<ExperienceBloc>().add(LoadExperiences());
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  String _formatDate(String? dateString) {
    final date = _parseDate(dateString);
    if (date == null) return 'Invalid Date';
    return DateFormat('MMM yyyy').format(date);
  }

  String calculateExperience(
      String? startDate, String? endDate, bool? isCurrentlyWorking) {
    if (startDate == null || startDate.isEmpty) return 'No start date';

    try {
      final start = _parseDate(startDate);
      if (start == null) return 'Invalid start date';

      DateTime end = isCurrentlyWorking == true
          ? DateTime.now()
          : (endDate == null || endDate.isEmpty
              ? DateTime.now()
              : _parseDate(endDate) ?? DateTime.now());

      if (end.isBefore(start)) {
        return 'Invalid date range';
      }

      final totalDays = end.difference(start).inDays;

      if (totalDays < 30) {
        return '$totalDays day${totalDays != 1 ? 's' : ''}';
      }

      final years = totalDays ~/ 365;
      final months = (totalDays % 365) ~/ 30;
      final remainingDays = totalDays % 30;

      final parts = <String>[];
      if (years > 0) parts.add('$years year${years != 1 ? 's' : ''}');
      if (months > 0) parts.add('$months month${months != 1 ? 's' : ''}');
      if (remainingDays > 0 && years == 0) {
        parts.add('$remainingDays day${remainingDays != 1 ? 's' : ''}');
      }

      return parts.isEmpty ? 'Below one month' : parts.join(', ');
    } catch (e) {
      return 'Error calculating';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F2ED),
        title: const Text(
          'Work Experience',
          style: TextStyle(
            fontFamily: "Poppin",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff3F414E),
          ),
        ),
      ),
      body: BlocBuilder<ExperienceBloc, ExperienceState>(
        builder: (context, state) {
          if (state is ExperienceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExperienceError) {
            return Center(child: Text(state.message));
          } else if (state is ExperienceLoaded) {
            return _buildExperienceList(state.experiences);
          } else {
            return const Center(child: Text('No experiences found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff004673),
        onPressed: () async {
          // Navigate and wait for result
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => ExperienceBloc(ExperienceService()),
                child: ExperinceScreen(),
              ),
            ),
          );

          // If experience was added successfully, reload the experiences
          if (result == true) {
            context.read<ExperienceBloc>().add(LoadExperiences());
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExperienceList(List<Experiences> experiences) {
    if (experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No experiences added yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button to add your first experience',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return _buildExperienceCard(experience, context);
      },
    );
  }

  Widget _buildExperienceCard(Experiences experience, BuildContext context) {
    final duration = calculateExperience(
      experience.startDate,
      experience.endDate,
      experience.isCurrentlyWorking,
    );

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    experience.jobTitle ?? 'No Job Title',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteExperience(experience),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              experience.companyName ?? 'No Company Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _formatDate(experience.startDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-'),
                ),
                Text(
                  experience.isCurrentlyWorking == true
                      ? 'Present'
                      : _formatDate(experience.endDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteExperience(Experiences experience) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Experience'),
          content:
              const Text('Are you sure you want to delete this experience?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<ExperienceBloc>().add(DeleteExperience(experience.id));
    }
  }
}
