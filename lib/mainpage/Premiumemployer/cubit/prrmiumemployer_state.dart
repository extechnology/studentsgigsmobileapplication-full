part of 'prrmiumemployer_cubit.dart';

@immutable
sealed class PrrmiumemployerState {}

final class PrrmiumemployerInitial extends PrrmiumemployerState {}
final class PrrmiumemployerIoading extends PrrmiumemployerState {}
final class PrrmiumemployerIoaded extends PrrmiumemployerState {
  final List<PremiumPageModel> plans;
  PrrmiumemployerIoaded(this.plans);
}
final class PrrmiumemployerError extends PrrmiumemployerState {
  final String message;
  PrrmiumemployerError(this.message);
}
