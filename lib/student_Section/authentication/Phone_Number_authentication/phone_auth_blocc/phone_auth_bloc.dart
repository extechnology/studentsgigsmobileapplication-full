import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_blocc/phone_auth_event.dart';
import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_blocc/phone_auth_state.dart';
import 'package:anjalim/student_Section/authentication/Phone_Number_authentication/phone_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpAuthBloc extends Bloc<OtpAuthEvent, OtpAuthState> {
  final OtpAuthRepository repository;

  OtpAuthBloc({required this.repository}) : super(OtpAuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<OtpAuthState> emit) async {
    emit(OtpAuthLoading());

    final fullMobileNumber = '${event.countryCode}${event.mobileNumber}';
    final result = await repository.sendOtp(fullMobileNumber);

    if (result['success']) {
      emit(OtpSentSuccess(message: 'OTP sent successfully'));
    } else {
      emit(OtpAuthError(error: result['error']));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<OtpAuthState> emit) async {
    emit(OtpAuthLoading());

    final result = await repository.verifyOtp(event.mobileNumber, event.otp);

    if (result['success']) {
      emit(OtpVerifiedSuccess(message: 'OTP verified successfully'));
    } else {
      emit(OtpAuthError(error: result['error']));
    }
  }
}
