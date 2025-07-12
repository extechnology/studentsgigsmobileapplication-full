import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboardsearch_event.dart';
part 'dashboardsearch_state.dart';

class DashboardsearchBloc extends Bloc<DashboardsearchEvent, DashboardsearchState> {
  DashboardsearchBloc() : super(DashboardsearchInitial()) {
    on<DashboardsearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
