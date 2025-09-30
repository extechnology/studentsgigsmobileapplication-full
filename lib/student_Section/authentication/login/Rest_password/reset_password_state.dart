abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class PasswordResetOtpSent extends ForgotPasswordState {
  final String message;
  PasswordResetOtpSent({required this.message});
}

class PasswordResetOtpVerified extends ForgotPasswordState {
  final String message;
  PasswordResetOtpVerified({required this.message});
}

class PasswordResetSuccess extends ForgotPasswordState {
  final String message;
  PasswordResetSuccess({required this.message});
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  ForgotPasswordError({required this.error});
}
