import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String text;

  const SearchTextChanged(this.text);

  @override
  List<Object> get props => [text];
}

class ClearSearch extends SearchEvent {}
