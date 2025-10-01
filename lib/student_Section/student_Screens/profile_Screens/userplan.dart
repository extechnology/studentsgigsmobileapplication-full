import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:anjalim/student_Section/student_blocs/std_userplan/userplan_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/std_userplan/userplan_event.dart';
import 'package:anjalim/student_Section/student_blocs/std_userplan/userplan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanUsagePage extends StatelessWidget {
  const PlanUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PlanUsageBloc(planService: PlanService())..add(LoadPlanUsage()),
      child: const _PlanUsageView(),
    );
  }
}

class _PlanUsageView extends StatelessWidget {
  const _PlanUsageView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        appBar: AppBar(
          title: const Text(
            "Plan Usage",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Color(0xff2D3748),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: const Color(0xffF9F2ED),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xff2D3748)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<PlanUsageBloc, PlanUsageState>(
          builder: (context, state) {
            if (state is PlanUsageInitial || state is PlanUsageLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6C5CE7)),
                ),
              );
            }

            if (state is PlanUsageError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Something went wrong",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PlanUsageBloc>().add(LoadPlanUsage()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is PlanUsageLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Header Card
                      _buildPlanHeaderCard(
                          context, state.planData, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // Usage Statistics
                      const Text(
                        "Usage Statistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2D3748),
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      JobUsageCards(
                        used:
                            state.usageData['jobs_applied']?.toString() ?? '0',
                        total: state.planData['job_applications']?.toString() ??
                            '0',
                        isSmallScreen: isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // Plan Duration
                      const Text(
                        "Plan Duration",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2D3748),
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      PlanDuration(
                        startDate: state.usageData['created_date'] ?? '',
                        endDate: state.usageData['expire_date'] ?? '',
                        isSmallScreen: isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // Remaining Days
                      Center(
                        child: RemainingDaysBadge(
                          endDate: state.usageData['expire_date'] ?? '',
                          isSmallScreen: isSmallScreen,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 20),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPlanHeaderCard(
      BuildContext context, Map<String, dynamic> planData, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: planData['name'] != 'free'
              ? [const Color(0xff004673), const Color(0xff6C5CE7)]
              : [const Color(0xff636E72), const Color(0xff2D3748)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (planData['name'] != 'free'
                    ? const Color(0xff6C5CE7)
                    : const Color(0xff636E72))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PremiumBadge(isPremium: planData['name'] != 'free'),
              Icon(
                planData['name'] != 'free'
                    ? Icons.diamond
                    : Icons.account_circle,
                color: Colors.white,
                size: isSmallScreen ? 24 : 28,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            "${planData['name']?.toString().toUpperCase() ?? 'FREE'} PLAN",
            style: TextStyle(
              fontSize: isSmallScreen ? 22 : 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            "Job Applications: ${planData['job_applications'] ?? '0'}",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.white.withOpacity(0.9),
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumBadge extends StatelessWidget {
  final bool isPremium;

  const PremiumBadge({
    super.key,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffFF9500),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        isPremium ? "PREMIUM" : "FREE",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}

// Update other widgets to accept isSmallScreen parameter and adjust accordingly
class JobUsageCards extends StatelessWidget {
  final String used;
  final String total;
  final bool isSmallScreen;

  const JobUsageCards({
    super.key,
    required this.used,
    required this.total,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final int usedInt = int.tryParse(used) ?? 0;
    final int totalInt = int.tryParse(total) ?? 1;
    final int left = totalInt - usedInt;
    final double percentage = totalInt > 0 ? (usedInt / totalInt) * 100 : 0;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xffE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff004673), Color(0xff6C5CE7)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  title: "Used",
                  value: used,
                  color: const Color(0xffFF9500),
                  isSmallScreen: isSmallScreen,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.hourglass_empty,
                  title: "Remaining",
                  value: left.toString(),
                  color: const Color(0xff00CEC9),
                  isSmallScreen: isSmallScreen,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.analytics,
                  title: "Progress",
                  value: "${percentage.toStringAsFixed(0)}%",
                  color: const Color(0xff004673),
                  isSmallScreen: isSmallScreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: const Color(0xff718096),
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xff2D3748),
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}

// Similarly update PlanDuration, PlanCard, and RemainingDaysBadge widgets to be responsive
class PlanDuration extends StatelessWidget {
  final String startDate;
  final String endDate;
  final bool isSmallScreen;

  const PlanDuration({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.isSmallScreen,
  });

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PlanCard(
            icon: Icons.play_circle_outline,
            label: "Started",
            date: _formatDate(startDate),
            color: const Color(0xff00CEC9),
            isSmallScreen: isSmallScreen,
          ),
        ),
        SizedBox(width: isSmallScreen ? 12 : 16),
        Expanded(
          child: PlanCard(
            icon: Icons.schedule,
            label: "Expires",
            date: _formatDate(endDate),
            color: const Color(0xffFD79A8),
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;
  final Color color;
  final bool isSmallScreen;

  const PlanCard({
    super.key,
    required this.icon,
    required this.label,
    required this.date,
    required this.color,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: const Color(0xff718096),
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            date,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff2D3748),
              fontFamily: "Poppins",
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RemainingDaysBadge extends StatelessWidget {
  final String endDate;
  final bool isSmallScreen;

  const RemainingDaysBadge({
    super.key,
    required this.endDate,
    required this.isSmallScreen,
  });

  int _calculateRemainingDays() {
    try {
      final expireDate = DateTime.parse(endDate);
      final now = DateTime.now();
      return expireDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingDays = _calculateRemainingDays();
    final isExpired = remainingDays < 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExpired
              ? [const Color(0xffFF6B6B), const Color(0xffFF5252)]
              : [const Color(0xff00CEC9), const Color(0xff55EFC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (isExpired ? const Color(0xffFF6B6B) : const Color(0xff00CEC9))
                    .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.warning : Icons.schedule,
            color: Colors.white,
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Text(
            isExpired
                ? "Expired ${-remainingDays} days ago"
                : "$remainingDays days remaining",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 13 : 14,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}
