import 'package:equatable/equatable.dart';

abstract class OptionEvent extends Equatable {
  const OptionEvent();

  @override
  List<Object> get props => [];
}

// Event when user selects student option
class StudentOptionSelected extends OptionEvent {
  const StudentOptionSelected();
}

// Event when user selects employer option
class EmployerOptionSelected extends OptionEvent {
  const EmployerOptionSelected();
}

// Event to reset selection state
class OptionSelectionReset extends OptionEvent {
  const OptionSelectionReset();
}
