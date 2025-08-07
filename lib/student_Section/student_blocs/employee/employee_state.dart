import 'package:anjalim/student_Section/models_std/employeeprofile.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final StudentEmployee employee;

  const EmployeeLoaded({required this.employee});

  @override
  List<Object> get props => [employee];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError({required this.message});

  @override
  List<Object> get props => [message];
}
