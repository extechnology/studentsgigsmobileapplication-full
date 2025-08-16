import 'dart:async';
import 'package:anjalim/student_Section/services/profile_update_searvices/personali_details/premiumfeatch.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'premium_plans_event.dart';
part 'premium_plans_state.dart';

class PremiumPlansBloc extends Bloc<PremiumPlansEvent, PremiumPlansState> {
  final PlanService _planService;
  int _currentPageIndex = 0;
  final PageController pageController = PageController(); // Changed to public

  PremiumPlansBloc({required PlanService planService})
      : _planService = planService,
        super(PremiumPlansInitial()) {
    on<LoadPremiumPlans>(_onLoadPremiumPlans);
    on<ChangePlanPage>(_onChangePlanPage);
    on<UpgradePlan>(_onUpgradePlan);
    on<DismissDialog>(_onDismissDialog); // Add this line
  }

  Future<void> _onLoadPremiumPlans(
    LoadPremiumPlans event,
    Emitter<PremiumPlansState> emit,
  ) async {
    emit(PremiumPlansLoading());
    try {
      final plans = await fetchUserPremiumPlans();
      final userPlanData = await _planService.fetchUserPlans();
      final currentPlanId = userPlanData['current_plan']?.toString();

      emit(PremiumPlansLoaded(
        plans: plans,
        userPlanData: userPlanData,
        currentPlanId: currentPlanId,
      ));
    } catch (e) {
      emit(PremiumPlansError(message: e.toString()));
    }
  }

  void _onChangePlanPage(
    ChangePlanPage event,
    Emitter<PremiumPlansState> emit,
  ) {
    _currentPageIndex = event.pageIndex;
    if (state is PremiumPlansLoaded) {
      emit((state as PremiumPlansLoaded).copyWith(
        currentPageIndex: _currentPageIndex,
      ));
    }
  }

  Future<void> _onUpgradePlan(
    UpgradePlan event,
    Emitter<PremiumPlansState> emit,
  ) async {
    if (state is! PremiumPlansLoaded) return;

    final currentState = state as PremiumPlansLoaded;
    final plan = event.plan;
    final planId = plan['id']?.toString().toLowerCase() ?? '';

    // Check if it's a free plan and user has already used it
    if (planId == 'free' &&
        currentState.userPlanData?['has_used_free_plan'] == true) {
      emit(currentState.copyWith(
        showRestrictedDialog: true,
        dialogTitle: 'Free Plan Already Used',
        dialogMessage:
            'You have already used the free plan. Please choose a paid plan.',
      ));
      return;
    }

    emit(currentState.copyWith(
      showUpgradeDialog: true,
      selectedPlan: plan,
    ));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  void _onDismissDialog(
    DismissDialog event,
    Emitter<PremiumPlansState> emit,
  ) {
    if (state is PremiumPlansLoaded) {
      emit((state as PremiumPlansLoaded).copyWith(
        showUpgradeDialog: false,
        showRestrictedDialog: false,
      ));
    }
  }
}
