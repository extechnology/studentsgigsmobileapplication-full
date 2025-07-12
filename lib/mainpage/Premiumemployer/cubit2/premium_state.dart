part of 'premium_cubit.dart';

@immutable
sealed class PremiumState {}

final class PremiumInitial extends PremiumState {}
class PremiumLoading extends PremiumState {}

class PremiumLoaded extends PremiumState {
  final Statuspremium premium;

  PremiumLoaded(this.premium);
}

class PremiumError extends PremiumState {
  final String message;

  PremiumError(this.message);
}