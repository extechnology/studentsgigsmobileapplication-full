part of 'delete_cubit.dart';

@immutable
sealed class DeleteState {}

final class DeleteInitial extends DeleteState {}
final class DeleteLoading extends DeleteState {}
final class DeleteobSucces extends DeleteState {}
final class DeletejobError extends DeleteState {
  final String message;
  DeletejobError(this.message);
}
