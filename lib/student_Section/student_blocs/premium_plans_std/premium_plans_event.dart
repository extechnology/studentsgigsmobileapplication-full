part of 'premium_plans_bloc.dart';

abstract class PremiumPlansEvent extends Equatable {
  const PremiumPlansEvent();

  @override
  List<Object> get props => [];
}

class LoadPremiumPlans extends PremiumPlansEvent {}

class ChangePlanPage extends PremiumPlansEvent {
  final int pageIndex;

  const ChangePlanPage(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

class UpgradePlan extends PremiumPlansEvent {
  final Map<String, dynamic> plan;

  const UpgradePlan(this.plan);

  @override
  List<Object> get props => [plan];
}

class ConfirmUpgrade extends PremiumPlansEvent {
  final Map<String, dynamic> plan;

  const ConfirmUpgrade(this.plan);

  @override
  List<Object> get props => [plan];
}

class DismissDialog extends PremiumPlansEvent {}
