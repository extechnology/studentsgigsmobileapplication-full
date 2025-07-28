part of 'forget_cubit.dart';

@immutable
sealed class ForgetState {}

final class ForgetInitial extends ForgetState {}
final class ForgetIoading extends ForgetState {}
final class ForgetIoaded extends ForgetState {
  final String message;
  ForgetIoaded(this.message);
}
final class ForgetError extends ForgetState {
  final String error;
  ForgetError(this.error);
}
