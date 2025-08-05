abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class SendOTPLoading extends RegisterState {}

class SendOTPSuccess extends RegisterState {
  final String email;
  final String username;
  final String password;

  SendOTPSuccess({
    required this.email,
    required this.username,
    required this.password,
  });
}

class SendOTPFailure extends RegisterState {
  final String error;

  SendOTPFailure({required this.error});
}

class VerifyOTPLoading extends RegisterState {}

class VerifyOTPSuccess extends RegisterState {}

class VerifyOTPFailure extends RegisterState {
  final String error;

  VerifyOTPFailure({required this.error});
}

class ResendOTPLoading extends RegisterState {}

class ResendOTPSuccess extends RegisterState {
  final String message;

  ResendOTPSuccess({required this.message});
}

class ResendOTPFailure extends RegisterState {
  final String error;

  ResendOTPFailure({required this.error});
}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}
