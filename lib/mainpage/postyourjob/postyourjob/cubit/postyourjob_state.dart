// postyourjob_state.dart
part of 'postyourjob_cubit.dart';

@immutable
abstract class PostyourjobState {}

class PostyourjobInitial extends PostyourjobState {}
class PostyourjobLoading extends PostyourjobState {}
class PostyourjobSuccess extends PostyourjobState {}
class Postyourpost extends PostyourjobState {}

class PostyourjobFailure extends PostyourjobState {
  final String error;
  PostyourjobFailure({required this.error});
}


