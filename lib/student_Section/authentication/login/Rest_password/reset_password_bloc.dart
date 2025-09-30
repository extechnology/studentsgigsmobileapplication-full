import 'package:anjalim/student_Section/authentication/login/Rest_password/reset_password_state.dart';
import 'package:anjalim/student_Section/authentication/login/Rest_password/rest_password_event.dart';
import 'package:anjalim/student_Section/authentication/other_functionalities/forgot_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordBloc({required this.repository})
      : super(ForgotPasswordInitial()) {
    on<SendPasswordResetOtpEvent>(_onSendPasswordResetOtp);
    on<VerifyPasswordResetOtpEvent>(_onVerifyPasswordResetOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendPasswordResetOtp(SendPasswordResetOtpEvent event,
      Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    final result = await repository.sendPasswordResetOtp(event.identifier);

    if (result['success']) {
      emit(PasswordResetOtpSent(message: result['message']));
    } else {
      emit(ForgotPasswordError(error: result['error']));
    }
  }

  Future<void> _onVerifyPasswordResetOtp(VerifyPasswordResetOtpEvent event,
      Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    final result =
        await repository.verifyPasswordResetOtp(event.identifier, event.otp);

    if (result['success']) {
      emit(PasswordResetOtpVerified(message: result['message']));
    } else {
      emit(ForgotPasswordError(error: result['error']));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    final result = await repository.resetPassword(
        event.identifier, event.password, event.confirmPassword);

    if (result['success']) {
      emit(PasswordResetSuccess(message: result['message']));
    } else {
      emit(ForgotPasswordError(error: result['error']));
    }
  }
}
