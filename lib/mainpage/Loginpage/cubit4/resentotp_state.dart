part of 'resentotp_cubit.dart';

@immutable
sealed class ResentotpState {}

final class ResentotpInitial extends ResentotpState {}
final class ResentotpIoading extends ResentotpState {}
final class ResentotpIoaded extends ResentotpState {}
final class Resentotperror extends ResentotpState {
  final String error;
  Resentotperror(this.error);
}
