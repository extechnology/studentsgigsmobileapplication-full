abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class OtpSentSuccess extends DeleteAccountState {
  final String message;
  OtpSentSuccess(this.message);
}

class OtpVerifiedSuccess extends DeleteAccountState {
  final String message;
  OtpVerifiedSuccess(this.message);
}

class DeleteAccountError extends DeleteAccountState {
  final String error;
  DeleteAccountError(this.error);
}
