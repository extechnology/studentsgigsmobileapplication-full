import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final String searchText;

  const SearchState({this.searchText = ''});

  SearchState copyWith({String? searchText}) {
    return SearchState(searchText: searchText ?? this.searchText);
  }

  @override
  List<Object> get props => [searchText];
}
