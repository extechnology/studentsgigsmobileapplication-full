abstract class OtpAuthEvent {}

class SendOtpEvent extends OtpAuthEvent {
  final String mobileNumber;
  final String countryCode;

  SendOtpEvent({required this.mobileNumber, required this.countryCode});
}

class VerifyOtpEvent extends OtpAuthEvent {
  final String mobileNumber;
  final String otp;

  VerifyOtpEvent({required this.mobileNumber, required this.otp});
}
