import 'package:equatable/equatable.dart';

abstract class OptionState extends Equatable {
  const OptionState();

  @override
  List<Object> get props => [];
}

// Initial state - no selection made
class OptionInitial extends OptionState {
  const OptionInitial();
}

// State when user is selecting an option (loading state)
class OptionSelecting extends OptionState {
  final String userType;

  const OptionSelecting({required this.userType});

  @override
  List<Object> get props => [userType];
}

// State when student option is selected - navigate to login
class StudentSelected extends OptionState {
  const StudentSelected();
}

// State when employer option is selected - navigate to login
class EmployerSelected extends OptionState {
  const EmployerSelected();
}

// State when there's an error (optional - for future use)
class OptionError extends OptionState {
  final String message;

  const OptionError({required this.message});

  @override
  List<Object> get props => [message];
}
