part of 'postregister_cubit.dart';

@immutable
sealed class PostregisterState {}

final class PostregisterInitial extends PostregisterState {}
final class PostregisterIoading extends PostregisterState {}
final class Postregisterloaded extends PostregisterState {
  final String message;
  Postregisterloaded(this.message);
}
final class Postregistererror extends PostregisterState {
  final String error;
  Postregistererror(this.error);
}
