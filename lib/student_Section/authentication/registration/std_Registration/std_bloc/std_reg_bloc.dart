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

      // Debug log

      if (otpResult['success'] == true) {
        emit(SendOTPSuccess(
          email: event.email,
          username: event.username,
          password: event.password,
        ));
      } else {
        emit(SendOTPFailure(
            error: otpResult['message'] ?? 'Failed to send OTP'));
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

      // Debug log

      if (result['success'] == true) {
        emit(SendOTPSuccess(
          email: event.email,
          username: event.username,
          password: event.password,
        ));
      } else {
        emit(SendOTPFailure(error: result['message'] ?? 'Failed to send OTP'));
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
      // Debug log

      // First verify the OTP
      final verifyResult = await _registerRepository.verifyOTP(
        email: event.email,
        otp: event.otp,
        username: event.username,
        password: event.password,
      );

      // Debug log

      // Check if the result is boolean or a Map
      bool isVerified = false;
      String? errorMessage;

      if (verifyResult is bool) {
        isVerified = verifyResult;
      } else if (verifyResult is Map<String, dynamic>) {
        Map<String, dynamic> resultMap = verifyResult as Map<String, dynamic>;

        // Check for success field
        if (resultMap.containsKey('success')) {
          isVerified = resultMap['success'] == true;
        }
        // Check for message field (success case)
        else if (resultMap.containsKey('message')) {
          String message = resultMap['message'].toString().toLowerCase();
          isVerified = message.contains('verified') ||
              message.contains('created') ||
              message.contains('success');
        }
        // Check for error fields
        else if (resultMap.containsKey('non_field_errors')) {
          isVerified = false;
          List errors = resultMap['non_field_errors'] as List;
          errorMessage =
              errors.isNotEmpty ? errors[0].toString() : "Invalid OTP";
        } else if (resultMap.containsKey('error')) {
          isVerified = false;
          errorMessage = resultMap['error'].toString();
        }
      }

      // Debug log

      if (!isVerified) {
        emit(VerifyOTPFailure(error: errorMessage ?? "Invalid OTP"));
        return;
      }

      // Debug log

      // Since your backend message says "Account verified and created successfully"
      // it means registration is already done, so emit RegisterSuccess directly
      emit(RegisterSuccess());
    } catch (e) {
      // Debug log
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
      // Debug log

      final result = await _registerRepository.resendOTP(email: event.email);

      // Debug log

      if (result['success'] == true) {
        emit(ResendOTPSuccess(
            message: result['message'] ?? 'OTP resent successfully'));
      } else {
        emit(ResendOTPFailure(
            error: result['message'] ?? 'Failed to resend OTP'));
      }
    } catch (e) {
      // Debug log
      emit(ResendOTPFailure(
          error: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
