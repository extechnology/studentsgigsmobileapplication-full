import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplans/premiumplan.dart';
import 'package:anjalim/student_Section/student_blocs/premium_plans_std/premium_plans_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PremiumPlansBloc(planService: PlanService())..add(LoadPremiumPlans()),
      child: const _PremiumPlansView(),
    );
  }
}

class _PremiumPlansView extends StatelessWidget {
  const _PremiumPlansView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      appBar: AppBar(
        title: const Text(
          'Premium Plans',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xff3F414E),
          ),
        ),
        backgroundColor: const Color(0xffF9F2ED),
        elevation: 0,
      ),
      body: BlocConsumer<PremiumPlansBloc, PremiumPlansState>(
        listener: (context, state) {
          if (state is PremiumPlansLoaded && state.showUpgradeDialog) {
            _showUpgradeDialog(context, state.selectedPlan!);
          }
          if (state is PremiumPlansLoaded && state.showRestrictedDialog) {
            _showRestrictedDialog(
              context,
              state.dialogTitle!,
              state.dialogMessage!,
            );
          }
        },
        builder: (context, state) {
          if (state is PremiumPlansInitial || state is PremiumPlansLoading) {
            return _buildLoadingState();
          }

          if (state is PremiumPlansError) {
            return _buildErrorState(context, state.message);
          }

          if (state is PremiumPlansLoaded) {
            if (state.plans.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xffEB8125),
                              Color(0xffc55a5f),
                              Color(0xff004673)
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          "Unlock Your Full Potential With Premium",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPlanStatusInfo(state),
                    ],
                  ),
                ),

                // Expanded PageView to take remaining space
                Expanded(
                  child: _buildPlansPageView(context, state),
                ),

                // Dots indicator
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildDotsIndicator(context, state),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff004673)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading premium plans...',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff004673),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Error Loading Plans',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<PremiumPlansBloc>().add(LoadPremiumPlans()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff004673),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_membership,
            color: Colors.grey,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No Premium Plans Available',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStatusInfo(PremiumPlansLoaded state) {
    List<Widget> statusWidgets = [];

    // Check for current plan
    String? currentPlanName;
    for (var plan in state.plans) {
      if (state.currentPlanId != null &&
          plan['id']?.toString().toLowerCase() ==
              state.currentPlanId?.toLowerCase()) {
        currentPlanName = plan['name']?.toString();
        break;
      }
    }

    // Check for recommended plan
    String? recommendedPlanName;
    for (var plan in state.plans) {
      if (plan['recommended'] == true) {
        recommendedPlanName = plan['name']?.toString();
        break;
      }
    }

    if (currentPlanName != null) {
      statusWidgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 6),
              Text(
                'Current Plan: $currentPlanName',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffFF9500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // if (recommendedPlanName != null) {
    //   statusWidgets.add(
    //     Container(
    //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    //       decoration: BoxDecoration(
    //         color: Colors.orange,
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Icon(Icons.star, color: Colors.white, size: 16),
    //           SizedBox(width: 6),
    //           Text(
    //             'Recommended: $recommendedPlanName',
    //             style: TextStyle(
    //               fontFamily: 'Poppins',
    //               fontSize: 12,
    //               fontWeight: FontWeight.w600,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    if (statusWidgets.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: statusWidgets,
    );
  }

  Widget _buildPlansPageView(BuildContext context, PremiumPlansLoaded state) {
    final bloc = context.read<PremiumPlansBloc>();

    return PageView.builder(
      controller: bloc.pageController,
      onPageChanged: (index) {
        context.read<PremiumPlansBloc>().add(ChangePlanPage(index));
      },
      itemCount: state.plans.length,
      itemBuilder: (context, index) {
        final plan = state.plans[index];
        final isCurrentPlan = state.currentPlanId != null &&
            plan['id']?.toString().toLowerCase() ==
                state.currentPlanId?.toLowerCase();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return PremiumPlan(
                planData: plan,
                isCurrentPlan: isCurrentPlan,
                userPlanData: state.userPlanData,
                onUpgradePressed: () {
                  context.read<PremiumPlansBloc>().add(UpgradePlan(plan));
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDotsIndicator(BuildContext context, PremiumPlansLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.plans.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: state.currentPageIndex == index ? 20 : 10,
          decoration: BoxDecoration(
            color: state.currentPageIndex == index
                ? Color(0xffde2e7e)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  void _showUpgradeDialog(BuildContext context, Map<String, dynamic> plan) {
    final planId = plan['id']?.toString().toLowerCase() ?? '';
    final planName = plan['name']?.toString() ?? '';
    final planPrice = plan['price']?.toString() ?? '0';

    // Store the bloc reference before showing the dialog
    final bloc = context.read<PremiumPlansBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${planId == 'free' ? 'Select' : 'Upgrade'} Plan'),
        content: Text(
            '${planId == 'free' ? 'Select' : 'Upgrade to'} $planName plan${planPrice != '0' ? ' for Rs. $planPrice' : ''}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use the stored bloc reference instead of context.read
              bloc.add(DismissDialog());
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use the stored bloc reference instead of context.read
              bloc.add(DismissDialog());
              // Pass the original context to _processUpgrade, not dialogContext
              _processUpgrade(context, plan);
            },
            child: Text(planId == 'free' ? 'Select' : 'Upgrade'),
          ),
        ],
      ),
    );
  }

  void _showRestrictedDialog(
      BuildContext context, String title, String message) {
    // Store the bloc reference before showing the dialog
    final bloc = context.read<PremiumPlansBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use the stored bloc reference instead of context.read
              bloc.add(DismissDialog());
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _processUpgrade(BuildContext context, Map<String, dynamic> plan) {
    final planPrice = int.tryParse(plan['price']?.toString() ?? '0') ?? 0;
    final planName = plan['name']?.toString() ?? 'Unknown Plan';

    planTrigger(
      context: context,
      amount: planPrice,
      currency: "INR",
      plan: planName,
    );
  }
}
