import 'package:anjalim/mainpage/Onboardprofile/searchpage/bloc/seach_event.dart';
import 'package:anjalim/mainpage/Onboardprofile/searchpage/bloc/seach_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchTextChanged>((event, emit) {
      emit(state.copyWith(searchText: event.text));
    });

    on<ClearSearch>((event, emit) {
      emit(state.copyWith(searchText: ''));
    });
  }
}
