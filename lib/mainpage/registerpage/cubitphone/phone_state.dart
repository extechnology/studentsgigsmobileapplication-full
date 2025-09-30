
part of 'phone_cubit.dart';

@immutable
abstract class PhoneState {}

class PhoneInitial extends PhoneState {}

class PhoneLoading extends PhoneState {}
class PhoneVerifed2 extends PhoneState {}

class PhoneOtpSent extends PhoneState {
  final String otp;
  PhoneOtpSent({required this.otp});
}

class PhoneVerified extends PhoneState {
  final String accessToken;
  final String refreshToken;
  PhoneVerified({required this.accessToken, required this.refreshToken});
}

class PhoneError extends PhoneState {
  final String message;
  PhoneError(this.message);
}
