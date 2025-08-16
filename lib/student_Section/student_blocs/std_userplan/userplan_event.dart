import 'package:equatable/equatable.dart';

abstract class PlanUsageEvent extends Equatable {
  const PlanUsageEvent();

  @override
  List<Object> get props => [];
}

class LoadPlanUsage extends PlanUsageEvent {}
