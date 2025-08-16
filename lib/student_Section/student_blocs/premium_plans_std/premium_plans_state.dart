part of 'premium_plans_bloc.dart';

abstract class PremiumPlansState extends Equatable {
  const PremiumPlansState();

  @override
  List<Object> get props => [];
}

class PremiumPlansInitial extends PremiumPlansState {}

class PremiumPlansLoading extends PremiumPlansState {}

class PremiumPlansLoaded extends PremiumPlansState {
  final List<Map<String, dynamic>> plans;
  final Map<String, dynamic>? userPlanData;
  final String? currentPlanId;
  final int currentPageIndex;
  final bool showUpgradeDialog;
  final bool showRestrictedDialog;
  final Map<String, dynamic>? selectedPlan;
  final String? dialogTitle;
  final String? dialogMessage;

  const PremiumPlansLoaded({
    required this.plans,
    this.userPlanData,
    this.currentPlanId,
    this.currentPageIndex = 0,
    this.showUpgradeDialog = false,
    this.showRestrictedDialog = false,
    this.selectedPlan,
    this.dialogTitle,
    this.dialogMessage,
  });

  PremiumPlansLoaded copyWith({
    List<Map<String, dynamic>>? plans,
    Map<String, dynamic>? userPlanData,
    String? currentPlanId,
    int? currentPageIndex,
    bool? showUpgradeDialog,
    bool? showRestrictedDialog,
    Map<String, dynamic>? selectedPlan,
    String? dialogTitle,
    String? dialogMessage,
  }) {
    return PremiumPlansLoaded(
      plans: plans ?? this.plans,
      userPlanData: userPlanData ?? this.userPlanData,
      currentPlanId: currentPlanId ?? this.currentPlanId,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      showUpgradeDialog: showUpgradeDialog ?? this.showUpgradeDialog,
      showRestrictedDialog: showRestrictedDialog ?? this.showRestrictedDialog,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      dialogTitle: dialogTitle ?? this.dialogTitle,
      dialogMessage: dialogMessage ?? this.dialogMessage,
    );
  }

  @override
  List<Object> get props => [
        plans,
        userPlanData ?? {},
        currentPlanId ?? '',
        currentPageIndex,
        showUpgradeDialog,
        showRestrictedDialog,
        selectedPlan ?? {},
        dialogTitle ?? '',
        dialogMessage ?? '',
      ];
}

class PremiumPlansError extends PremiumPlansState {
  final String message;

  const PremiumPlansError({required this.message});

  @override
  List<Object> get props => [message];
}
