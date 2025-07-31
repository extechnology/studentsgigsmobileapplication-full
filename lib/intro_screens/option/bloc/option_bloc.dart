import 'package:flutter_bloc/flutter_bloc.dart';
import 'option_event.dart';
import 'option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  OptionBloc() : super(const OptionInitial()) {
    // Register event handlers
    on<StudentOptionSelected>(_onStudentOptionSelected);
    on<EmployerOptionSelected>(_onEmployerOptionSelected);
    on<OptionSelectionReset>(_onOptionSelectionReset);
  }

  // Handle student option selection
  Future<void> _onStudentOptionSelected(
    StudentOptionSelected event,
    Emitter<OptionState> emit,
  ) async {
    print("📚 Student option selected");

    // Emit selecting state to show loading if needed
    emit(const OptionSelecting(userType: 'student'));

    // Small delay to show selection feedback (optional)
    await Future.delayed(const Duration(milliseconds: 300));

    // Emit student selected state to trigger navigation
    emit(const StudentSelected());
  }

  // Handle employer option selection
  Future<void> _onEmployerOptionSelected(
    EmployerOptionSelected event,
    Emitter<OptionState> emit,
  ) async {
    print("🏢 Employer option selected");

    // Emit selecting state to show loading if needed
    emit(const OptionSelecting(userType: 'employer'));

    // Small delay to show selection feedback (optional)
    await Future.delayed(const Duration(milliseconds: 300));

    // Emit employer selected state to trigger navigation
    emit(const EmployerSelected());
  }

  // Handle selection reset
  void _onOptionSelectionReset(
    OptionSelectionReset event,
    Emitter<OptionState> emit,
  ) {
    print("🔄 Option selection reset");
    emit(const OptionInitial());
  }
}
