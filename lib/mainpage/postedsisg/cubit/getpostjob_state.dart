part of 'getpostjob_cubit.dart';

@immutable
sealed class GetpostjobState {}

final class GetpostjobInitial extends GetpostjobState {}
final class GetpostjobIoading extends GetpostjobState {}
final class GetpostjobIoaded extends GetpostjobState {
  final List<Job> jobs;

  GetpostjobIoaded(this.jobs);
}
final class Getpostjoberror extends GetpostjobState {
  final String message;

  Getpostjoberror(this.message);
}
