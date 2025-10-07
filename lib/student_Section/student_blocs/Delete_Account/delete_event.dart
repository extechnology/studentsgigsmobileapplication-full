abstract class DeleteAccountEvent {}

class SendOtpEvent extends DeleteAccountEvent {
  final String email;
  SendOtpEvent(this.email);
}

class VerifyOtpEvent extends DeleteAccountEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);
}

class ResendOtpEvent extends DeleteAccountEvent {
  final String email;
  ResendOtpEvent(this.email);
}

class ResetDeleteAccountEvent extends DeleteAccountEvent {}
