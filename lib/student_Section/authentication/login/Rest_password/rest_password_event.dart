abstract class ForgotPasswordEvent {}

class SendPasswordResetOtpEvent extends ForgotPasswordEvent {
  final String identifier;
  SendPasswordResetOtpEvent({required this.identifier});
}

class VerifyPasswordResetOtpEvent extends ForgotPasswordEvent {
  final String identifier;
  final String otp;
  VerifyPasswordResetOtpEvent({required this.identifier, required this.otp});
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String identifier;
  final String password;
  final String confirmPassword;
  ResetPasswordEvent({
    required this.identifier,
    required this.password,
    required this.confirmPassword,
  });
}
