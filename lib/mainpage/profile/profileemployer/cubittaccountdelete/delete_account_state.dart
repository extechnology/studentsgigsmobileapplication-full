part of 'delete_account_cubit.dart';

@immutable
sealed class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}

final class DeleteAccountLoading extends DeleteAccountState {}

final class DeleteAccountOtpSent extends DeleteAccountState {
  final String message;
  DeleteAccountOtpSent(this.message);
}

final class DeleteAccountSuccess extends DeleteAccountState {
  final String message;
  DeleteAccountSuccess(this.message);
}

final class DeleteAccountError extends DeleteAccountState {
  final String error;
  DeleteAccountError(this.error);
}
