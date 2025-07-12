part of 'homepagetextformdatahave_cubit.dart';

@immutable
sealed class HomepagetextformdatahaveState {}

final class HomepagetextformdatahaveInitial extends HomepagetextformdatahaveState {}
final class HomepagetextformdatahaveIoading extends HomepagetextformdatahaveState {}
final class HomepagetextformdatahaveIoaded extends HomepagetextformdatahaveState {
  final Seachdata data;
  HomepagetextformdatahaveIoaded(this.data);
}
final class Homepagetextformdatahaveerror extends HomepagetextformdatahaveState {
  final String message;
  Homepagetextformdatahaveerror(this.message);
}
