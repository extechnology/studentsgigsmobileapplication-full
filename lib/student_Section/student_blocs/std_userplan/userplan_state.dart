import 'package:equatable/equatable.dart';

abstract class PlanUsageState extends Equatable {
  const PlanUsageState();

  @override
  List<Object> get props => [];
}

class PlanUsageInitial extends PlanUsageState {}

class PlanUsageLoading extends PlanUsageState {}

class PlanUsageLoaded extends PlanUsageState {
  final Map<String, dynamic> planData;
  final Map<String, dynamic> usageData;

  const PlanUsageLoaded({
    required this.planData,
    required this.usageData,
  });

  @override
  List<Object> get props => [planData, usageData];
}

class PlanUsageError extends PlanUsageState {
  final String message;

  const PlanUsageError({required this.message});

  @override
  List<Object> get props => [message];
}
