import 'dart:async';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:anjalim/student_Section/student_blocs/std_userplan/userplan_event.dart';
import 'package:anjalim/student_Section/student_blocs/std_userplan/userplan_state.dart';
import 'package:bloc/bloc.dart';

class PlanUsageBloc extends Bloc<PlanUsageEvent, PlanUsageState> {
  final PlanService _planService;

  PlanUsageBloc({required PlanService planService})
      : _planService = planService,
        super(PlanUsageInitial()) {
    on<LoadPlanUsage>(_onLoadPlanUsage);
  }

  Future<void> _onLoadPlanUsage(
    LoadPlanUsage event,
    Emitter<PlanUsageState> emit,
  ) async {
    emit(PlanUsageLoading());
    try {
      final data = await _planService.fetchUserPlans();
      emit(PlanUsageLoaded(
        planData: data['plan'],
        usageData: data['usage'],
      ));
    } catch (e) {
      emit(PlanUsageError(message: e.toString()));
    }
  }
}
