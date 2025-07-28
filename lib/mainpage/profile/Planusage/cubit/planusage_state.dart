part of 'planusage_cubit.dart';

@immutable
sealed class PlanusageState {}

final class PlanusageInitial extends PlanusageState {}
final class PlanusageIoading extends PlanusageState {}
final class PlanusageIoaded extends PlanusageState {
  final Planusage data;
  PlanusageIoaded(this.data);
}
final class Planusageerror extends PlanusageState {
  final String message;
  Planusageerror(this.message);
}
