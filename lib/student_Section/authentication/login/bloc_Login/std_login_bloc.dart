import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_event.dart';
import 'package:anjalim/student_Section/authentication/login/bloc_Login/std_login_state.dart';
import 'package:anjalim/student_Section/authentication/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final result = await _loginRepository.loginUser(
        username: event.username,
        password: event.password,
      );

      if (result['success'] == true) {
        emit(LoginSuccess(
          accessToken: result['accessToken'],
          refreshToken: result['refreshToken'],
          userId: result['userId'],
          username: result['username'],
        ));
      } else {
        emit(LoginFailure(error: result['error']));
      }
    } catch (e) {
      emit(
          LoginFailure(error: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
