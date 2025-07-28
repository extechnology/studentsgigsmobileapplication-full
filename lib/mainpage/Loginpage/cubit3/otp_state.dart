part of 'otp_cubit.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}
final class OtpIoading extends OtpState {

}
final class OtpIoaded extends OtpState {
  final String message;
  OtpIoaded(this.message);
}
final class Otperror extends OtpState {
  final String error;
  Otperror(this.error);
}
