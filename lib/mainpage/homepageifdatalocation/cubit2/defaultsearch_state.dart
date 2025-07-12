part of 'defaultsearch_cubit.dart';

@immutable
sealed class DefaultsearchState {}

final class DefaultsearchInitial extends DefaultsearchState {}

final class DefaultsearchLoading extends DefaultsearchState {}

final class DefaultsearchLoaded extends DefaultsearchState {
  final Locationsearch data;

  DefaultsearchLoaded({ required this.data});
}

final class DefaultsearchError extends DefaultsearchState {
  final String message;

  DefaultsearchError({required this.message});
}
