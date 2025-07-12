part of 'homepagedetail_cubit.dart';

@immutable
sealed class HomepagedetailState {}

final class HomepagedetailInitial extends HomepagedetailState {}
final class HomepagedetailLoding extends HomepagedetailState {}
final class HomepagedetailLoaded extends HomepagedetailState {
  final Empleedetailpage data;
  HomepagedetailLoaded(this.data);
}
final class Homepagedetailerror extends HomepagedetailState {
  final String error;
  Homepagedetailerror(this.error);
}
