abstract class OtpAuthState {}

class OtpAuthInitial extends OtpAuthState {}

class OtpAuthLoading extends OtpAuthState {}

class OtpSentSuccess extends OtpAuthState {
  final String message;
  OtpSentSuccess({required this.message});
}

class OtpVerifiedSuccess extends OtpAuthState {
  final String message;
  OtpVerifiedSuccess({required this.message});
}

class OtpAuthError extends OtpAuthState {
  final String error;
  OtpAuthError({required this.error});
}
