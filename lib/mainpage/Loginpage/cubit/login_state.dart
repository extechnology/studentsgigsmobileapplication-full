part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginIoading extends LoginState {}
final class LoginIoaded extends LoginState {
  final String name;
  final String email;

  LoginIoaded({required this.name, required this.email});
}
final class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
