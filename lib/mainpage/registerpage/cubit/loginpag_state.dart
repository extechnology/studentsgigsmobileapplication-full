part of 'loginpag_cubit.dart';

@immutable
sealed class LoginpagState {}

final class LoginpagInitial extends LoginpagState {}
final class LoginpagIoading extends LoginpagState {}
final class LoginpagIoaded extends LoginpagState {}
final class Loginpagerror extends LoginpagState {
  final String message;

  Loginpagerror(this.message);
}
