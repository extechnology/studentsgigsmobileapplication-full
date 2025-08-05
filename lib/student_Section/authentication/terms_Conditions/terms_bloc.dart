import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_event.dart';
import 'package:anjalim/student_Section/authentication/terms_Conditions/terms_state.dart'
    show TermsState;
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsBloc extends Bloc<TermsEvent, TermsState> {
  TermsBloc() : super(TermsState()) {
    on<ToggleTermsAcceptance>(_onToggleTermsAcceptance);
  }

  void _onToggleTermsAcceptance(
    ToggleTermsAcceptance event,
    Emitter<TermsState> emit,
  ) {
    emit(state.copyWith(isAccepted: event.isAccepted));
  }
}
