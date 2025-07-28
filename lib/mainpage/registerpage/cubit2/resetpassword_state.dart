part of 'resetpassword_cubit.dart';

@immutable
sealed class ResetpasswordState {}

final class ResetpasswordInitial extends ResetpasswordState {}
final class ResetpasswordIoading extends ResetpasswordState {}
final class ResetpasswordIoaded extends ResetpasswordState {
  final String message;

  ResetpasswordIoaded(this.message);
}
final class Resetpassworderror extends ResetpasswordState {
  final String message;

  Resetpassworderror(this.message);
}
