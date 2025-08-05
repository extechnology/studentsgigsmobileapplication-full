abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;

  LoginSuccess({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
  });
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
