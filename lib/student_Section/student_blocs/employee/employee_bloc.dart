import 'package:anjalim/student_Section/services/employee_detailsFeatching.dart';
import 'package:anjalim/student_Section/student_blocs/employee/employee_event.dart';
import 'package:anjalim/student_Section/student_blocs/employee/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeServices _employeeService;

  EmployeeBloc({required EmployeeServices employeeService})
      : _employeeService = employeeService,
        super(EmployeeInitial()) {
    on<LoadEmployee>(_onLoadEmployee);
  }

  Future<void> _onLoadEmployee(
    LoadEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employee = await _employeeService.fetchEmployeeDetails();
      emit(EmployeeLoaded(employee: employee));
    } catch (e) {
      emit(EmployeeError(message: e.toString()));
      //debugPrint('Error loading employee: $e');
    }
  }
}
