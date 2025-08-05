import 'package:anjalim/student_Section/authentication/registration/std_Registration/register.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_event.dart';
import 'package:anjalim/student_Section/authentication/registration/std_Registration/std_bloc/std_reg_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterBloc(this._registerRepository) : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<SendOTPRequested>(_onSendOTPRequested);
    on<VerifyOTPRequested>(_onVerifyOTPRequested);
    on<ResendOTPRequested>(_onResendOTPRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    // Validate passwords match
    if (event.password != event.confirmPassword) {
      emit(RegisterFailure(error: "Passwords do not match"));
      return;
    }

    emit(RegisterLoading());

    try {
      // Step 1: Send OTP
      final otpResult = await _registerRepository.sendOTP(
        email: event.email,
        username: event.username,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      if (otpResult['success']) {
        emit(SendOTPSuccess(
          email: event.email,
          username: event.username,
          password: event.password,
        ));
      } else {
        emit(SendOTPFailure(error: otpResult['message']));
      }
    } catch (e) {
      emit(RegisterFailure(
          error: "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onSendOTPRequested(
    SendOTPRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(SendOTPLoading());

    try {
      final result = await _registerRepository.sendOTP(
        email: event.email,
        username: event.username,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      if (result['success']) {
        emit(SendOTPSuccess(
          email: event.email,
          username: event.username,
          password: event.password,
        ));
      } else {
        emit(SendOTPFailure(error: result['message']));
      }
    } catch (e) {
      emit(SendOTPFailure(
          error: "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onVerifyOTPRequested(
    VerifyOTPRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(VerifyOTPLoading());

    try {
      final isVerified = await _registerRepository.verifyOTP(
        email: event.email,
        otp: event.otp,
        username: event.username,
        password: event.password,
      );

      if (isVerified) {
        emit(VerifyOTPSuccess());

        // After OTP verification, proceed with registration
        final registerResult = await _registerRepository.registerUser(
          email: event.email,
          username: event.username,
          password: event.password,
          confirmPassword: event.password, // Use same password for confirmation
        );

        if (registerResult['success']) {
          emit(RegisterSuccess());
        } else {
          emit(RegisterFailure(error: registerResult['message']));
        }
      } else {
        emit(VerifyOTPFailure(error: "Invalid OTP"));
      }
    } catch (e) {
      emit(VerifyOTPFailure(
          error: "An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onResendOTPRequested(
    ResendOTPRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(ResendOTPLoading());

    try {
      final result = await _registerRepository.resendOTP(email: event.email);

      if (result['success']) {
        emit(ResendOTPSuccess(message: result['message']));
      } else {
        emit(ResendOTPFailure(error: result['message']));
      }
    } catch (e) {
      emit(ResendOTPFailure(
          error: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
