part of 'searchclass_cubit.dart';

@immutable
abstract class SearchclassState {}

class SearchclassInitial extends SearchclassState {}

class SearchclassLoading extends SearchclassState {}

class SearchclassLoaded extends SearchclassState {
  final List<Map<String, dynamic>> data;
  SearchclassLoaded(this.data);
}

class SearchclassError extends SearchclassState {
  final String message;
  SearchclassError(this.message);
}
